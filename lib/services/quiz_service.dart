import 'package:flutter/material.dart';


class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String difficulty;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.difficulty,
  });
}

class QuizService extends ChangeNotifier {
  // EASY QUESTIONS - NEPAL
  List<QuizQuestion> easyQuestions = [
    QuizQuestion(
      question: "Which country is known as the country of living gods?",
      options: ["India", "Nepal", "China", "Japan"],
      correctAnswerIndex: 1,
      difficulty: "easy",
    ),
    QuizQuestion(
      question: "What is the capital city of Nepal?",
      options: ["Pokhara", "Kathmandu", "Biratnagar", "Lalitpur"],
      correctAnswerIndex: 1,
      difficulty: "easy",
    ),
    QuizQuestion(
      question: "What is the highest mountain in Nepal?",
      options: ["K2", "Kanchenjunga", "Mount Everest", "Annapurna"],
      correctAnswerIndex: 2,
      difficulty: "easy",
    ),
    QuizQuestion(
      question: "What is the official language of Nepal?",
      options: ["Hindi", "English", "Nepali", "Newari"],
      correctAnswerIndex: 2,
      difficulty: "easy",
    ),
    QuizQuestion(
      question: "What is the national animal of Nepal?",
      options: ["Bengal Tiger", "Snow Leopard", "Cow", "Rhinoceros"],
      correctAnswerIndex: 2,
      difficulty: "easy",
    ),
    QuizQuestion(
      question: "What shape is the flag of Nepal?",
      options: ["Rectangle", "Square", "Triangle", "Two triangles"],
      correctAnswerIndex: 3, // Two triangles
      difficulty: "easy",
    ),
    QuizQuestion(
      question: "Which city is known as the 'City of Lakes' in Nepal?",
      options: ["Kathmandu", "Pokhara", "Chitwan", "Bhaktapur"],
      correctAnswerIndex: 1,
      difficulty: "easy",
    ),
  ];

  // MEDIUM QUESTIONS - NEPAL
  List<QuizQuestion> mediumQuestions = [
    QuizQuestion(
      question: "What is the currency of Nepal?",
      options: ["Rupee", "Taka", "Ngultrum", "Nepalese Dollar"],
      correctAnswerIndex: 0, // Rupee
      difficulty: "medium",
    ),
    QuizQuestion(
      question: "When is Nepal's National Day (Republic Day)?",
      options: ["September 20", "May 29", "January 11", "December 28"],
      correctAnswerIndex: 1,
      difficulty: "medium",
    ),
    QuizQuestion(
      question: "Which famous warrior was born in Nepal?",
      options: ["Shivaji", "Rana Pratap", "Bhima", "Prithvi Narayan Shah"],
      correctAnswerIndex: 3,
      difficulty: "medium",
    ),
    QuizQuestion(
      question: "What is the Main festival of Nepal called?",
      options: ["Dashain", "Tihar", "Bisket Jatra", "Holi"],
      correctAnswerIndex: 0, // Dashain
      difficulty: "medium",
    ),
    QuizQuestion(
      question: "Which lake in Nepal is known as 'Lake of Nine Corners'?",
      options: ["Phewa Lake", "Rara Lake", "Begnas Lake", "Gosaikunda"],
      correctAnswerIndex: 0,
      difficulty: "medium",
    ),
    QuizQuestion(
      question: "Which is the main religion in Nepal?",
      options: ["Hinduism", "Buddhism", "Islam", "Christianity"],
      correctAnswerIndex: 0,
      difficulty: "medium",
    ),
    QuizQuestion(
      question:
          "How many of the world's top 10 highest mountains are in Nepal?",
      options: ["14", "10", "12", "8"],
      correctAnswerIndex: 3,
      difficulty: "medium",
    ),
    QuizQuestion(
      question:
          "How much time is Nepali calendar ahead of the Gregorian calendar?",
      options: [" 10 Years", "30 Years", "26 Years", "56 Years"],
      correctAnswerIndex: 3,
      difficulty: "medium",
    ),
  ];

  // HARD QUESTIONS - NEPAL
  List<QuizQuestion> hardQuestions = [
    QuizQuestion(
      question:
          "In which year and where was spritual leader Gautam Buddha was born in Nepal?",
      options: [
        "623 BC in Lumbini",
        "563 BC in Kathmandu",
        "483 BC in Kapilvastu",
        "400 BC in Ramechhap"
      ],
      correctAnswerIndex: 0,
      difficulty: "hard",
    ),
    QuizQuestion(
      question: "In which year did Nepal become a republic?",
      options: ["2006", "2008", "2010", "2015"],
      correctAnswerIndex: 1,
      difficulty: "hard",
    ),
    QuizQuestion(
      question: "What is the height of Mount Everest in meters?",
      options: ["8,848 m", "8,586 m", "8,611 m", "8,998 m"],
      correctAnswerIndex: 0,
      difficulty: "hard",
    ),
    QuizQuestion(
      question:
          "Which UNESCO World Heritage Site in Nepal is known as the 'Monkey Temple'?",
      options: [
        "Pashupatinath",
        "Boudhanath",
        "Swayambhunath",
        "Changunarayan"
      ],
      correctAnswerIndex: 2,
      difficulty: "hard",
    ),
    QuizQuestion(
      question: "What is the traditional Nepali cap called?",
      options: ["Topi", "Pagri", "Dhaka", "Bhadgaunle"],
      correctAnswerIndex: 2,
      difficulty: "hard",
    ),
    QuizQuestion(
      question: "Which river in Nepal is considered holy by Hindus?",
      options: ["Karnali", "Bagmati", "Koshi", "Gandaki"],
      correctAnswerIndex: 1,
      difficulty: "hard",
    ),
    QuizQuestion(
      question: "Who is considered the founder of modern Nepal?",
      options: [
        "Laxmi Prasad Devkota",
        "Bhimsen Thapa",
        "Prithvi Narayan Shah",
        "King Mahendra"
      ],
      correctAnswerIndex: 2,
      difficulty: "hard",
    ),
    QuizQuestion(
      question:
          "Which of the following glaciers is the largest in Nepal, stretching over 35 kilometers?",
      options: [
        "Khumbu Glacier",
        "Rongbuk Glacier",
        "Ngozumpa Glacier",
        "Lirung Glacier"
      ],
      correctAnswerIndex: 2,
      difficulty: "hard",
    ),
  ];

  // User progress tracking
  final Map<String, Map<String, dynamic>> userProgress = {};

  void saveScore(String email, String level, int score) {
    if (email.isEmpty) return;

    if (!userProgress.containsKey(email)) {
      userProgress[email] = {};
    }

    userProgress[email]![level] = {
      'score': score,
      'maxScore': getQuestionsForLevel(level).length,
      'date': DateTime.now(),
    };

    notifyListeners();
  }

  List<QuizQuestion> getQuestionsForLevel(String level) {
    if (level == 'easy') return easyQuestions;
    if (level == 'medium') return mediumQuestions;
    if (level == 'hard') return hardQuestions;
    return easyQuestions;
  }

  Map<String, dynamic>? getUserProgress(String email, String level) {
    if (userProgress.containsKey(email) &&
        userProgress[email]!.containsKey(level)) {
      return userProgress[email]![level];
    }
    return null;
  }
}
