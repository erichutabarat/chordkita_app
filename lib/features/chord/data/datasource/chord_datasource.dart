import 'package:chordkita/features/chord/data/samples/chord_samples.dart';
import 'package:chordkita/features/chord/domain/entities/chord.dart';

class ChordRemoteDataSource {
  Future<Chord> getChordBySongId(int songId) async {
    await Future.delayed(
      const Duration(milliseconds: 400),
    ); // simulate network latency

    Chord? found;
    for (final c in chordSample) {
      if (c.songId == songId) {
        found = c;
        break;
      }
    }

    if (found == null) {
      throw Exception('Chord not found for song id $songId');
    }

    return found;
  }
}
