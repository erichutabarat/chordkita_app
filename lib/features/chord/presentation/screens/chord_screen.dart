import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chordkita/core/utils/chord_parser.dart';
import 'package:chordkita/features/chord/domain/repositories/chord_repository.dart';
import 'package:chordkita/features/chord/presentation/widgets/chord_skeleton.dart';
import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';

enum _LoadState { loading, error, loaded }

class ChordScreen extends StatefulWidget {
  final ChordSongItemData data;
  final ChordRepository chordRepository;

  const ChordScreen({
    super.key,
    required this.data,
    required this.chordRepository,
  });

  @override
  State<ChordScreen> createState() => _ChordScreenState();
}

class _ChordScreenState extends State<ChordScreen> {
  _LoadState _state = _LoadState.loading;
  List<ChordLine> _lines = [];
  int _transpose = 0;
  double _fontSize = 15.0;
  String? _errorMessage;

  // --- Auto-scroll state ---
  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  bool _isAutoScrolling = false;

  // Pixels moved per tick at each speed level. Index = speed level - 1.
  static const List<double> _speedSteps = [0.4, 0.8, 1.2, 1.8, 2.6, 3.6];
  int _speedLevel = 2; // 1-based index into _speedSteps (default: level 3)

  static const Duration _tickInterval = Duration(milliseconds: 40);

  @override
  void initState() {
    super.initState();
    _loadChord();
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChord() async {
    setState(() => _state = _LoadState.loading);
    try {
      final chord = await widget.chordRepository.getChordBySongId(
        widget.data.id,
      );
      final parsed = parseChordContent(chord.content);
      if (!mounted) return;
      setState(() {
        _lines = parsed;
        _state = _LoadState.loaded;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load chord. Please try again.';
        _state = _LoadState.error;
      });
    }
  }

  void _transposeUp() => setState(() => _transpose++);
  void _transposeDown() => setState(() => _transpose--);
  void _resetTranspose() => setState(() => _transpose = 0);

  void _navigateToPlayer() {
    // TODO: Add your navigation logic to the chord player screen here
  }

  // --- Auto-scroll logic ---

  void _toggleAutoScroll() {
    if (_isAutoScrolling) {
      _stopAutoScroll();
    } else {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    if (!_scrollController.hasClients) return;
    _autoScrollTimer?.cancel();
    setState(() => _isAutoScrolling = true);

    _autoScrollTimer = Timer.periodic(_tickInterval, (timer) {
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;

      if (current >= maxScroll) {
        _stopAutoScroll();
        return;
      }

      final step = _speedSteps[_speedLevel - 1];
      final newOffset = (current + step).clamp(0.0, maxScroll);
      _scrollController.jumpTo(newOffset);
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
    if (mounted) {
      setState(() => _isAutoScrolling = false);
    } else {
      _isAutoScrolling = false;
    }
  }

  void _increaseSpeed() {
    if (_speedLevel < _speedSteps.length) {
      setState(() => _speedLevel++);
    }
  }

  void _decreaseSpeed() {
    if (_speedLevel > 1) {
      setState(() => _speedLevel--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            // Pause auto-scroll if the user manually grabs the list.
            onNotification: (notification) {
              if (_isAutoScrolling &&
                  notification is ScrollStartNotification &&
                  notification.dragDetails != null) {
                _stopAutoScroll();
              }
              return false;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 12),
                  // Rounded Container Header for Song Title & Artist
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white10
                            : Colors.black.withOpacity(0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.download_for_offline_rounded,
                              color: Colors.brown,
                              size: 28,
                            ),
                            Text(
                              widget.data.songName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.favorite_rounded,
                              color: Colors.brown,
                              size: 28,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.artistName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Chord Content Area
                  _buildContent(theme, isDark),
                ],
              ),
            ),
          ),

          // Right-side Floating Auto-scroll Control
          if (_state == _LoadState.loaded)
            Positioned(
              right: 16,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerRight,
                child: _buildAutoScrollControl(theme, isDark),
              ),
            ),

          // Unified Floating Bar (Sizing + Transpose + Player Play Button)
          if (_state == _LoadState.loaded)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: _buildFloatingToolbar(theme, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildAutoScrollControl(ThemeData theme, bool isDark) {
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Speed up
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 20),
            onPressed: _speedLevel < _speedSteps.length ? _increaseSpeed : null,
            tooltip: 'Faster',
          ),

          // Speed level label
          Text(
            '${_speedLevel}x',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 4),

          // Play / Pause auto-scroll
          IconButton.filled(
            onPressed: _toggleAutoScroll,
            icon: Icon(
              _isAutoScrolling ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
            tooltip: _isAutoScrolling ? 'Pause auto-scroll' : 'Auto-scroll',
            style: IconButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),

          const SizedBox(height: 4),

          // Speed down
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
            onPressed: _speedLevel > 1 ? _decreaseSpeed : null,
            tooltip: 'Slower',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingToolbar(ThemeData theme, bool isDark) {
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. Text Sizing Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.text_decrease_rounded, size: 18),
                onPressed: _fontSize > 12
                    ? () => setState(() => _fontSize -= 1)
                    : null,
              ),
              Text(
                '${_fontSize.toInt()}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.text_increase_rounded, size: 18),
                onPressed: _fontSize < 24
                    ? () => setState(() => _fontSize += 1)
                    : null,
              ),
            ],
          ),

          SizedBox(
            height: 24,
            child: VerticalDivider(
              width: 1,
              color: isDark ? Colors.white24 : Colors.black12,
            ),
          ),

          // 2. Transpose Controls
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: _transposeDown,
                icon: const Icon(Icons.remove_rounded, size: 18),
              ),
              GestureDetector(
                onTap: _resetTranspose,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    _transpose == 0
                        ? 'KEY'
                        : (_transpose > 0 ? '+$_transpose' : '$_transpose'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: _transposeUp,
                icon: const Icon(Icons.add_rounded, size: 18),
              ),
            ],
          ),

          SizedBox(
            height: 24,
            child: VerticalDivider(
              width: 1,
              color: isDark ? Colors.white24 : Colors.black12,
            ),
          ),

          // 3. Chord Player Navigation Button
          IconButton.filled(
            onPressed: _navigateToPlayer,
            icon: const Icon(Icons.play_arrow_rounded),
            tooltip: 'Open Chord Player',
            style: IconButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme, bool isDark) {
    switch (_state) {
      case _LoadState.loading:
        return const ChordSkeleton();

      case _LoadState.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: 12),
                Text(
                  _errorMessage ?? 'Something went wrong',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _loadChord,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        );

      case _LoadState.loaded:
        return SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _lines
                .map((line) => _buildLine(line, theme, isDark))
                .toList(),
          ),
        );
    }
  }

  Widget _buildLine(ChordLine line, ThemeData theme, bool isDark) {
    switch (line.type) {
      case ChordLineType.blank:
        return SizedBox(height: _fontSize * 1.2);
      case ChordLineType.section:
        return _buildSectionLine(line.segments, theme, isDark);
      case ChordLineType.lyric:
        return _buildLyricLine(line.segments, theme, isDark);
    }
  }

  Widget _buildLyricLine(
    List<ChordSegment> segments,
    ThemeData theme,
    bool isDark,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: _fontSize * 0.5),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        children: segments.map((segment) {
          final chordLabel = segment.chord != null
              ? transposeChord(segment.chord!, _transpose)
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Exact height box so text stays perfectly inline underneath
              SizedBox(
                height: _fontSize * 1.2,
                child: chordLabel != null
                    ? Text(
                        chordLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: _fontSize * 0.95,
                          color: theme.colorScheme.primary,
                        ),
                      )
                    : null,
              ),
              Text(
                segment.text,
                style: TextStyle(fontSize: _fontSize, height: 1.1),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionLine(
    List<ChordSegment> segments,
    ThemeData theme,
    bool isDark,
  ) {
    final primaryColor = theme.colorScheme.primary;

    final label = (segments.isNotEmpty && segments.first.chord == null)
        ? segments.first.text.trim()
        : '';

    final chords = segments
        .where((s) => s.chord != null)
        .map((s) => s.chord!)
        .toList();

    final trailingNote = segments.isNotEmpty && segments.last.chord != null
        ? segments.last.text.trim()
        : '';

    return Container(
      margin: EdgeInsets.only(top: _fontSize * 0.4, bottom: _fontSize * 0.6),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: _fontSize * 0.4),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: primaryColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                fontSize: _fontSize * 0.95,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: primaryColor,
              ),
            ),
          if (chords.isNotEmpty) ...[
            if (label.isNotEmpty) SizedBox(height: _fontSize * 0.35),
            Wrap(
              spacing: _fontSize * 0.6, // gap between chords
              runSpacing: _fontSize * 0.3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ...chords.map(
                  (chord) => _buildChordChip(
                    transposeChord(chord, _transpose),
                    primaryColor,
                  ),
                ),
                if (trailingNote.isNotEmpty)
                  Text(
                    trailingNote,
                    style: TextStyle(
                      fontSize: _fontSize * 0.8,
                      fontStyle: FontStyle.italic,
                      color: primaryColor.withOpacity(0.75),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChordChip(String chordLabel, Color primaryColor) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _fontSize * 0.5,
        vertical: _fontSize * 0.15,
      ),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        chordLabel,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: _fontSize * 0.85,
          color: primaryColor,
        ),
      ),
    );
  }
}
