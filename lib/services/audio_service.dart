import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isMuted = false;

  Future<void> initialize() async {
    debugPrint('🎵 AudioService initializing...');

    // Just mark as ready without preloading
    debugPrint('✅ AudioService ready');
  }

  Future<void> playCorrect() async {
    if (_isMuted) return;
    await _playSound('correct.mp3');
  }

  Future<void> playWrong() async {
    if (_isMuted) return;
    await _playSound('wrong.mp3');
  }

  Future<void> playFinish() async {
    if (_isMuted) return;
    await _playSound('finish.mp3');
  }

  Future<void> playTimerBeep() async {
    if (_isMuted) return;
    await _playSound('timer_beep.mp3');
  }

  Future<void> _playSound(String fileName) async {
    if (_isMuted) return;

    try {
      debugPrint('🔊 Playing: $fileName');
      await _player.play(AssetSource('audio/$fileName'));
    } catch (e) {
      debugPrint('❌ Error playing $fileName: $e');
    }
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    debugPrint(_isMuted ? '🔇 Muted' : '🔊 Unmuted');
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _player.dispose();
    debugPrint('♻️ AudioService disposed');
  }
}
