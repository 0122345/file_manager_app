import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/audio_service.dart';
import '../widgets/audio_controllerbutton.dart';
import '../widgets/audio_playbutton.dart';
import '../widgets/audio_slider.dart';
 

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );
    
    _scaleController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audioService, child) {
        final song = audioService.currentSong;
        
        if (song == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF0A0A0A),
            body: Center(
              child: Text(
                'No song selected',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        }

        // Control rotation animation based on play state
        if (audioService.isPlaying) {
          _rotationController.repeat();
        } else {
          _rotationController.stop();
        }

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(song.dominantColors[0]).withOpacity(0.8),
                  Color(song.dominantColors[1]).withOpacity(0.6),
                  const Color(0xFF0A0A0A),
                  const Color(0xFF000000),
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        children: [
                          const Spacer(),
                          _buildAlbumArt(song),
                          const SizedBox(height: 48),
                          _buildSongInfo(song),
                          const SizedBox(height: 32),
                          _buildProgressBar(audioService),
                          const SizedBox(height: 48),
                          _buildControls(audioService),
                          const SizedBox(height: 32),
                          _buildVolumeControl(audioService),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Text(
            'Now Playing',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumArt(song) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * 3.14159,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
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
                        color: Color(song.dominantColors[0]).withOpacity(0.4),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Vinyl record effect
                      Center(
                        child: Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.1),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26,
                          ),
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSongInfo(song) {
    return Column(
      children: [
        Text(
          song.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          song.artist,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          song.album,
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProgressBar(AudioService audioService) {
    return Column(
      children: [
        CustomSlider(
          value: audioService.progress,
          onChanged: (value) {
            final position = Duration(
              milliseconds: (value * audioService.duration.inMilliseconds).toInt(),
            );
            audioService.seekTo(position);
          },
          activeColor: Colors.white,
          inactiveColor: Colors.white30,
          thumbColor: Colors.white,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(audioService.position),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            Text(
              _formatDuration(audioService.duration),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControls(AudioService audioService) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ControlButton(
          icon: _getShuffleIcon(audioService.playMode),
          onPressed: () => _togglePlayMode(audioService),
          size: 24,
          color: Colors.white,
        ),
        ControlButton(
          icon: Icons.skip_previous,
          onPressed: audioService.previous,
          size: 32,
          color: Colors.white,
        ),
        AnimatedPlayButton(
          isPlaying: audioService.isPlaying,
          onPressed: audioService.playPause,
          size: 80,
          color: Colors.white,
        ),
        ControlButton(
          icon: Icons.skip_next,
          onPressed: audioService.next,
          size: 32,
          color: Colors.white,
        ),
        ControlButton(
          icon: Icons.favorite_border,
          onPressed: () {
            // TODO: Implement favorite functionality
          },
          size: 24,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget _buildVolumeControl(AudioService audioService) {
    return Row(
      children: [
        const Icon(
          Icons.volume_down,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomSlider(
            value: audioService.volume,
            onChanged: audioService.setVolume,
            activeColor: Colors.white70,
            inactiveColor: Colors.white30,
            thumbColor: Colors.white,
            height: 3,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(
          Icons.volume_up,
          color: Colors.white70,
          size: 20,
        ),
      ],
    );
  }

  IconData _getShuffleIcon(PlayMode playMode) {
    switch (playMode) {
      case PlayMode.sequential:
        return Icons.repeat;
      case PlayMode.shuffle:
        return Icons.shuffle;
      case PlayMode.repeat:
        return Icons.repeat_one;
    }
  }

  void _togglePlayMode(AudioService audioService) {
    switch (audioService.playMode) {
      case PlayMode.sequential:
        audioService.setPlayMode(PlayMode.shuffle);
        break;
      case PlayMode.shuffle:
        audioService.setPlayMode(PlayMode.repeat);
        break;
      case PlayMode.repeat:
        audioService.setPlayMode(PlayMode.sequential);
        break;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
}
 