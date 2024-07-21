import 'package:flutter/material.dart';
import 'package:todo_list/src/utils/app_theme.dart';

import '../utils/settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make private variables so they are not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;
  late TextTheme _textTheme;
  late AppTheme _appTheme;

  // Allow Widgets to read the user's preferred settings:
  ThemeMode get themeMode => _themeMode;
  TextTheme get textTheme => _textTheme;
  AppTheme get appTheme => _appTheme;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _textTheme = await _settingsService.textTheme();
    _appTheme = await _settingsService.appTheme(_textTheme);

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;
    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;
    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateAppTheme(String? newAppTheme) async {
    if (newAppTheme == null || newAppTheme == "") return;
    // Do not perform any work if new and old AppTheme are identical
    if (newAppTheme == _appTheme.title) return;
    // Otherwise, store the new AppTheme in memory
    _appTheme = AppTheme(
      title: newAppTheme,
      textTheme: _textTheme,
    );
    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateAppTheme(newAppTheme);
  }
}
