import 'package:fileco/components/media/models/song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final List<Song> songs;
  final String coverUrl;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.songs,
    required this.coverUrl,
  });

  int get songCount => songs.length;
  
  String get totalDuration {
    // Calculate total duration from all songs
    int totalMinutes = songs.fold(0, (sum, song) {
      final parts = song.duration.split(':');
      return sum + int.parse(parts[0]) * 60 + int.parse(parts[1]);
    });
    return '${totalMinutes ~/ 60}:${(totalMinutes % 60).toString().padLeft(2, '0')}';
  }
}