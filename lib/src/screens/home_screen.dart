import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/screens/settings_view.dart';

import '../providers/task_provider.dart';
import '../widgets/dialogs/change_priority_dialog.dart';
import '../widgets/task_tile.dart';
import '../widgets/dialogs/add_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).todoList;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
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
        ],
      ),
      body: ListView.builder(
        restorationId: 'homeScreen', //'todoList'
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = tasks[index];

          return TaskTile(
            title: task.title,
            checkboxState: task.isDone,
            priority: task.priority,
            onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
            onDelete: (context) => taskProvider.deleteTask(task.id),
            onPriorityChange: () => displayChangePriorityDialog(
              context,
              task.id,
              task.priority,
            ),
            tileColor: themeColors.primary.withOpacity(0.8),
            onTileColor: themeColors.primaryContainer,
          );
        },
      ),
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

Future<void> displayChangePriorityDialog(
  BuildContext context,
  int taskId,
  int currentPriority,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => ChangePriorityDialog(
      taskId: taskId,
      currentPriority: currentPriority,
    ),
  );
}

Future<void> displayAddTaskDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AddTaskDialog(),
  );
}
