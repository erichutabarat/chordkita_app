import 'package:chordkita/features/chord/data/datasource/chord_datasource.dart';
import 'package:chordkita/features/chord/domain/entities/chord.dart';
import 'package:chordkita/features/chord/domain/repositories/chord_repository.dart';

class ChordRepositoryImpl implements ChordRepository {
  final ChordRemoteDataSource _remoteDataSource;

  ChordRepositoryImpl(this._remoteDataSource);

  @override
  Future<Chord> getChordBySongId(int songId) {
    return _remoteDataSource.getChordBySongId(songId);
  }
}
