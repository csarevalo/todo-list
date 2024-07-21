import 'package:flutter/material.dart';
import 'package:todo_list/src/constants/green_tea_theme.dart';
import 'package:todo_list/src/constants/mustard_theme.dart';

class AppTheme {
  String title;
  TextTheme textTheme;
  AppTheme({
    required this.title,
    required this.textTheme,
  });

  /// Theme Options
  /// darkHighContrast()
  /// darkMediumContrast()
  /// dark()
  /// lightHighContrast()
  /// lightMediumContrast()
  /// light()

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

  ThemeData lightContrast(int contrastLvl) {
    switch (contrastLvl) {
      case 2:
        return lightHighContrast();
      case 1:
        return lightMediumContrast();
      default:
        return light();
    }
  }

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

  ThemeData darkContrast(int contrastLvl) {
    switch (contrastLvl) {
      case 2:
        return darkHighContrast();
      case 1:
        return darkMediumContrast();
      default:
        return dark();
    }
  }

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
