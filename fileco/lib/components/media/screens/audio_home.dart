import 'package:fileco/components/media/screens/audio_interfaceplayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../services/audio_service.dart';
import '../widgets/audio_controllerbutton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRecentlyPlayed(),
                    const SizedBox(height: 30),
                    _buildRecommendations(),
                  ],
                ),
              ),
            ),
            _buildMiniPlayer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              Text(
                'Music Player',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.search,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayed() {
    final songs = _getSampleSongs();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recently Played',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: songs.length,
            itemBuilder: (context, index) {
              final song = songs[index];
              return _buildSongCard(context, song, songs, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    final songs = _getSampleSongs().reversed.toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommended',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: songs.length,
          itemBuilder: (context, index) {
            final song = songs[index];
            return _buildListItem(context, song, songs, index);
          },
        ),
      ],
    );
  }

  Widget _buildSongCard(BuildContext context, Song song, List<Song> songs, int index) {
    return GestureDetector(
      onTap: () => _playSong(context, song, songs, index),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(song.dominantColors[0]),
                    Color(song.dominantColors[1]),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(song.dominantColors[0]).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.music_note,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              song.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              song.artist,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, Song song, List<Song> songs, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  Color(song.dominantColors[0]),
                  Color(song.dominantColors[1]),
                ],
              ),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  song.artist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            song.duration,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => _playSong(context, song, songs, index),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniPlayer(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        if (audioService.currentSong == null) {
          return const SizedBox.shrink();
        }

        final song = audioService.currentSong!;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerScreen(),
              ),
            );
          },
          child: Container(
            height: 80,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(song.dominantColors[0]),
                  Color(song.dominantColors[1]),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(song.dominantColors[0]).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        song.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ControlButton(
                  icon: Icons.skip_previous,
                  onPressed: audioService.previous,
                  size: 20,
                ),
                const SizedBox(width: 8),
                ControlButton(
                  icon: audioService.isPlaying 
                      ? Icons.pause 
                      : Icons.play_arrow,
                  onPressed: audioService.playPause,
                  size: 24,
                ),
                const SizedBox(width: 8),
                ControlButton(
                  icon: Icons.skip_next,
                  onPressed: audioService.next,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _playSong(BuildContext context, Song song, List<Song> songs, int index) {
    final audioService = Provider.of<AudioService>(context, listen: false);
    audioService.setPlaylist(songs, startIndex: index);
    audioService.play();
  }

  List<Song> _getSampleSongs() {
    return [
      Song(
        id: '1',
        title: 'Midnight Dreams',
        artist: 'Luna Echoes',
        album: 'Ethereal Nights',
        duration: '3:45',
        audioUrl: 'https://example.com/song1.mp3',
        coverUrl: 'https://example.com/cover1.jpg',
        dominantColors: [0xFF6366F1, 0xFF8B5CF6],
      ),
      Song(
        id: '2',
        title: 'Electric Pulse',
        artist: 'Neon Vibes',
        album: 'Synth Wave',
        duration: '4:12',
        audioUrl: 'https://example.com/song2.mp3',
        coverUrl: 'https://example.com/cover2.jpg',
        dominantColors: [0xFFEC4899, 0xFFEF4444],
      ),
      Song(
        id: '3',
        title: 'Ocean Breeze',
        artist: 'Coastal Harmony',
        album: 'Seaside Melodies',
        duration: '3:28',
        audioUrl: 'https://example.com/song3.mp3',
        coverUrl: 'https://example.com/cover3.jpg',
        dominantColors: [0xFF06B6D4, 0xFF3B82F6],
      ),
      Song(
        id: '4',
        title: 'Golden Hour',
        artist: 'Sunset Boulevard',
        album: 'Evening Light',
        duration: '4:56',
        audioUrl: 'https://example.com/song4.mp3',
        coverUrl: 'https://example.com/cover4.jpg',
        dominantColors: [0xFFF59E0B, 0xFFEF4444],
      ),
    ];
  }
}