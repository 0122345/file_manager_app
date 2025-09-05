import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

enum PlayMode { sequential, shuffle, repeat }
enum PlayerState { stopped, playing, paused, loading }

class AudioService extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;
  
  PlayerState _playerState = PlayerState.stopped;
  PlayMode _playMode = PlayMode.sequential;
  
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double _volume = 1.0;

  // Getters
  Song? get currentSong => _currentSong;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  PlayerState get playerState => _playerState;
  PlayMode get playMode => _playMode;
  Duration get position => _position;
  Duration get duration => _duration;
  double get volume => _volume;
  bool get isPlaying => _playerState == PlayerState.playing;
  bool get isPaused => _playerState == PlayerState.paused;
  double get progress => _duration.inMilliseconds > 0 
      ? _position.inMilliseconds / _duration.inMilliseconds 
      : 0.0;

  AudioService() {
   // _initializePlayer();
  }

  // void _initializePlayer() {
  //   _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
  //     switch (state) {
  //       case PlayerState.playing:
  //         _playerState = PlayerState.playing;
  //         break;
  //       case PlayerState.paused:
  //         _playerState = PlayerState.paused;
  //         break;
  //       case PlayerState.stopped:
  //         _playerState = PlayerState.stopped;
  //         break;
  //       case PlayerState.completed:
  //         _handleSongComplete();
  //         break;
  //     }
  //     notifyListeners();
  //   });

  //   _audioPlayer.onPositionChanged.listen((Duration position) {
  //     _position = position;
  //     notifyListeners();
  //   });

  //   _audioPlayer.onDurationChanged.listen((Duration duration) {
  //     _duration = duration;
  //     notifyListeners();
  //   });
  // }

  Future<void> setPlaylist(List<Song> songs, {int startIndex = 0}) async {
    _playlist = songs;
    _currentIndex = startIndex;
    if (songs.isNotEmpty) {
      await _loadSong(songs[startIndex]);
    }
  }

  Future<void> _loadSong(Song song) async {
    _currentSong = song;
    _playerState = PlayerState.loading;
    notifyListeners();
    
    try {
     // await _audioPlayer.setSource(UrlSource(song.audioUrl));
      _playerState = PlayerState.stopped;
    } catch (e) {
      print('Error loading song: $e');
      _playerState = PlayerState.stopped;
    }
    notifyListeners();
  }

  Future<void> play() async {
    if (_currentSong == null) return;
    
    try {
      //await _audioPlayer.resume();
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _position = Duration.zero;
  }

  Future<void> playPause() async {
    if (isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);
    notifyListeners();
  }

  Future<void> next() async {
    if (_playlist.isEmpty) return;
    
    switch (_playMode) {
      case PlayMode.sequential:
        _currentIndex = (_currentIndex + 1) % _playlist.length;
        break;
      case PlayMode.shuffle:
        _currentIndex = DateTime.now().millisecondsSinceEpoch % _playlist.length;
        break;
      case PlayMode.repeat:
        // Stay on same song
        break;
    }
    
    await _loadSong(_playlist[_currentIndex]);
    await play();
  }

  Future<void> previous() async {
    if (_playlist.isEmpty) return;
    
    if (_position.inSeconds > 3) {
      await seekTo(Duration.zero);
      return;
    }
    
    _currentIndex = _currentIndex > 0 
        ? _currentIndex - 1 
        : _playlist.length - 1;
    
    await _loadSong(_playlist[_currentIndex]);
    await play();
  }

  void setPlayMode(PlayMode mode) {
    _playMode = mode;
    notifyListeners();
  }

  void _handleSongComplete() {
    if (_playMode == PlayMode.repeat) {
      seekTo(Duration.zero);
      play();
    } else {
      next();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}