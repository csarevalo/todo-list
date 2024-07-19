import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/providers/settings_controller.dart';
import 'package:todo_list/src/providers/task_provider.dart';
import 'package:todo_list/src/screens/home_screen.dart';

import 'screens/settings_view.dart';

class TodoApp extends StatelessWidget {
  final SettingsController settingsController;
  const TodoApp({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TaskProvider(),
      child: ListenableBuilder(
        listenable: settingsController,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Snazzy To-Do List",
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            themeMode: settingsController.themeMode,
            restorationScopeId: 'todoApp',
            initialRoute: '/',
            routes: {
              '/': (ctx) => HomeScreen(),
              '/settings': (ctx) =>
                  SettingsView(controller: settingsController),
            },
          );
        },
      ),
    );
  }
}
