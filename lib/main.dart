import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snazzy_todo_list/src/providers/task_preferences_controller.dart';

import 'src/providers/task_provider.dart';
import 'src/providers/settings_controller.dart';
import 'src/utils/settings_service.dart';
import 'src/todo_app.dart';

void main() async {
  final taskProvider = TaskProvider(TaskProviderService());
  await taskProvider.init();

  final taskPreferencesController = TaskPreferencesController();
  await taskPreferencesController.loadPreferences();

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => taskProvider),
        ChangeNotifierProvider(create: (context) => taskPreferencesController),
      ],
      child: TodoApp(
        settingsController: settingsController,
      ),
    ),
  );
}
