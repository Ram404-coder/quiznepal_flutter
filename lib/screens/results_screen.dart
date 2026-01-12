import 'package:flutter/material.dart';
import 'level_selection_screen.dart';
import '../utils/colors.dart';
import '../services/audio_service.dart'; // Import AudioService

// results_screen.dart
class ResultsScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final String level;

  const ResultsScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.level,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

// state class for ResultsScreen
class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    // play result sound after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playResultSound();
    });
  }

  // play sound based on performance
  void _playResultSound() {
    if (_percentage >= 80) {
      AudioService().playFinish(); // Excellent score
    } else if (_percentage >= 60) {
      AudioService().playCorrect(); // Good score
    }
    // No sound for low scores
  }

  String get _levelTitle {
    return {
          'easy': 'Easy',
          'medium': 'Medium',
          'hard': 'Hard',
        }[widget.level] ??
        widget.level;
  }

  // CALCULATE PERCENTAGE SCORE
  int get _percentage => ((widget.score / widget.totalQuestions) * 100).round();

  String get _performanceText {
    if (_percentage >= 80) return '💡 Excellent!💡';
    if (_percentage >= 60) return '😊 Good Job!😊';
    if (_percentage >= 40) return '🫥 Not Bad!🫥';
    return '📖 Keep Practicing! 📖';
  }

  Color get _performanceColor {
    if (_percentage >= 80) return Colors.green;
    if (_percentage >= 60) return Colors.orange;
    if (_percentage >= 40) return Colors.blue;
    return Colors.red;
  }

  // build to render results screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: NepalColors.nepalRed,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Score Circle
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _performanceColor.withAlpha((255 * 0.1).toInt()),
                  border: Border.all(color: _performanceColor, width: 3),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$_percentage%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _performanceColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.score}/${widget.totalQuestions}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Performance Text
              Text(
                _performanceText,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You completed the $_levelTitle level',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 30),

              // Stats Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat('Correct', widget.score, Colors.green),
                    _buildStat('Wrong', widget.totalQuestions - widget.score,
                        Colors.red),
                    _buildStat('Total', widget.totalQuestions, Colors.blue),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Back to Levels Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LevelSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: NepalColors.nepalRed,
                  ),
                  child: const Text(
                    'BACK TO LEVELS',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Try Another Level Button
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LevelSelectionScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Try Another Level',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Build stat item widget
  Widget _buildStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
