class Song {
  final String title;
  final String lyrics;
  final int seconds;
  final int tempo;

  Song({
    required this.title,
    this.lyrics = '',
    this.seconds = 0,
    this.tempo = 0,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['title'],
      lyrics: json['lyrics'],
      seconds: json['lyrics'],
      tempo: json['lyrics'],
    );
  }
}
