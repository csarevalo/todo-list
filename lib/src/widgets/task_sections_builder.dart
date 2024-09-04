import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/task_group_headings.dart';
import '../models/section_heading.dart';
import '../models/task.dart';
import '../models/task_sort_options.dart';
import '../providers/task_provider.dart';
import '../providers/task_preferences_controller.dart';
import '../utils/filter_tasks.dart';

import 'expandable_task_sections.dart';
import 'task_tile.dart';

class TaskSectionsBuilder extends StatelessWidget {
  const TaskSectionsBuilder({
    super.key,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    //FIXME: Plz optimize ...REBUILDS this whole big ass widget
    final tasks = context.select<TaskProvider, List<Task>>(
      (provider) => provider.todoList,
    );
    final taskSortOptions =
        context.select<TaskPreferencesController, TaskSortOptions>(
      (taskPrefs) => taskPrefs.taskSortOptions,
    );

    final FilterTasks filterTasks = FilterTasks(
      tasks: tasks,
      taskSortOptions: taskSortOptions,
    );

    const TaskGroupHeadings headingOptions = TaskGroupHeadings();

    List<TaskTile> createTaskTileListFrom(List<Task> taskList) {
      final taskProvider = Provider.of<TaskProvider>(context);
      List<TaskTile> taskTiles = [];
      for (var taskk in taskList) {
        Task task = context.select<TaskProvider, Task>(
          (p) => p.todoList.singleWhere((t) => t.id == taskk.id),
        );
        taskTiles.add(
          TaskTile(
            task: task,
            onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
            onDelete: (ctx) {
              if (ctx.mounted) {
                taskProvider.deleteTask(task.id);
              }
            },
          ),
        );
      }
      return taskTiles;
    }

    List<TaskTile> getTaskTilesBasedOnCompletion({required isCompleted}) {
      List<Task> filteredTasks = filterTasks.byCompletion(
        isCompleted: isCompleted,
      );
      List<TaskTile> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    List<TaskTile> getTaskTileBasedOnPriority({
      required String strPriority,
      bool isCompleted = false, // By default show uncompleted tasks only
    }) {
      List<Task> filteredTasks = filterTasks.byPriority(
        strPriority: strPriority,
        isCompleted: isCompleted,
      );
      List<TaskTile> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    List<TaskTile> getTaskTileBasedOnDate({
      required String
          datePeriod, // Options: overdue, today, tomorrow, next, later, no..date
      required String dateType, // Options: done, modified, due, created
      bool isCompleted = false, // Default: uncompleted
    }) {
      List<Task> filteredTasks = filterTasks.byDate(
        datePeriod: datePeriod,
        dateType: dateType,
        isCompleted: isCompleted,
      );
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
        case "due_date": //Date Due
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

    List<Widget> expandableTaskSections = [
      ...getSectionedTaskTiles(
        groupBy: taskSortOptions.groupBy,
      ),
      ExpandableTaskSection(
        titleText: "Completed",
        children: getTaskTilesBasedOnCompletion(isCompleted: true),
      ),
    ];
    return ListView.builder(
      itemCount: expandableTaskSections.length,
      itemBuilder: (context, int index) {
        return expandableTaskSections[index];
      },
    );
  }
}
