import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _currentUserEmail;
  
  // Store hashed passwords
  Map<String, String> _users = {}; // email -> hashedPassword

  bool get isLoggedIn => _isLoggedIn;
  String? get currentUserEmail => _currentUserEmail;

  // 1. LOAD SAVED DATA WHEN APP STARTS
  Future<void> init() async {
    debugPrint('🔄 AuthService: Loading saved data...');
    
    final prefs = await SharedPreferences.getInstance();
    
    // Load saved users from storage
    final savedUsersJson = prefs.getString('registered_users');
    if (savedUsersJson != null) {
      final Map<String, dynamic> usersMap = jsonDecode(savedUsersJson);
      _users = usersMap.cast<String, String>();
      debugPrint('📂 Loaded ${_users.length} registered users');
    }
    
    // Load login status
    _isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    _currentUserEmail = prefs.getString('current_user_email');
    
    if (_isLoggedIn && _currentUserEmail != null) {
      debugPrint('✅ User is already logged in: $_currentUserEmail');
    }
    
    notifyListeners();
  }

  // 2. SAVE EMAIL FOR AUTO-FILL (your existing method)
  Future<void> saveLastEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_email', email);
    debugPrint('📧 Saved email for next time: $email');
  }

  Future<String?> getLastEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_email');
  }

  // Helper method to hash passwords
  String _hashPassword(String password) {
    final bytes = utf8.encode(password + _getSalt());
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  String _getSalt() {
    return 'quiz-nepal-salt-2024'; // Change this for production
  }

  Future<({bool success, String? error})> register(
      String email, String password) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      return (success: false, error: 'Email and password cannot be empty');
    }

    if (!_isValidEmail(email)) {
      return (success: false, error: 'Invalid email format');
    }

    if (password.length < 6) {
      return (success: false, error: 'Password must be at least 6 characters');
    }

    if (_users.containsKey(email)) {
      return (success: false, error: 'Email already registered');
    }

    // Hash password before storing
    final hashedPassword = _hashPassword(password);
    _users[email] = hashedPassword;
    
    // 🔥 CRITICAL: Save users to persistent storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('registered_users', jsonEncode(_users));
    
    debugPrint('✅ Registered: $email (Total users: ${_users.length})');

    notifyListeners();
    return (success: true, error: null);
  }

  Future<({bool success, String? error})> login(
      String email, String password) async {
    // Validate inputs
    if (email.isEmpty || password.isEmpty) {
      return (success: false, error: 'Email and password cannot be empty');
    }

    final hashedPassword = _hashPassword(password);
    final storedPassword = _users[email];

    if (storedPassword == null) {
      return (success: false, error: 'User not found');
    }

    if (storedPassword != hashedPassword) {
      return (success: false, error: 'Invalid password');
    }

    _isLoggedIn = true;
    _currentUserEmail = email;
    
    // 🔥 CRITICAL: Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('current_user_email', email);
    
    // Also save for auto-fill
    await saveLastEmail(email);
    
    debugPrint('🎯 Logged in: $email');

    notifyListeners();
    return (success: true, error: null);
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUserEmail = null;
    
    // 🔥 CRITICAL: Clear login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('current_user_email');
    
    debugPrint('🚪 Logged out');

    notifyListeners();
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }
  
  // 3. DEBUG METHOD - Show all saved data
  Future<void> debugPrintAllData() async {
    final prefs = await SharedPreferences.getInstance();
    
    debugPrint('🔍 === DEBUG AUTH DATA ===');
    debugPrint('is_logged_in: ${prefs.getBool('is_logged_in')}');
    debugPrint('current_user_email: ${prefs.getString('current_user_email')}');
    debugPrint('last_email: ${prefs.getString('last_email')}');
    
    final savedUsers = prefs.getString('registered_users');
    if (savedUsers != null) {
      final usersMap = jsonDecode(savedUsers);
      debugPrint('Registered users: ${usersMap.keys.toList()}');
    } else {
      debugPrint('No registered users saved');
    }
    debugPrint('===========================');
  }
  
  // 4. CLEAR ALL DATA (for testing)
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _isLoggedIn = false;
    _currentUserEmail = null;
    _users.clear();
    
    debugPrint('🧹 Cleared all auth data');
    notifyListeners();
  }
}