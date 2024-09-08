import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snazzy_todo_list/src/models/task_sort_options.dart';
import 'package:snazzy_todo_list/src/utils/filter_tasks.dart';

import '../../models/task.dart';
import '../../models/section_heading.dart';
import '../../providers/task_provider.dart';
import '../expandable_task_sections.dart';
import '../task_tile.dart';

class TaskSectionBuilder extends StatelessWidget {
  final GroupBy groupBy;
  final SectionHeading sectionHeading;
  final TaskSortOptions taskSortOptions;

  const TaskSectionBuilder({
    super.key,
    required this.groupBy,
    required this.sectionHeading,
    required this.taskSortOptions,
  });

  @override
  Widget build(BuildContext context) {
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

    List<Task> tasks = context.select<TaskProvider, List<Task>>(
      (p) {
        final FilterTasks filterTasks = FilterTasks(
          tasks: p.todoList,
          taskSortOptions: taskSortOptions,
        );
        switch (groupBy) {
          case GroupBy.completed:
            return filterTasks.byCompletion(isCompleted: true);
          case GroupBy.dueDate:
            return filterTasks.byDate(
              datePeriod: sectionHeading.heading.split(' ')[0],
              dateType: 'due',
            );
          case GroupBy.notCompleted:
            return filterTasks.byCompletion(isCompleted: false);
          case GroupBy.priority:
            return filterTasks.byPriority(
                strPriority: sectionHeading.heading.split(' ')[0]);
          default: //GroupBy.none; //TODO: Change to list of individual tasks
            return filterTasks.byCompletion(isCompleted: false);
        }
      },
    );

    // debugPrint("Rebuilding Task Section: ${sectionHeading.heading}");
    return ExpandableTaskSection(
      titleText: sectionHeading.heading,
      children: createTaskTileListFrom(tasks),
    );
  }
}

/// Determines which style to use to paint the highlight.
enum GroupBy {
  /// Does NOT group tasks.
  none,

  /// Groups Tasks by those NOT completed.
  notCompleted,

  /// Groups Tasks by those completed.
  completed,

  /// Groups Tasks by priority.
  priority,

  /// Groups Tasks by due date.
  dueDate
}
