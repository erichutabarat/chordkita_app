class Chord {
  final int id;
  final int songId;
  final String content;

  const Chord({required this.id, required this.songId, required this.content});

  factory Chord.fromJson(Map<String, dynamic> json) {
    return Chord(
      id: json['id'] as int,
      songId: json['song_id'] as int,
      content: json['content'] as String,
    );
  }
}
