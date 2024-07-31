import 'package:flutter/material.dart';
import 'package:todo_list/src/providers/settings_controller.dart';

import '../screens/settings_view.dart';
import '../widgets/task_sections_builder.dart';
import '../widgets/dialogs/add_task_dialog.dart';

class HomeScreen extends StatelessWidget {
  final SettingsController settingsController;
  const HomeScreen({super.key, required this.settingsController});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeColors.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "To-Do List",
          style: textTheme.headlineSmall!.copyWith(
            color: themeColors.primary,
          ),
        ),
        backgroundColor: themeColors.primaryContainer,
        foregroundColor: themeColors.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(
                context,
                SettingsView.routeName,
              );
            },
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton(
            offset: const Offset(0, 45),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: "Sort",
                child: const Text("Sort By"),
                onTap: () => displaySortByDialog(
                  context,
                  settingsController: settingsController,
                ),
              ),
              const PopupMenuItem<String>(
                value: "Filter",
                child: Text("Filter By"),
              ),
            ],
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: TaskSectionsBuilder(settingsController: settingsController),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColors.surfaceTint,
        foregroundColor: themeColors.surface,
        onPressed: () => displayAddTaskDialog(context),
        // onPressed: () => Navigator.of(context).pushNamed('/add-task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> displayAddTaskDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AddTaskDialog(),
  );
}

Future<void> displaySortByDialog(BuildContext context,
    {required settingsController}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) =>
        SortByDialog(settingsController: settingsController),
  );
}

class SortByDialog extends StatelessWidget {
  final SettingsController settingsController;
  const SortByDialog({
    super.key,
    required this.settingsController,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: themeColors.primaryContainer,
      alignment: Alignment.bottomCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Group By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                    newGroupBy: "Priority"),
                child: const Text("Priority"),
              ),
              TextButton(
                onPressed: () =>
                    settingsController.updateTaskSettings(newGroupBy: "None"),
                child: const Text("None"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
