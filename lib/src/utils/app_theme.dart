import 'package:flutter/material.dart';

class AppTheme {
  /// Theme Options
  // theme(darkHighContrastScheme()); //darkHighContrast()
  // theme(darkMediumContrastScheme()); //darkMediumContrast()
  // theme(darkScheme()); //dark()
  // theme(lightHighContrastScheme()); //lightHighContrast()
  // theme(lightMediumContrastScheme()); //lightMediumContrast()
  // theme(lightScheme()); //light()

  final appThemes = [
    "green_tea",
    "mustard",
  ];
  final themeModes = [
    "dark",
    "darkMediumContrast",
    "darkHighContrast",
    "light",
    "lightMediumContrast",
    "lightHighContrast",
  ];

  ThemeData? chooseAppTheme(String themeSelected, String themeModeSelected) {
    if (!appThemes.contains(themeSelected)) {
      return null;
    }
    if (!themeModes.contains(themeModeSelected)) {
      return null;
    }

    for (int appThemeChoice = 0;
        appThemeChoice < appThemes.length;
        appThemeChoice++) {
      switch (themeSelected) {
        case "dark":
          break;
        case "darkMediumContrast":
          break;
        case "darkHighContrast":
          break;
        case "light":
          break;
        case "lightMediumContrast":
          break;
        case "lightHighContrast":
          break;
        default:
      }
    }
  }
}
