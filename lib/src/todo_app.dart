import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_controller.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'screens/settings_view.dart';

class TodoApp extends StatelessWidget {
  final SettingsController settingsController;
  final TaskProvider taskProvider;
  const TodoApp({
    super.key,
    required this.settingsController,
    required this.taskProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => taskProvider,
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Snazzy To-Do List",
            // theme: ThemeData(useMaterial3: true),
            // darkTheme: ThemeData.dark(useMaterial3: true),
            theme: settingsController.appTheme.light(),
            highContrastTheme: settingsController.appTheme
                .lightContrast(settingsController.contrast),
            darkTheme: settingsController.appTheme.dark(),
            highContrastDarkTheme: settingsController.appTheme
                .darkContrast(settingsController.contrast),
            themeMode: settingsController.themeMode,
            restorationScopeId: 'todoApp',
            initialRoute: '/',
            routes: {
              '/': (ctx) => HomeScreen(settingsController: settingsController),
              '/settings': (ctx) =>
                  SettingsView(controller: settingsController),
            },
          );
        },
      ),
    );
  }
}
