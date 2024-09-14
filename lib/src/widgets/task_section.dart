import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../models/task_sort_options.dart';
import '../providers/task_provider.dart';
import '../utils/filter_tasks.dart';
import 'expandable_task_sections.dart';
import 'task_tile.dart';

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
    debugPrint('Built TaskSection: $sectionTitle');
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final String specificSection = sectionTitle.split(' ')[0];

    return Selector<TaskProvider, List<ImmutableTask>>(
      selector: (ctx, tp) {
        final FilterTasks filterTasks = FilterTasks(
          tasks: tp.todoList,
          taskSortOptions: taskSortOptions,
        );
        late List<Task> filteredTasks;
        if (sectionTitle.toLowerCase() == "completed") {
          filteredTasks = filterTasks.byCompletion(isCompleted: true);
        } else {
          switch (taskSortOptions.groupBy) {
            case GroupBy.priority:
              filteredTasks =
                  filterTasks.byPriority(strPriority: specificSection);
            case GroupBy.dueDate:
              filteredTasks = filterTasks.byDate(
                  datePeriod: specificSection, dateType: 'due');
            default:
              //TODO: Do not add a section and just the tasks
              filteredTasks = filterTasks.byCompletion(isCompleted: false);
          }
        }

        List<ImmutableTask> immutableFilteredTasks = [];
        for (Task t in filteredTasks) {
          immutableFilteredTasks.add(createImmutableTask(t));
        }
        return List.unmodifiable(immutableFilteredTasks);
      },
      builder: (ctx, immutableFilteredTasks, __) {
        return immutableFilteredTasks.isEmpty
            ? const SizedBox.shrink()
            : ExpandableTaskSection(
                titleText: sectionTitle,
                children: _createTaskTileListFrom(
                  context: ctx,
                  taskList: immutableFilteredTasks,
                  taskProvider: taskProvider,
                ),
              );
      },
      shouldRebuild: (previous, next) {
        return !const DeepCollectionEquality().equals(previous, next);
      },
    );
  }
}

List<Widget> _createTaskTileListFrom({
  required BuildContext context,
  required List<ImmutableTask> taskList,
  required TaskProvider taskProvider,
}) {
  List<Widget> taskTiles = [];
  for (var task in taskList) {
    taskTiles.add(
      TaskTile(
        task: task,
        onCheckboxChanged: (_) => taskProvider.toggleDone(task.id),
        onDelete: (ctx) {
          if (ctx.mounted) taskProvider.deleteTask(task.id);
        },
      ),
    );
  }
  return taskTiles;
}
