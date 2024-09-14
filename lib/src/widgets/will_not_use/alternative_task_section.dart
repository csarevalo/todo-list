import 'package:flutter/foundation.dart';
// import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task.dart';
import '../../models/task_sort_options.dart';
import '../../providers/task_provider.dart';
import '../../utils/filter_tasks.dart';
import '../expandable_task_sections.dart';
import '../task_tile.dart';

///"taskProviderSelect"
// extension BuildContextExtensions on BuildContext {
//   /// Shortcut to read [TaskProvider].
//   TaskProvider get taskProvider => read<TaskProvider>();

//   /// Shortcut to select a value from [TaskProvider].
//   ///
//   /// f is pointing to the value to be selected from [TaskProvider].
//   T taskProviderSelect<T>(T Function(TaskProvider p) f) {
//     /// Using deep collection quality to ensure unique hash for collections.
//     select((TaskProvider p) => const DeepCollectionEquality().hash(f(p)));

//     /// Get the actual value by reading [SomeProvider].
//     return f(taskProvider);
//   }
// }

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
    late final List<Task> compTasks;
    bool comparing = false;

    return Selector<TaskProvider, List<Task>>(
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

        if (!comparing) {
          compTasks = List.unmodifiable(filteredTasks);
          comparing = true;
        }
        return List.unmodifiable(filteredTasks);
      },
      builder: (ctx, filteredTasks, __) {
        return ExpandableTaskSection(
          titleText: sectionTitle,
          children: _createTaskTileListFrom(
            context: ctx,
            taskList: filteredTasks,
            taskProvider: taskProvider,
          ),
        );
      },
      // shouldRebuild: (previous, next) => !listEquals(previous, next),

      shouldRebuild: (previous, next) {
        debugPrint("\n\nChecking if willRebuild \"$sectionTitle\"");

        // final List<Task> previous = List.from(compTasks);

        for (Task t in previous) {
          debugPrint(
            "Previous Section: ${t.title} \tLast Modified: ${t.dateModified}",
          );
        }
        for (Task t in next) {
          debugPrint(
            "    Next Section: ${t.title} \tLast Modified: ${t.dateModified}",
          );
        }
        bool willRebuild = !listEquals(compTasks, next); //previous != next;
        debugPrint(
          willRebuild
              ? "Yes \"$sectionTitle\" is rebuilt"
              : "No, \"$sectionTitle\" is not rebuild",
        );
        debugPrint("");
        return willRebuild;
      },
    );

    // );
    // return children.isEmpty
    //     ? const SizedBox.shrink()
    //     : Expandable
  }
}

List<Widget> _createTaskTileListFrom({
  required BuildContext context,
  required List<Task> taskList,
  required TaskProvider taskProvider,
}) {
  List<Widget> taskTiles = [];
  for (var task in taskList) {
    taskTiles.add(
      TaskTile(
        task: task,
        onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
        onDelete: (ctx) {
          if (ctx.mounted) taskProvider.deleteTask(task.id);
        },
      ),
    );
  }
  return taskTiles;
}

///COMP TASKS USING "taskProviderSelect"
// final compTasks = context.taskProviderSelect((TaskProvider p) {
//   final FilterTasks filterTasks = FilterTasks(
//     tasks: p.todoList,
//     taskSortOptions: taskSortOptions,
//   );
//   late List<Task> filteredTasks;
//   if (sectionTitle.toLowerCase() == "completed") {
//     filteredTasks = filterTasks.byCompletion(isCompleted: true);
//   } else {
//     switch (taskSortOptions.groupBy) {
//       case GroupBy.priority:
//         filteredTasks = filterTasks.byPriority(strPriority: specificSection);
//       case GroupBy.dueDate:
//         filteredTasks =
//             filterTasks.byDate(datePeriod: specificSection, dateType: 'due');
//       default:
//         //TODO: Do not add a section and just the tasks
//         filteredTasks = filterTasks.byCompletion(isCompleted: false);
//     }
//   }
//   return filteredTasks;
// });


///TASK SELECTOR

// Selector<TaskProvider, Task>(
//   selector: (_, p) {
//     return p.todoList.firstWhere((t) => t.id == task.id);
//   },
//   builder: (ctx, task, _) {
//     return TaskTile(
//       task: task,
//       onCheckboxChanged: (value) => taskProvider.toggleDone(task.id),
//       onDelete: (ctx) {
//         if (ctx.mounted) taskProvider.deleteTask(task.id);
//       },
//     );
//   },
//   shouldRebuild: (previous, next) {
//     debugPrint(
//       "Previous Task: ${previous.title} \t${previous.dateModified}",
//     );
//     debugPrint(
//       "    Next Task: ${next.title} \t${next.dateModified}",
//     );
//     bool willRebuild = !identical(previous, next); //previous != next;
//     debugPrint(
//       willRebuild
//           ? "YES, will rebuild ${next.title}"
//           : "NO, will not rebuild ${next.title}",
//     );
//     return willRebuild;
//   },
// ),


///TASK_SECTION shouldRebuil!

// shouldRebuild: (previous, next) {
//   debugPrint("\n\nChecking if willRebuild \"$sectionTitle\"");
//   for (Task t in previous) {
//     debugPrint(
//       "Previous Section: ${t.title} \t ${t.dateModified}",
//     );
//   }
//   for (Task t in next) {
//     debugPrint(
//       "    Next Section: ${t.title} \t ${t.dateModified}",
//     );
//   }
//   bool willRebuild = !identical(previous, next); //previous != next;
//   debugPrint(
//     willRebuild
//         ? "Yes \"$sectionTitle\" is rebuilt"
//         : "No, \"$sectionTitle\" is not rebuild",
//   );
//   debugPrint("");
//   return willRebuild;
// },