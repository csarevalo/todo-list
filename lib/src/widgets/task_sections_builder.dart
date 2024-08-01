import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/constants/task_group_headings.dart';
import 'package:todo_list/src/providers/settings_controller.dart';

import '../models/section_heading.dart';

import '../providers/task_provider.dart';
import 'dialogs/change_priority_dialog.dart';
import 'section_expansion_tile.dart';
import 'task_tile.dart';

class TaskSectionsBuilder extends StatelessWidget {
  final SettingsController settings;
  const TaskSectionsBuilder({super.key, required this.settings});

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).todoList;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    const TaskGroupHeadings headingOptions = TaskGroupHeadings();

    List<TaskTile> getTaskTilesWithCompletion({required completed}) {
      List<TaskTile> taskTiles = [];
      for (var task in tasks.where((task) => task.isDone == completed)) {
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

    List<SectionExpansionTile> getSectionedTaskTiles(String groupBy) {
      groupBy = groupBy.toLowerCase().trim();
      final List<SectionHeading> priorityHeadings =
          headingOptions.priorityHeadings();

      final List<SectionHeading> dateSections = headingOptions.dateHeadings();

      List<SectionHeading> groupHeaders;
      List<SectionExpansionTile> sectionTiles = [];
      List<TaskTile> Function(String)? getChildren;

      switch (groupBy) {
        case "priority":
          groupHeaders = priorityHeadings;
          getChildren = (String s) => getTaskTileWithPriority(strPriority: s);
          break;
        case "date":
          groupHeaders = dateSections;
          break;
        default:
          //TODO: Do not add a section and just include the tasks
          groupHeaders = [SectionHeading(heading: "Not Completed")];
          getChildren =
              (String s) => getTaskTilesWithCompletion(completed: false);
      }
      for (var section in groupHeaders) {
        sectionTiles.add(
          SectionExpansionTile(
            titleText: section.heading,
            children: getChildren!(section.heading.split(' ')[0]),
          ),
        );
      }
      return sectionTiles;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...getSectionedTaskTiles(settings.taskViewOptions.groupBy),
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
