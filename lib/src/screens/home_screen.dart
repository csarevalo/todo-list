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
      backgroundColor: themeColors.surfaceDim,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "To-Do List",
          style: textTheme.headlineMedium,
        ),
        backgroundColor: themeColors.surfaceDim,
        foregroundColor: themeColors.onSurface,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(
                context,
                SettingsView.routeName,
              );
            },
            icon: Icon(
              Icons.settings,
              color: themeColors.onSurface,
            ),
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
            tileColor: themeColors.primaryContainer,
            onTileColor: themeColors.onPrimaryContainer,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColors.primaryContainer,
        foregroundColor: themeColors.onPrimaryContainer,
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
