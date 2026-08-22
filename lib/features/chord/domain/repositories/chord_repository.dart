import 'package:chordkita/features/chord/domain/entities/chord.dart';

abstract class ChordRepository {
  Future<Chord> getChordBySongId(int songId);
}
