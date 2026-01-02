import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/quiz_service.dart'; // Keep this

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final quizService = Provider.of<QuizService>(context);
    final userEmail = authService.currentUserEmail ?? '';

    // Get progress for each level
    final easyProgress = quizService.getUserProgress(userEmail, 'easy');
    final mediumProgress = quizService.getUserProgress(userEmail, 'medium');
    final hardProgress = quizService.getUserProgress(userEmail, 'hard');

    // Calculate total score
    int getTotalScore() {
      int total = 0;
      if (easyProgress != null && easyProgress['score'] != null) {
        total += easyProgress['score'] as int;
      }
      if (mediumProgress != null && mediumProgress['score'] != null) {
        total += mediumProgress['score'] as int;
      }
      if (hardProgress != null && hardProgress['score'] != null) {
        total += hardProgress['score'] as int;
      }
      return total;
    }

    // Calculate levels completed
    int getLevelsCompleted() {
      int completed = 0;
      if (easyProgress != null) completed++;
      if (mediumProgress != null) completed++;
      if (hardProgress != null) completed++;
      return completed;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getUsername(userEmail),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _buildStatItem('Total Score', '${getTotalScore()}'),
                            const SizedBox(width: 20),
                            _buildStatItem(
                              'Levels Completed',
                              '${getLevelsCompleted()}/3',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Progress Section Header
            const Text(
              'Your Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // Progress Cards
            Expanded(
              child: ListView(
                children: [
                  _buildProgressCard(
                    'Easy Level',
                    easyProgress,
                    Colors.green,
                    Icons.star_border,
                  ),
                  _buildProgressCard(
                    'Medium Level',
                    mediumProgress,
                    Colors.orange,
                    Icons.star_half,
                  ),
                  _buildProgressCard(
                    'Hard Level',
                    hardProgress,
                    Colors.red,
                    Icons.star,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to extract username from email
  String _getUsername(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email;
  }

  // Build statistic item widget
  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Build progress card widget
  Widget _buildProgressCard(
    String title,
    Map<String, dynamic>? progress,
    Color color,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green.withAlpha((255 * 0.1).toInt()),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color),
            ),

            const SizedBox(width: 16),

            // Progress Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (progress != null && progress['score'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'Score: ${progress['score']}/${progress['maxScore'] ?? 'N/A'}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Date: ${_formatDate(progress['date'])}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  else
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Not attempted yet',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Status Icon
            Icon(
              progress != null ? Icons.check_circle : Icons.hourglass_empty,
              color: progress != null ? Colors.green : Colors.grey,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // Format date for display
  String _formatDate(dynamic date) {
    if (date is DateTime) {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
    return 'N/A';
  }

  // Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
