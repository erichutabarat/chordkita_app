import 'package:flutter/material.dart';
import 'package:chordkita/core/utils/chord_parser.dart';
import 'package:chordkita/features/chord/domain/repositories/chord_repository.dart';
import 'package:chordkita/features/chord/presentation/widgets/chord_skeleton.dart';
import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';

enum _LoadState { loading, error, loaded }

class ChordScreen extends StatefulWidget {
  final ChordSongItemData data;
  // Inject the repository for now (constructor injection). Swap this for
  // Riverpod/get_it later without touching anything below - the repository
  // interface is what matters, not how it's provided.
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
  List<List<ChordSegment>> _lines = [];
  int _transpose = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadChord();
  }

  Future<void> _loadChord() async {
    setState(() => _state = _LoadState.loading);
    try {
      final chord = await widget.chordRepository.getChordBySongId(
        widget.data.id,
      );
      // Parse ONCE here. Transpose below never re-parses - it only shifts
      // the chord value at render time.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ChordKita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            // Header (song data)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.data.songName,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.data.artistName,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Transpose tools
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: _state == _LoadState.loaded
                      ? _transposeDown
                      : null,
                  icon: const Icon(Icons.arrow_downward_rounded),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 90,
                  child: Text(
                    _transpose == 0
                        ? 'Original key'
                        : (_transpose > 0 ? '+$_transpose' : '$_transpose'),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filled(
                  onPressed: _state == _LoadState.loaded ? _transposeUp : null,
                  icon: const Icon(Icons.arrow_upward_rounded),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case _LoadState.loading:
        return const ChordSkeleton();

      case _LoadState.error:
        return Column(
          children: [
            Text(
              _errorMessage ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadChord, child: const Text('Retry')),
          ],
        );

      case _LoadState.loaded:
        return Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: _lines.map(_buildLine).toList(),
          ),
        );
    }
  }

  Widget _buildLine(List<ChordSegment> segments) {
    // A line with a single null-chord empty-text segment is a blank line
    // in the original lyrics - render it as vertical spacing, not empty text.
    if (segments.length == 1 &&
        segments.first.chord == null &&
        segments.first.text.trim().isEmpty) {
      return const SizedBox(height: 16);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
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
              SizedBox(
                height: 18,
                child: chordLabel != null
                    ? Text(
                        chordLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      )
                    : null,
              ),
              Text(segment.text),
            ],
          );
        }).toList(),
      ),
    );
  }
}
