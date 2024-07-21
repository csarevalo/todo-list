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

  // final appThemes = [
  //   const GreenTeaTheme(TextTheme()).title,
  //   const MustardTheme(TextTheme()).title,
  // ];
  // final themeModes = [
  //   "dark",
  //   "darkMediumContrast",
  //   "darkHighContrast",
  //   "light",
  //   "lightMediumContrast",
  //   "lightHighContrast",
  // ];

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
}
