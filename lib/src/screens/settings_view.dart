import 'package:flutter/material.dart';

import '../providers/settings_controller.dart';
import '../utils/app_theme.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Theme Mode"),
            Padding(
              padding: const EdgeInsets.all(16),
              // Glue the SettingsController to the theme selection DropdownButton.
              //
              // When a user selects a theme from the dropdown list, the
              // SettingsController is updated, which rebuilds the MaterialApp.
              child: DropdownButton<ThemeMode>(
                // Read the selected themeMode from the controller
                value: controller.themeMode,
                // Call the updateThemeMode method any time the user selects a theme.
                onChanged: controller.updateThemeMode,
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light Theme'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark Theme'),
                  )
                ],
              ),
            ),
            const Text("App Theme"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // Glue the SettingsController to the theme selection DropdownButton.
              //
              // When a user selects a app theme from the dropdown list, the
              // SettingsController is updated, which rebuilds the MaterialApp.
              child: DropdownButton<String>(
                value: controller.appTheme.title,
                onChanged: (newTheme) => controller.updateAppTheme(newTheme),
                items: const [
                  DropdownMenuItem(
                    value: 'Mustard',
                    child: Text('Mustard Theme'),
                  ),
                  DropdownMenuItem(
                    value: 'Green Tea',
                    child: Text('Green Tea Theme'),
                  )
                ],
              ),
            ),
            const Text("Contrast Settings"),
            Padding(
              padding: const EdgeInsets.all(16.0),
              // Glue the SettingsController to the theme selection DropdownButton.
              //
              // When a user selects a contrast from the dropdown list, the
              // SettingsController is updated, which rebuilds the MaterialApp
              // on user enabling accessibility contrast.
              child: DropdownButton<Contrast>(
                value: controller.contrast,
                onChanged: (newContrast) =>
                    controller.updateContrast(newContrast!),
                items: const [
                  DropdownMenuItem(
                    value: Contrast.high,
                    child: Text('High Contrast'),
                  ),
                  DropdownMenuItem(
                    value: Contrast.low,
                    child: Text('Low Contrast'),
                  ),
                  DropdownMenuItem(
                    value: Contrast.none,
                    child: Text('None'),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
