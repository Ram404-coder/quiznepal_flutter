import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiznepal/services/audio_service.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/quiz_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'utils/colors.dart'; // Import NepalColors

void main() async {
  // Initialize for desktop platforms
  _initializeDatabase();
  await AudioService().initialize(); // Initialize audio service

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

void _initializeDatabase() {
  try {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    debugPrint("Database initialized for desktop platforms.");
  } catch (e) {
    debugPrint("Not a desktop platform or failed to initialize FFI: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            final authService = AuthService();
            authService.init(); // Load saved auth data on startup
            return authService;
          },
        ),
        ChangeNotifierProvider(create: (context) => QuizService()),
      ],
      child: MaterialApp(
        title: 'QuizNepal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Nepal Theme Colors
          primaryColor: NepalColors.nepalRed,
          primarySwatch: Colors.red, // Keep for Material colors
          colorScheme: ColorScheme.fromSeed(
            seedColor: NepalColors.nepalRed,
            primary: NepalColors.nepalRed,
            secondary: NepalColors.nepalBlue,
          ),
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: const AppBarTheme(
            backgroundColor: NepalColors.nepalRed, // Red app bars
            foregroundColor: Colors.white,
            elevation: 4,
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: NepalColors.nepalRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: NepalColors.nepalBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: NepalColors.nepalBlue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: NepalColors.nepalRed, width: 2),
            ),
          ),
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: NepalColors.nepalRed,
          ),
          // Add font family if you have custom fonts
          fontFamily: 'Roboto', // Or your preferred font
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
