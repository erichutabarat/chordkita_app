import 'package:chordkita/features/chord/domain/entities/chord.dart';
import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:flutter/material.dart';

class ChordScreen extends StatefulWidget {
  final ChordSongItemData data;
  const ChordScreen({super.key, required this.data});

  @override
  State<ChordScreen> createState() => _ChordScreenState();
}

class _ChordScreenState extends State<ChordScreen> {
  late Chord _chord;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header (for song data)
            Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.data.songName),
                  SizedBox(height: 12),
                  Text(widget.data.artistName),
                ],
              ),
            ),
            SizedBox(height: 12),
            // Transpose Tools
            Container(
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => {},
                    child: Icon(Icons.arrow_upward_rounded),
                  ),
                  SizedBox(width: 8),
                  Text("Transpose"),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Icon(Icons.arrow_downward_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
