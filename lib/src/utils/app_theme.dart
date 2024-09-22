import 'package:flutter/material.dart';

import '../constants/green_tea_theme.dart';
import '../constants/mustard_theme.dart';

class AppTheme {
  String title;
  TextTheme textTheme;
  AppTheme({
    required this.title,
    required this.textTheme,
  });

  // Theme Options
  // darkHighContrast()
  // darkMediumContrast()
  // dark()
  // lightHighContrast()
  // lightMediumContrast()
  // light()

  /// App light theme
  ThemeData light() {
    switch (title) {
      case "Green Tea":
        return GreenTeaTheme(textTheme).light();
      case "Mustard":
        return MustardTheme(textTheme).light();
      default:
        return ThemeData.light();
    }
  }

  /// Select app light contrast theme
  ThemeData lightContrast(Contrast contrast) {
    switch (contrast) {
      case Contrast.high:
        return lightHighContrast();
      case Contrast.low:
        return lightMediumContrast();
      default:
        return light();
    }
  }

  /// App light high contrast theme
  ThemeData lightHighContrast() {
    switch (title) {
      case "Green Tea":
        return GreenTeaTheme(textTheme).lightHighContrast();
      case "Mustard":
        return MustardTheme(textTheme).lightHighContrast();
      default:
        return ThemeData.light();
    }
  }

  /// App light medium contrast theme
  ThemeData lightMediumContrast() {
    switch (title) {
      case "Green Tea":
        return GreenTeaTheme(textTheme).lightMediumContrast();
      case "Mustard":
        return MustardTheme(textTheme).lightMediumContrast();
      default:
        return ThemeData.light();
    }
  }

  /// App dark theme
  ThemeData dark() {
    switch (title) {
      case "Green Tea":
        return GreenTeaTheme(textTheme).dark();
      case "Mustard":
        return MustardTheme(textTheme).dark();
      default:
        return ThemeData.dark();
    }
  }

  /// Select app dark contrast theme
  ThemeData darkContrast(Contrast contrast) {
    switch (contrast) {
      case Contrast.high:
        return darkHighContrast();
      case Contrast.low:
        return darkMediumContrast();
      default:
        return dark();
    }
  }

  /// App dark high contrast theme
  ThemeData darkHighContrast() {
    switch (title) {
      case "Green Tea":
        return GreenTeaTheme(textTheme).darkHighContrast();
      case "Mustard":
        return MustardTheme(textTheme).darkHighContrast();
      default:
        return ThemeData.dark();
    }
  }

  /// App dark medium contrast theme
  ThemeData darkMediumContrast() {
    switch (title) {
      case "Green Tea":
        return GreenTeaTheme(textTheme).darkMediumContrast();
      case "Mustard":
        return MustardTheme(textTheme).darkMediumContrast();
      default:
        return ThemeData.dark();
    }
  }
}

enum Contrast {
  /// High contrast
  high,

  /// Low contrast
  low,

  /// No contrast
  none,
}
