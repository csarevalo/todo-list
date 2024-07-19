import 'package:flutter/material.dart';
// import 'package:todo_list/screens/add_task_dialog.dart';

import 'src/providers/app_settings.dart';
import 'src/todo_app.dart';
import 'src/utils/settings_service.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(TodoApp(
    settingsController: settingsController,
  ));
}
