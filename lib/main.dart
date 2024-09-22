import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/providers/task_preferences_controller.dart';
import 'src/providers/task_provider.dart';
import 'src/providers/settings_controller.dart';
import 'src/todo_app.dart';

void main() async {
  final taskProvider = TaskProvider();
  await taskProvider.init();

  final taskPreferencesController = TaskPreferencesController();
  await taskPreferencesController.loadPreferences();

  final settingsController = SettingsController();
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
