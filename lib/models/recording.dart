import 'package:my_audio_flutter/models/song.dart';

class Recording {
  final String path;
  final String name;
  final String extension;
  final DateTime date;
  final String duration;
  final Song song;

  Recording({
    required this.path,
    required this.name,
    required this.extension,
    required this.date,
    required this.duration,
    required this.song,
  });

  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
      path: map['path'],
      name: map['name'],
      extension: map['extension'],
      date: DateTime.parse(map['date']),
      duration: map['duration'],
      song: Song.fromJson(map['song']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'name': name,
      'extension': extension,
      'date': date.toIso8601String(),
      'duration': duration,
      'song': song,
    };
  }
}
