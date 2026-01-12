import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'results_screen.dart';
import '../services/auth_service.dart';
import '../services/quiz_service.dart';
import '../utils/colors.dart';
import '../services/audio_service.dart'; // NEW: Import AudioService

class QuizScreen extends StatefulWidget {
  final String level;

  const QuizScreen({super.key, required this.level});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  final List<int?> _selectedAnswers = [];
  bool _isAnswered = false;

  // TIMER VARIABLES
  int _timeLeft = 20;
  Timer? _timer;
  bool _isTimerRunning = true;

  Map<String, String> get _levelTitles {
    return {
      'easy': 'Easy Level',
      'medium': 'Medium Level',
      'hard': 'Hard Level',
    };
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        if (!_isAnswered) {
          _timeUp();
        }
      }
    });
  }

  void _timeUp() {
    // Play wrong sound when time's up
    AudioService().playWrong();

    setState(() {
      _isAnswered = true;
      _isTimerRunning = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.timer_off, color: Colors.white),
            SizedBox(width: 10),
            Text('Time\'s up! ⏰'),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _resetTimer() {
    _timer?.cancel();
    _timeLeft = 20;
    _isTimerRunning = true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quizService = Provider.of<QuizService>(context);
    final questions = quizService.getQuestionsForLevel(widget.level);

    if (questions.isEmpty) {
      return _buildErrorScreen('No questions found for ${widget.level} level');
    }

    if (_currentQuestionIndex >= questions.length) {
      _currentQuestionIndex = 0;
    }

    final currentQuestion = questions[_currentQuestionIndex];

    if (currentQuestion.options.isEmpty) {
      return _buildErrorScreen('Question has no options');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_levelTitles[widget.level] ?? 'Quiz'),
        backgroundColor: NepalColors.nepalRed,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _showExitDialog,
        ),
        actions: [
          // MUTE/UNMUTE BUTTON USING AUDIOSERVICE
          IconButton(
            icon: const Icon(Icons.bug_report, color: Colors.white),
            onPressed: () {
              debugPrint("=== AudioService Debug Info ===");
              debugPrint("Testin all sound...");
              AudioService().playCorrect();
              Future.delayed(Duration(milliseconds: 500), () {
                AudioService().playWrong();
              });
              Future.delayed(Duration(milliseconds: 1000), () {
                AudioService().playFinish();
              });
              Future.delayed(Duration(milliseconds: 1500), () {
                debugPrint("=== End of AudioService Debug Info ===");
              });
            },
            tooltip: 'Debug AudioService',
          ),
          // MUTE/UNMUTE BUTTON USING AUDIOSERVICE
          IconButton(
            icon: Icon(
              AudioService().isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: () {
              AudioService().toggleMute();
              setState(() {}); // Refresh UI

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AudioService().isMuted
                      ? 'Sounds muted 🔇'
                      : 'Sounds unmuted 🔊'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: AudioService().isMuted ? 'Unmute sounds' : 'Mute sounds',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressSection(questions.length),
            const SizedBox(height: 20),
            _buildTimerDisplay(),
            const SizedBox(height: 20),
            _buildQuestionCard(currentQuestion.question),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.options.length,
                itemBuilder: (context, index) {
                  return _buildOptionTile(
                    index,
                    currentQuestion.options[index],
                    currentQuestion.correctAnswerIndex,
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (_isAnswered) _buildNextButton(questions.length),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(int totalQuestions) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / totalQuestions,
          backgroundColor: Colors.grey[300],
          color: NepalColors.nepalBlue,
          minHeight: 8,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/$totalQuestions',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            Text(
              'Score: $_score',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: NepalColors.nepalRed,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // TIMER DISPLAY WIDGET
  Widget _buildTimerDisplay() {
    Color timerColor = Colors.green;
    if (_timeLeft <= 10) timerColor = Colors.orange;
    if (_timeLeft <= 5) timerColor = Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: timerColor.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: timerColor, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.grey, size: 24),
          const SizedBox(width: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  value: _timeLeft / 20,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(timerColor),
                  strokeWidth: 4,
                ),
              ),
              Text(
                '$_timeLeft',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: timerColor,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            'seconds left',
            style: TextStyle(
              fontSize: 16,
              color: timerColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(51),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        question,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionTile(int index, String option, int correctIndex) {
    bool isSelected = _selectedAnswers.length > _currentQuestionIndex &&
        _selectedAnswers[_currentQuestionIndex] == index;

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;
    Color textColor = Colors.black;

    if (_isAnswered) {
      if (index == correctIndex) {
        backgroundColor = const Color(0xFFE8F5E9);
        borderColor = Colors.green;
        textColor = Colors.green;
      } else if (isSelected && index != correctIndex) {
        backgroundColor = const Color(0xFFFFEBEE);
        borderColor = Colors.red;
        textColor = Colors.red;
      }
    } else if (isSelected) {
      backgroundColor = const Color(0xFFE3F2FD);
      borderColor = NepalColors.nepalBlue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap:
            _isAnswered || !_isTimerRunning ? null : () => _selectAnswer(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: NepalColors.nepalBlue.withAlpha(76),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? NepalColors.nepalBlue : Colors.transparent,
                  border: Border.all(
                    color:
                        isSelected ? NepalColors.nepalBlue : Colors.grey[400]!,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isSelected
                      ? const Icon(Icons.check, size: 20, color: Colors.white)
                      : Text(
                          String.fromCharCode(65 + index),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: _isAnswered && index == correctIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              if (_isAnswered && index == correctIndex)
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
              if (_isAnswered && isSelected && index != correctIndex)
                const Icon(Icons.cancel, color: Colors.red, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(int totalQuestions) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: NepalColors.nepalRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          _currentQuestionIndex < totalQuestions - 1
              ? 'Next Question'
              : 'See Results',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    if (!_isTimerRunning) return;

    _timer?.cancel();

    setState(() {
      while (_selectedAnswers.length <= _currentQuestionIndex) {
        _selectedAnswers.add(null);
      }

      _selectedAnswers[_currentQuestionIndex] = index;

      final quizService = Provider.of<QuizService>(context, listen: false);
      final questions = quizService.getQuestionsForLevel(widget.level);

      if (_currentQuestionIndex < questions.length) {
        final currentQuestion = questions[_currentQuestionIndex];

        bool isCorrect = index == currentQuestion.correctAnswerIndex;

        // PLAY SOUND USING AUDIOSERVICE
        if (isCorrect) {
          AudioService().playCorrect();
          _score++;
        } else {
          AudioService().playWrong();
        }

        _isAnswered = true;
        _isTimerRunning = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.error,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 10),
                Text(
                  isCorrect
                      ? 'Correct! 🎉'
                      : 'Wrong! The answer is: ${currentQuestion.options[currentQuestion.correctAnswerIndex]}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            backgroundColor: isCorrect ? Colors.green : Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _nextQuestion() {
    final quizService = Provider.of<QuizService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final questions = quizService.getQuestionsForLevel(widget.level);

    if (questions.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _resetTimer();
        _startTimer();
      });
    } else {
      // PLAY FINISH SOUND USING AUDIOSERVICE
      AudioService().playFinish();

      final userEmail = authService.currentUserEmail;

      if (userEmail != null && userEmail.isNotEmpty) {
        quizService.saveScore(userEmail, widget.level, _score);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsScreen(
            score: _score,
            totalQuestions: questions.length,
            level: widget.level,
          ),
        ),
      );
    }
  }

  Widget _buildErrorScreen(String errorMessage) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_levelTitles[widget.level] ?? 'Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                'Error Loading Quiz',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back to Levels'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit Quiz'),
        content: const Text(
            'Your progress will be lost. Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Quiz'),
          ),
          TextButton(
            onPressed: () {
              _timer?.cancel();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
