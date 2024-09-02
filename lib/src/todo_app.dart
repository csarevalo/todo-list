import 'package:flutter/material.dart';

import 'providers/settings_controller.dart';
import 'screens/home_screen.dart';
import 'screens/settings_view.dart';

class TodoApp extends StatelessWidget {
  final SettingsController settingsController;
  const TodoApp({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        final SettingsController settings = settingsController;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Snazzy To-Do List",
          // theme: ThemeData(useMaterial3: true),
          // darkTheme: ThemeData.dark(useMaterial3: true),
          theme: settingsController.appTheme.lightContrast(settings.contrast),
          highContrastTheme: settings.appTheme.lightContrast(settings.contrast),
          darkTheme: settings.appTheme.darkContrast(settings.contrast),
          highContrastDarkTheme:
              settings.appTheme.darkContrast(settings.contrast),
          themeMode: settings.themeMode,
          restorationScopeId: 'todoApp',
          initialRoute: '/',
          routes: {
            '/': (ctx) => const HomeScreen(),
            '/settings': (ctx) => SettingsView(controller: settings),
          },
        );
      },
    );
  }
}
