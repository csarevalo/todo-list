import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/constants/task_group_headings.dart';
import 'package:todo_list/src/providers/settings_controller.dart';

import '../models/section_heading.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../utils/filter_tasks.dart';
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
    Color tileColor = themeColors.primary.withOpacity(0.8);
    Color onTileColor = themeColors.primaryContainer;

    final FilterTasks filterTasks = FilterTasks(tasks: tasks);

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
        case "datecreated": //Date Created
          groupHeaders = dateSections;
          getChildren = (String s) => getTaskTileBasedOnDate(
                datePeriod: s,
                dateType: 'created',
              );
        case "datemodified": //Date Modified
          groupHeaders = dateSections;
          getChildren = (String s) => getTaskTileBasedOnDate(
                datePeriod: s,
                dateType: 'modified',
              );
        case "datedue": //Date Due
          groupHeaders = dateSections;
          getChildren = (String s) => getTaskTileBasedOnDate(
                datePeriod: s,
                dateType: 'due',
              );
        case "datedone": //Date Done
          groupHeaders = dateSections;
          getChildren = (String s) => getTaskTileBasedOnDate(
                datePeriod: s,
                dateType: 'done',
              );
        default:
          //TODO: Do not add a section and just include the tasks
          groupHeaders = [SectionHeading(heading: "Not Completed")];
          getChildren =
              (String s) => getTaskTilesBasedOnCompletion(isCompleted: false);
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
            children: getTaskTilesBasedOnCompletion(isCompleted: true),
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
