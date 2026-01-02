// test/welcome_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:quiznepal/screens/welcome_screen.dart';
import 'package:quiznepal/services/auth_service.dart';

void main() {
  testWidgets('WelcomeScreen shows login button', (WidgetTester tester) async {
    final authService = AuthService();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: authService,
        child: const MaterialApp(
          home: WelcomeScreen(),
        ),
      ),
    );
    
    expect(find.text('LOGIN'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);
  });
  
  testWidgets('WelcomeScreen shows QuizNepal title', (WidgetTester tester) async {
    final authService = AuthService();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: authService,
        child: const MaterialApp(
          home: WelcomeScreen(),
        ),
      ),
    );
    
    expect(find.text('QuizNepal'), findsOneWidget);
  });
  
  testWidgets('WelcomeScreen has logo image', (WidgetTester tester) async {
    final authService = AuthService();
    
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>.value(
        value: authService,
        child: const MaterialApp(
          home: WelcomeScreen(),
        ),
      ),
    );
    
    expect(find.byType(Image), findsOneWidget);
  });
}