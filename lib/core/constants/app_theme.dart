import 'package:flutter/material.dart';

class ThemeConstants {
  final theme = ThemeData(
    primarySwatch: Colors.deepPurple,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 24),
      bodyLarge: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 20),
      bodyMedium: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 18),
      bodySmall: TextStyle(
          fontFamily: 'Sans',
          fontWeight: FontWeight.normal,
          color: Colors.black,
          fontSize: 14),
    ),
  );
}
