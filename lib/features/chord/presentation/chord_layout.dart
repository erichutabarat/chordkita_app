import 'package:chordkita/features/chord/presentation/screens/chord_player_screen.dart';
import 'package:chordkita/features/chord/presentation/screens/chord_screen.dart';
import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:flutter/material.dart';

class ChordLayout extends StatefulWidget {
  final ChordSongItemData data;
  const ChordLayout({super.key, required this.data});

  @override
  State<ChordLayout> createState() => _ChordLayoutState();
}

class _ChordLayoutState extends State<ChordLayout> {
  int _currentPage = 0;

  Widget get _currentScreen {
    switch (_currentPage) {
      case 0:
        return ChordScreen(data: widget.data);

      case 1:
        return ChordPlayerScreen(data: widget.data);

      default:
        return ChordScreen(data: widget.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _currentScreen),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToChordPlayer,
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }

  void _goToChordPlayer() {
    setState(() {
      _currentPage = 1;
    });
  }
}
