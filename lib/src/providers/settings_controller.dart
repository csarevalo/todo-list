import 'package:flutter/material.dart';

import '../models/task_sort_options.dart';
import '../utils/settings_service.dart';
import '../utils/app_theme.dart';

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
  late TaskSortOptions _taskSortOptions;

  // Allow Widgets to read the user's preferred settings:
  ThemeMode get themeMode => _themeMode;
  TextTheme get textTheme => _textTheme;
  AppTheme get appTheme => _appTheme;
  String get contrast => _contrast;
  TaskSortOptions get taskSortOptions => _taskSortOptions;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    _textTheme = await _settingsService.textTheme();
    _appTheme = await _settingsService.appTheme(_textTheme);
    _contrast = await _settingsService.contrast();
    _taskSortOptions = await _settingsService.taskSortOptions();

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

  /// Update and persist the Task View Options based on the user's selection.
  Future<void> updateTaskSortOptions({
    String? newSort1stBy,
    String? newSort2ndBy,
    String? newGroupBy,
    bool? newDesc1,
    bool? newDesc2,
  }) async {
    newGroupBy ??= _taskSortOptions.groupBy;
    newSort1stBy ??= _taskSortOptions.sort1stBy;
    newSort2ndBy ??= _taskSortOptions.sort2ndBy;
    newDesc1 ??= _taskSortOptions.desc1;
    newDesc2 ??= _taskSortOptions.desc2;
    // Do not perform any work if new and old Task Settings are identical
    if (newGroupBy == _taskSortOptions.groupBy &&
        newSort1stBy == _taskSortOptions.sort1stBy &&
        newSort2ndBy == _taskSortOptions.sort2ndBy &&
        newDesc1 == _taskSortOptions.desc1 &&
        newDesc2 == _taskSortOptions.desc2) {
      return;
    }
    // Otherwise, store the new Task Settings in memory
    _taskSortOptions = TaskSortOptions(
      groupBy: newGroupBy,
      sort1stBy: newSort1stBy,
      desc1: newDesc1,
      sort2ndBy: newSort2ndBy,
      desc2: newDesc2,
    );

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateTaskSortOptions(taskSortOptions);
  }
}
