import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/constants/task_group_headings.dart';
import 'package:todo_list/src/providers/settings_controller.dart';

import '../models/section_heading.dart';

import '../providers/task_provider.dart';
import 'dialogs/change_priority_dialog.dart';
import 'expandable_task_sections.dart';
import 'task_tile.dart';

class TaskSectionsBuilder extends StatelessWidget {
  final SettingsController settings;
  const TaskSectionsBuilder({super.key, required this.settings});

  //TODO: Don't show empty sections...

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).todoList;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    /// Set the tile colors
    //TODO: Make this something that can be called
    Color tileColor = themeColors.primary.withOpacity(0.8);
    Color onTileColor = themeColors.primaryContainer;

    const TaskGroupHeadings headingOptions = TaskGroupHeadings();

    List<TaskTile> getTaskTilesBasedOnCompletion({required completed}) {
      List<TaskTile> taskTiles = [];
      for (var task in tasks.where((task) => task.isDone == completed)) {
        taskTiles.add(
          TaskTile(
            title: task.title,
            checkboxState: task.isDone,
            priority: task.priority,
            dateDue: task.dateDue,
            onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
            onDelete: (context) => taskProvider.deleteTask(task.id),
            onPriorityChange: () => displayChangePriorityDialog(
              context,
              task.id,
              task.priority,
            ),
            tileColor: tileColor,
            onTileColor: onTileColor,
          ),
        );
      }
      return taskTiles;
    }

    List<TaskTile> getTaskTileBasedOnPriority({required String strPriority}) {
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
            dateDue: task.dateDue,
            onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
            onDelete: (context) => taskProvider.deleteTask(task.id),
            onPriorityChange: () => displayChangePriorityDialog(
              context,
              task.id,
              task.priority,
            ),
            tileColor: tileColor,
            onTileColor: onTileColor,
          ),
        );
      }
      return taskTiles;
    }

    List<TaskTile> getTaskTileBasedOnDate({required String datePeriod}) {
      //TODO: add second input to select reference date
      //(created, modified, completed)
      //...it will work with an if-elseif-else statement
      datePeriod = datePeriod.toLowerCase();
      List<TaskTile> taskTiles = [];
      var filteredTasks = tasks;
      switch (datePeriod) {
        case "overdue":
          filteredTasks.retainWhere((task) =>
              task.dateCreated.difference(DateTime.now()).inDays < 0 &&
              task.isDone);
        case "today":
          filteredTasks.retainWhere((task) =>
              task.dateCreated.difference(DateTime.now()).inDays == 0 &&
              task.isDone);
        case "tomorrow":
          filteredTasks.retainWhere((task) =>
              task.dateCreated.difference(DateTime.now()).inDays == 1 &&
              task.isDone);
        case "next": //next 7 days (2-7) days
          filteredTasks.retainWhere((task) =>
              (task.dateCreated.difference(DateTime.now()).inDays > 1) &&
              task.dateCreated.difference(DateTime.now()).inDays <= 7 &&
              task.isDone);
        case "late": //later
          filteredTasks.retainWhere((task) =>
              task.dateCreated.difference(DateTime.now()).inDays > 0 &&
              task.isDone);
        default: //no date
          filteredTasks.retainWhere((task) => task.dateCreated == null);
      }
      for (var task in filteredTasks) {
        taskTiles.add(
          TaskTile(
            title: task.title,
            checkboxState: task.isDone,
            priority: task.priority,
            dateDue: task.dateDue,
            onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
            onDelete: (context) => taskProvider.deleteTask(task.id),
            onPriorityChange: () => displayChangePriorityDialog(
              context,
              task.id,
              task.priority,
            ),
            tileColor: tileColor,
            onTileColor: onTileColor,
          ),
        );
      }
      return taskTiles;
    }

    List<ExpandableTaskSection> getSectionedTaskTiles(String groupBy) {
      groupBy = groupBy.toLowerCase().trim();
      final List<SectionHeading> priorityHeadings =
          headingOptions.priorityHeadings();

      final List<SectionHeading> dateSections = headingOptions.dateHeadings();

      List<SectionHeading> groupHeaders;
      List<ExpandableTaskSection> sectionTiles = [];
      List<TaskTile> Function(String)? getChildren;

      switch (groupBy) {
        case "priority":
          groupHeaders = priorityHeadings;
          getChildren =
              (String s) => getTaskTileBasedOnPriority(strPriority: s);
        case "date":
          groupHeaders = dateSections;
          getChildren = (String s) => getTaskTileBasedOnDate(datePeriod: s);
        default:
          //TODO: Do not add a section and just include the tasks
          groupHeaders = [SectionHeading(heading: "Not Completed")];
          getChildren =
              (String s) => getTaskTilesBasedOnCompletion(completed: false);
      }
      for (var section in groupHeaders) {
        sectionTiles.add(
          ExpandableTaskSection(
            titleText: section.heading,
            children: getChildren(section.heading.split(' ')[0]),
          ),
        );
      }
      return sectionTiles;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ...getSectionedTaskTiles(settings.taskViewOptions.groupBy),
          ExpandableTaskSection(
            titleText: "Completed",
            children: getTaskTilesBasedOnCompletion(completed: true),
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
