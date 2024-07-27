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

    List<TaskTile> getCompletedTaskTiles() {
      List<TaskTile> taskTiles = [];
      for (var task in tasks.where((task) => task.isDone == true)) {
        taskTiles.add(
          TaskTile(
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
          ),
        );
      }
      return taskTiles;
    }

    List<TaskTile> getTaskTileWithPriority({required String strPriority}) {
      List<TaskTile> taskTiles = [];
      int priority;
      switch (strPriority) {
        case "High":
          priority = 3;
        case "Medium":
          priority = 2;
        case "Low":
          priority = 1;
        default:
          priority = 0;
      }
      for (var task in tasks
          .where((task) => task.priority == priority && task.isDone == false)) {
        taskTiles.add(
          TaskTile(
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
          ),
        );
      }
      return taskTiles;
    }

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
              const PopupMenuItem<String>(
                value: "Sort",
                child: Text("Sort By"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            ExpansionTileByCategory(
              leading: const Icon(Icons.flag, color: Colors.red),
              titleText: "High Priority",
              children: getTaskTileWithPriority(strPriority: "High"),
            ),
            ExpansionTileByCategory(
              leading: const Icon(Icons.flag, color: Colors.yellow),
              titleText: "Medium Priority",
              children: getTaskTileWithPriority(strPriority: "Medium"),
            ),
            ExpansionTileByCategory(
              leading: const Icon(Icons.flag, color: Colors.blue),
              titleText: "Low Priority",
              children: getTaskTileWithPriority(strPriority: "Low"),
            ),
            ExpansionTileByCategory(
              leading: const Icon(Icons.flag, color: Colors.grey),
              titleText: "None Priority",
              children: getTaskTileWithPriority(strPriority: "None"),
            ),
            ExpansionTileByCategory(
              titleText: "Completed",
              children: getCompletedTaskTiles(),
            ),
          ],
        ),
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

class ExpansionTileByCategory extends StatelessWidget {
  const ExpansionTileByCategory({
    super.key,
    required this.titleText,
    required this.children,
    this.leading,
  });

  final String titleText;
  final List<Widget> children;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ExpansionTile(
      leading: leading,
      initiallyExpanded: true,
      // tilePadding: const EdgeInsets.only(top: 1),
      backgroundColor: themeColors.primary,
      collapsedBackgroundColor: themeColors.primary,
      iconColor: themeColors.primaryContainer,
      collapsedIconColor: themeColors.primaryContainer,
      title: Text(
        titleText,
        style: textTheme.headlineSmall!.copyWith(
          color: themeColors.primaryContainer,
        ),
      ),
      children: children,
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
