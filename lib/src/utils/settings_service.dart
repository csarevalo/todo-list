import 'package:flutter/material.dart';
import 'package:todo_list/src/constants/green_tea_theme.dart';

/// A service that stores and retrieves user settings.
///
/// By default, this class does not persist user settings. If you'd like to
/// persist the user settings locally, use the shared_preferences package. If
/// you'd like to store settings on a web server, use the http package.
class SettingsService {
  final TextTheme textTheme = const TextTheme(); //Todo: Default Text Theme
  /// Loads the User's preferred AppTheme from local or remote storage.
  Future appTheme() async => GreenTeaTheme(textTheme); //Todo: Default theme
  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async => ThemeMode.system;

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<void> updateThemeMode(ThemeMode theme) async {
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
  }

  /// Persists the user's preferred AppTheme to local or remote storage.
  Future<void> updateAppTheme(dynamic appTheme) async {}
}
