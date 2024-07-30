import 'package:flutter/material.dart';
import 'package:todo_list/src/utils/app_theme.dart';

import '../models/task_settings.dart';
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
  late String _contrast;
  late AppTheme _appTheme;
  late TaskSettings _taskSettings;

  // Allow Widgets to read the user's preferred settings:
  ThemeMode get themeMode => _themeMode;
  TextTheme get textTheme => _textTheme;
  AppTheme get appTheme => _appTheme;
  String get contrast => _contrast;
  TaskSettings get taskSettings => _taskSettings;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _textTheme = await _settingsService.textTheme();
    _appTheme = await _settingsService.appTheme(_textTheme);
    _contrast = await _settingsService.contrast();
    _taskSettings = await _settingsService.taskSettings();

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

  /// Update and persist the AppTheme based on the user's selection.
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

  /// Update and persist the Contrast based on the user's selection.
  Future<void> updateContrast(String? newContrast) async {
    if (newContrast == null || newContrast == "") return;
    // Do not perform any work if new and old Contrast are identical
    if (newContrast == _contrast) return;
    // Otherwise, store the new Contrast in memory
    _contrast = newContrast;
    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateContrast(newContrast);
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateTaskSettings(
      String? newSortBy, String? newFilterBy) async {
    if (newSortBy == null && newFilterBy == null) return;
    // Do not perform any work if new and old Task Settings are identical
    if (newSortBy == _taskSettings.sortBy &&
        newFilterBy == _taskSettings.filterBy) {
      return;
    }

    // Otherwise, store the new Task Settings in memory
    if (newSortBy != _taskSettings.sortBy &&
        newFilterBy != _taskSettings.filterBy) {
      _taskSettings = TaskSettings(
        sortBy: newSortBy!,
        filterBy: newFilterBy!,
      );
    } else if (newSortBy != _taskSettings.sortBy) {
      _taskSettings = TaskSettings(
        sortBy: newSortBy!,
        filterBy: _taskSettings.filterBy,
      );
    } else if (newFilterBy != _taskSettings.filterBy) {
      _taskSettings = TaskSettings(
        sortBy: _taskSettings.sortBy,
        filterBy: newFilterBy!,
      );
    } else {
      // Do not perform any work
      return;
    }
    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateTaskSettings(taskSettings);
  }
}
