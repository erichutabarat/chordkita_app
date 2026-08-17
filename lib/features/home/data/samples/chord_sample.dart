import 'package:chordkita/features/home/domain/entities/chordsong_item.dart';
import 'package:flutter/foundation.dart';

final newlyAddedSongs = [
  ChordSongItemData(
    id: 1,
    songName: 'Akad',
    artistName: 'Payung Teduh',
    chordKey: 'C',
    genres: ['Pop', 'Acoustic', 'Indie'],
    // ignore: avoid_print
    onTap: () => print('Clicked Akad'),
  ),
  ChordSongItemData(
    id: 2,
    songName: 'Sempurna',
    artistName: 'Andra and The Backbone',
    chordKey: 'A',
    genres: ['Rock', 'Ballad'],
    // ignore: avoid_print
    onTap: () => print('Clicked Sempurna'),
  ),
  ChordSongItemData(
    id: 3,
    songName: 'Zona Nyaman',
    artistName: 'Fourtwnty',
    chordKey: 'F',
    genres: ['Indie', 'Folk'],
    // ignore: avoid_print
    onTap: () => print('Clicked Zona Nyaman'),
  ),
];

final topSongs = [
  ChordSongItemData(
    id: 1,
    songName: 'Akad',
    artistName: 'Payung Teduh',
    chordKey: 'C',
    genres: ['Pop', 'Acoustic', 'Indie'],
    onTap: () {
      if (kDebugMode) {
        print('Clicked Akad');
      }
    },
  ),
  ChordSongItemData(
    id: 2,
    songName: 'Sempurna',
    artistName: 'Andra and The Backbone',
    chordKey: 'A',
    genres: ['Rock', 'Ballad'],
    onTap: () {
      if (kDebugMode) {
        print('Clicked Sempurna');
      }
    },
  ),
  ChordSongItemData(
    id: 3,
    songName: 'Zona Nyaman',
    artistName: 'Fourtwnty',
    chordKey: 'F',
    genres: ['Indie', 'Folk'],
    onTap: () {
      if (kDebugMode) {
        print('Clicked Zona Nyaman');
      }
    },
  ),
];
