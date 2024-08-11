import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/widgets/dialogs/edit_task_dialog.dart';

import '../constants/task_group_headings.dart';
import '../models/section_heading.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/settings_controller.dart';

import '../utils/filter_tasks.dart';
import 'dialogs/change_priority_dialog.dart';
import 'expandable_task_sections.dart';
import 'task_tile.dart';

class TaskSectionsBuilder extends StatelessWidget {
  final SettingsController settings;
  const TaskSectionsBuilder({super.key, required this.settings});

  // @override
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    //TODO: Plz optimize ...REBUILDS this whole big ass widget
    final tasks = Provider.of<TaskProvider>(context).todoList;
    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    /// Set the tile colors
    Color tileColor = themeColors.primary.withOpacity(0.8);
    Color onTileColor = themeColors.primaryContainer;

    final FilterTasks filterTasks = FilterTasks(
      tasks: tasks,
      taskViewOptions: settings.taskViewOptions,
    );

    const TaskGroupHeadings headingOptions = TaskGroupHeadings();
    List<TaskTile> createTaskTileListFrom(List<Task> taskList) {
      List<TaskTile> taskTiles = [];
      for (var task in taskList) {
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
            onTapTaskTile: () => displayUpdateTaskDialog(context, task),
            tileColor: tileColor,
            onTileColor: onTileColor,
          ),
        );
      }
      return taskTiles;
    }

    List<TaskTile> getTaskTilesBasedOnCompletion({required isCompleted}) {
      List<Task> filteredTasks = filterTasks.basedOnCompletion(
        isCompleted: isCompleted,
      );
      List<TaskTile> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    List<TaskTile> getTaskTileBasedOnPriority({
      required String strPriority,
      bool isCompleted = false, // By default show uncompleted tasks only
    }) {
      List<Task> filteredTasks = filterTasks.basedOnPriority(
        strPriority: strPriority,
        isCompleted: isCompleted,
      );
      List<TaskTile> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    List<TaskTile> getTaskTileBasedOnDate({
      required String
          datePeriod, // Options: overdue, today, tomorrow, next, later
      required String dateType, // Options: done, modified, due, created
      bool isCompleted = false, // Default: uncompleted
    }) {
      List<Task> filteredTasks = filterTasks.basedOnDate(
          datePeriod: datePeriod, dateType: dateType, isCompleted: isCompleted);
      List<TaskTile> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    List<ExpandableTaskSection> getSectionedTaskTiles({
      required String groupBy,
    }) {
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
        case "date_due": //Date Due
          groupHeaders = dateSections;
          getChildren = (String s) => getTaskTileBasedOnDate(
                datePeriod: s,
                dateType: 'due',
              );
        default:
          //TODO: Do not add a section and just the tasks
          groupHeaders = [SectionHeading(heading: "Not Completed")];
          getChildren =
              (String s) => getTaskTilesBasedOnCompletion(isCompleted: false);
      }
      for (var section in groupHeaders) {
        var children = getChildren(section.heading.split(' ')[0]);
        if (children.isNotEmpty) {
          sectionTiles.add(
            ExpandableTaskSection(
              titleText: section.heading,
              children: children,
            ),
          );
        }
      }
      return sectionTiles;
    }

    return SingleChildScrollView(
      child: SlidableAutoCloseBehavior(
        child: Column(
          children: [
            ...getSectionedTaskTiles(
              groupBy: settings.taskViewOptions.groupBy,
            ),
            ExpandableTaskSection(
              titleText: "Completed",
              children: getTaskTilesBasedOnCompletion(isCompleted: true),
            ),
          ],
        ),
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

Future<void> displayUpdateTaskDialog(
  BuildContext context,
  Task task,
) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => EditTaskDialog(task: task),
  );
}
