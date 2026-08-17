import 'package:flutter/material.dart';

class ChordSongItemData {
  final int id;
  final String songName;
  final String artistName;
  final String chordKey;
  final List<String> genres;
  final VoidCallback onTap;

  ChordSongItemData({
    required this.id,
    required this.songName,
    required this.artistName,
    required this.chordKey,
    required this.genres,
    required this.onTap,
  });
}
