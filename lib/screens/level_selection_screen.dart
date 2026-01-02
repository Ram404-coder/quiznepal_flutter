import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:provider/provider.dart'; // Import Provider package
import 'quiz_screen.dart'; // Import QuizScreen
import 'profile_screen.dart'; // Import ProfileScreen
import '../services/auth_service.dart'; // Import AuthService
import '../services/quiz_service.dart'; // Import QuizService
import '../utils/colors.dart'; // Import NepalColors for Nepal-themed colors


class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final quizService = Provider.of<QuizService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Level'),
        backgroundColor: NepalColors.nepalRed, // Nepal red
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              NepalColors.lightBlue,
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Welcome header with Nepal colors
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NepalColors.nepalRed.withAlpha((0.1 * 255).toInt()),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NepalColors.nepalRed, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flag,
                        color: NepalColors.nepalRed, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Namaste, ${authService.currentUserEmail?.split('@').first ?? 'Explorer'}!',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: NepalColors.nepalRed,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Choose your Nepal knowledge challenge',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Explore Nepal',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: NepalColors.nepalBlue,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Test your knowledge about the Himalayan nation',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 20,
                    childAspectRatio: 3,
                  ),
                  children: [
                    _buildLevelCard(
                      context,
                      'Easy',
                      'Begin your journey',
                      Icons.terrain,
                      NepalColors.nepalBlue,
                      quizService.getUserProgress(
                          authService.currentUserEmail ?? '', 'easy'),
                    ),
                    _buildLevelCard(
                      context,
                      'Medium',
                      'Explore deeper',
                      Icons.landscape,
                      NepalColors.nepalRed,
                      quizService.getUserProgress(
                          authService.currentUserEmail ?? '', 'medium'),
                    ),
                    _buildLevelCard(
                      context,
                      'Hard',
                      'Master the mountains',
                      Icons.height,
                      const Color(0xFF4A148C), // Purple for hard
                      quizService.getUserProgress(
                          authService.currentUserEmail ?? '', 'hard'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(
    BuildContext context,
    String level,
    String description,
    IconData icon,
    Color color,
    Map<String, dynamic>? progress,
  ) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizScreen(level: level.toLowerCase()),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withAlpha((0.2 * 255).toInt()),
                color.withAlpha((0.05 * 255).toInt()),
              ],
            ),
            border: Border.all(
                color: color.withAlpha((0.3 * 255).toInt()), width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withAlpha((0.1 * 255).toInt()),
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      level,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      description,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (progress != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Best: ${progress['score']}/${progress['maxScore']}',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withAlpha((0.7 * 255).toInt()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Logout',
          style: TextStyle(color: NepalColors.nepalRed),
        ),
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
              foregroundColor: NepalColors.nepalRed,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
