import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:flutter/material.dart';

class ChordPlayerScreen extends StatefulWidget {
  const ChordPlayerScreen({super.key, required ChordSongItemData data});

  @override
  State<ChordPlayerScreen> createState() => _ChordPlayerScreenState();
}

class _ChordPlayerScreenState extends State<ChordPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("chord song player");
  }
}
