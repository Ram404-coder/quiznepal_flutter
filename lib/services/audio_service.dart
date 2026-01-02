import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  Future<void> playCorrect() async {
    if (_isMuted) return;
    await _player.play(AssetSource('audio/correct.mp3'));
  }

  Future<void> playWrong() async {
    if (_isMuted) return;
    await _player.play(AssetSource('audio/wrong.mp3'));
  }

  Future<void> playTimerBeep() async {
    if (_isMuted) return;
    await _player.play(AssetSource('audio/timer_beep.mp3'));
  }

  Future<void> playTimeUp() async {
    if (_isMuted) return;
    await _player.play(AssetSource('audio/wrong.mp3')); // Reuse wrong sound
  }

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _player.dispose();
  }
}