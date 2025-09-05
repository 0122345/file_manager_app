class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String duration;
  final String audioUrl;
  final String coverUrl;
  final List<int> dominantColors;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.audioUrl,
    required this.coverUrl,
    this.dominantColors = const [0xFF6366F1, 0xFF8B5CF6],
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      album: json['album'] ?? '',
      duration: json['duration'] ?? '0:00',
      audioUrl: json['audioUrl'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      dominantColors: List<int>.from(json['dominantColors'] ?? [0xFF6366F1, 0xFF8B5CF6]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'audioUrl': audioUrl,
      'coverUrl': coverUrl,
      'dominantColors': dominantColors,
    };
  }
}
