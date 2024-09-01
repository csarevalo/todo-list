import 'package:flutter/material.dart';

import '../screens/settings_view.dart';
import '../widgets/dialogs/sort_tasks_dialog.dart';
import '../widgets/task_sections_builder.dart';
import '../widgets/dialogs/small_task_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
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
                child: const Text("Sort"),
                onTap: () => showSortTasksDialog(context: context),
              ),
              //TODO: add more options
              //show completed
              //show details
              //show select.. tasks for bulk edits/deletes
            ],
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: const TaskSectionsBuilder(),
      floatingActionButton: RepaintBoundary(
        child: FloatingActionButton(
          backgroundColor: themeColors.surfaceTint,
          foregroundColor: themeColors.surface,
          onPressed: () => showSmallTaskDialog(context: context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
