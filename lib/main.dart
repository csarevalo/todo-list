import 'package:flutter/material.dart';
import 'package:todo_list/src/providers/task_provider.dart';
import 'package:todo_list/src/utils/task_provider_service.dart';

import 'src/providers/settings_controller.dart';
import 'src/todo_app.dart';
import 'src/utils/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  final taskProvider = TaskProvider(TaskProviderService());
  await taskProvider.init();
  runApp(TodoApp(
    settingsController: settingsController,
    taskProvider: taskProvider,
  ));
}
