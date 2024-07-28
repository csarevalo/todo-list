import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import 'dialogs/change_priority_dialog.dart';
import 'section_expansion_tile.dart';
import 'task_tile.dart';

class TaskSectionsBuilder extends StatelessWidget {
  const TaskSectionsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).todoList;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    List<TaskTile> getTaskTilesWithCompletion({required completed}) {
      List<TaskTile> taskTiles = [];
      for (var task in tasks.where((task) => task.isDone == completed)) {
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
            dueDate: task.dueDate,
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

    return SingleChildScrollView(
      child: Column(
        children: [
          SectionExpansionTile(
            leading: const Icon(Icons.flag, color: Colors.red),
            titleText: "High Priority",
            children: getTaskTileWithPriority(strPriority: "High"),
          ),
          SectionExpansionTile(
            leading: const Icon(Icons.flag, color: Colors.yellow),
            titleText: "Medium Priority",
            children: getTaskTileWithPriority(strPriority: "Medium"),
          ),
          SectionExpansionTile(
            leading: const Icon(Icons.flag, color: Colors.blue),
            titleText: "Low Priority",
            children: getTaskTileWithPriority(strPriority: "Low"),
          ),
          SectionExpansionTile(
            leading: const Icon(Icons.flag, color: Colors.grey),
            titleText: "None Priority",
            children: getTaskTileWithPriority(strPriority: "None"),
          ),
          SectionExpansionTile(
            titleText: "Completed",
            children: getTaskTilesWithCompletion(completed: true),
          ),
        ],
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
