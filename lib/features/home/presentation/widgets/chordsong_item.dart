import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:flutter/material.dart';

class ChordsongItem extends StatelessWidget {
  final ChordSongItemData data;
  const ChordsongItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(data.songName),
            subtitle: Text(data.artistName),
            trailing: Text(data.chordKey),
            onTap: () => _goToChord(context),
          ),
          const Divider(),
        ],
      ),
    );
  }

  void _goToChord(BuildContext context) {
    Navigator.pushNamed(context, '/chord', arguments: data);
  }
}
