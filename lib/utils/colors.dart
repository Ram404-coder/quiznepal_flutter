// Nepal Flag Colors
import 'package:flutter/material.dart';// Flutter's material package for Color class


class NepalColors {
  // Official Nepal Flag Colors
  static const Color nepalRed = Color(0xFFDC241F); // #DC241F
  static const Color nepalBlue = Color(0xFF003893); // #003893
  static const Color white = Colors.white; // For moon/sun

  // Gradient combinations
  static const LinearGradient redBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [nepalRed, nepalBlue],
  );

  static const LinearGradient blueRedGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [nepalBlue, nepalRed],
  );

  // For subtle backgrounds
  static const Color lightRed = Color(0xFFF8D7D6);
  static const Color lightBlue = Color(0xFFD6E3F8);
}
