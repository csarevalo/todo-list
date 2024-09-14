import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../models/task_sort_options.dart';
import '../../providers/task_provider.dart';
import '../../utils/filter_tasks.dart';
import '../expandable_task_sections.dart';
import '../task_tile.dart';

class TaskSection extends StatelessWidget {
  final TaskSortOptions taskSortOptions;
  final String sectionTitle;

  const TaskSection({
    super.key,
    required this.sectionTitle,
    required this.taskSortOptions,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('Rebuilt TaskSection: $sectionTitle');

    List<Widget> createTaskTileListFrom(List<Task> taskList) {
      debugPrint("createTaskTileListFrom");
      final taskProvider = Provider.of<TaskProvider>(
        context,
        listen: false,
      );
      List<Widget> taskTiles = [];
      for (var taskk in taskList) {
        // Task task = context.select<TaskProvider, Task>(
        //   (p) => p.todoList.firstWhere((t) => t.id == taskk.id),
        // );
        taskTiles.add(
          Selector<TaskProvider, Task>(
            selector: (_, p) => p.todoList.firstWhere((t) => t.id == taskk.id),
            builder: (context, Task task, __) {
              // debugPrint("Rebuilding ${task.title} with TaskSelector");
              // final taskProvider = context.read<TaskProvider>();
              return TaskTile(
                task: task,
                onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
                onDelete: (ctx) {
                  if (ctx.mounted) taskProvider.deleteTask(task.id);
                },
              );
            },
            shouldRebuild: (previous, next) {
              return previous != next;
            },
          ),
        );
      }
      return taskTiles;
    }

    List<Widget> getTaskTilesBasedOnCompletion({required isCompleted}) {
      debugPrint("getTaskTilesBasedOnCompletion");
      final filteredTasks = context.select<TaskProvider, List<Task>>(
        (p) {
          final FilterTasks filterTasks = FilterTasks(
            tasks: p.todoList,
            taskSortOptions: taskSortOptions,
          );
          return filterTasks.byCompletion(
            isCompleted: isCompleted,
          );
        },
      );

      // final filteredTasks = FilterTasks(
      //   tasks: context.read<TaskProvider>().todoList,
      //   taskSortOptions: taskSortOptions,
      // ).byCompletion(
      //   isCompleted: isCompleted,
      // );

      List<Widget> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    List<Widget> getTaskTileBasedOnPriority({
      required String strPriority,
      bool isCompleted = false, // By default show uncompleted tasks only
    }) {
      debugPrint("getTaskTileBasedOnPriority");
      final filteredTasks = context.select<TaskProvider, List<Task>>(
        (p) {
          final FilterTasks filterTasks = FilterTasks(
            tasks: p.todoList,
            taskSortOptions: taskSortOptions,
          );
          return filterTasks.byPriority(
            strPriority: strPriority,
            isCompleted: isCompleted,
          );
        },
      );

      List<Widget> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    /// Get TaskTiles Based on Date
    List<Widget> getTaskTileBasedOnDate({
      /// Options: overdue, today, tomorrow, next, later, no..date
      required String datePeriod,

      /// Options: done, modified, due, created
      required String dateType,

      /// Default: uncompleted
      bool isCompleted = false,
    }) {
      debugPrint("getTaskTileBasedOnDate");
      final filteredTasks = context.select<TaskProvider, List<Task>>(
        (p) {
          final FilterTasks filterTasks = FilterTasks(
            tasks: p.todoList,
            taskSortOptions: taskSortOptions,
          );
          return filterTasks.byDate(
            datePeriod: datePeriod,
            dateType: dateType,
            isCompleted: isCompleted,
          );
        },
      );

      List<Widget> taskTiles = createTaskTileListFrom(filteredTasks);
      return taskTiles;
    }

    late List<Widget> Function(String)? getChildren;
    if (sectionTitle.toLowerCase() == "completed") {
      getChildren = (String s) => getTaskTilesBasedOnCompletion(
            isCompleted: true,
          );
    } else {
      switch (taskSortOptions.groupBy) {
        //.toLowerCase()) { //TODO: remove
        case GroupBy.priority: //"priority":
          getChildren = (String s) => getTaskTileBasedOnPriority(
                strPriority: s,
              );
        case GroupBy.dueDate: //"due_date":
          getChildren = (String s) => getTaskTileBasedOnDate(
                datePeriod: s,
                dateType: 'due',
              );
        default:
          //TODO: Do not add a section and just the tasks
          getChildren = (String s) => getTaskTilesBasedOnCompletion(
                isCompleted: false,
              );
      }
    }

    List<Widget> children = getChildren(sectionTitle.split(' ')[0]);
    return children.isEmpty
        ? const SizedBox.shrink()
        : ExpandableTaskSection(
            titleText: sectionTitle,
            children: children,
          );
  }
}
