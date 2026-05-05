import 'package:flutter/material.dart';

class AppGradients {
  static const Color brandStart = Color(0xFF6A11CB);
  static const Color brandEnd = Color(0xFF2575FC);

  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandStart, brandEnd],
  );

  static LinearGradient background() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        brandStart.withValues(alpha: 0.08),
        brandEnd.withValues(alpha: 0.06),
        Colors.white,
      ],
    );
  }

  static const Color income = Color(0xFF2EE59D);
  static const Color expense = Color(0xFFFF5C7A);
}
