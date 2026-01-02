import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'level_selection_screen.dart';
import '../services/auth_service.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LevelSelectionScreen()),
        );
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0f2027), // Dark blue
              Color(0xFF203a43), // Medium blue
              Color(0xFF2c5364), // Light blue
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GAMING-STYLE LOGO BOX
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF764ba2)
                              .withAlpha((0.5 * 255).round()),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Inner glow effect
                        Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(17),
                            border: Border.all(
                              color:
                                  Colors.white.withAlpha((0.3 * 255).round()),
                              width: 2,
                            ),
                          ),
                        ),

                        // Logo container
                        Center(
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withAlpha((0.2 * 255).round()),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        // Top-left corner accent
                        Positioned(
                          top: 15,
                          left: 15,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.white, width: 3),
                                left: BorderSide(color: Colors.white, width: 3),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        // Bottom-right corner accent
                        Positioned(
                          bottom: 15,
                          right: 15,
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: Colors.white, width: 3),
                                right:
                                    BorderSide(color: Colors.white, width: 3),
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),

                        // Glow effect dots - top-right and bottom-left
                        Positioned(
                          top: 30,
                          right: 30,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 237, 99, 99)
                                  .withAlpha((0.8 * 255).round()),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 30,
                          left: 30,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 86, 56, 255)
                                  .withAlpha((0.8 * 255).round()),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // APP TITLE WITH GAMING STYLE
                  Stack(
                    children: [
                      // Text shadow/glow effect
                      Text(
                        'QuizzNepal',
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 8
                            ..color = const Color.fromARGB(
                                255, 0, 0, 0), // Black with 0.5 opacity
                        ),
                      ),

                      Text(
                        'QuizzNepal', // main title
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          color: const Color.fromARGB(255, 255, 15, 15),
                          shadows: [
                            Shadow(
                              color: const Color(0xFF64B5F6), // Light blue
                              blurRadius: 20,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // TAGLINE
                  Text(
                    "जननी जन्मभूमिश्च स्वर्गादपि गरीयसी"
                    "\nMother and Motherland are greater than heaven",
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      color: const Color.fromARGB(
                          204, 246, 173, 173), // White with 0.8 opacity

                      shadows: [
                        const Shadow(
                          color: Color.fromARGB(128, 0, 0, 0),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // LOGIN BUTTON - GAMING STYLE

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: const Color.fromARGB(
                            128, 76, 175, 80), // Green with 0.5 opacity
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // REGISTER BUTTON - GAMING STYLE
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: const Color.fromARGB(
                            128, 33, 150, 243), // Blue with 0.5 opacity
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_add, size: 24),
                          SizedBox(width: 10),
                          Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const SizedBox(height: 40),

                  // GAMING INSTRUCTION
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          77, 0, 0, 0), // Black with 0.3 opacity
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withAlpha((0.2 * 255).round()),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star,
                                color: const Color(0xFFFFF176),
                                size: 20), // Yellow[300]
                            const SizedBox(width: 8),
                            Text(
                              'LEVEL UP YOUR KNOWLEDGE ABOUT NEPAL',
                              style: TextStyle(
                                color: const Color(0xFFFFF176), // Yellow[300]
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.star,
                                color: const Color(0xFFFFF176),
                                size: 20), // Yellow[300]
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Choose your level and start quizzing!\n Test your knowledge about Nepal and climb to the top!',
                          style: TextStyle(
                            color: const Color.fromARGB(
                                204, 255, 255, 255), // White with 0.8 opacity
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // FOOTER
                  Text(
                    'v1.0 • Made with ❤️ for Nepal',
                    style: TextStyle(
                      color: const Color.fromARGB(
                          153, 255, 255, 255), // White with 0.6 opacity
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
