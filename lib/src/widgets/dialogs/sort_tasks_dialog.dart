import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/task_sort_options.dart';
import '../../providers/task_preferences_controller.dart';

Future<void> showSortTasksDialog({
  required BuildContext context,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TransitionBuilder? builder,
}) async {
  Widget dialog = const SortTasksDialog();
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}

class SortTasksDialog extends StatelessWidget {
  const SortTasksDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final taskPreferences = context.read<TaskPreferencesController>();

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: themeColors.primaryContainer,
      alignment: Alignment.bottomCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                "Group By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Selector<TaskPreferencesController, String>(
              selector: (_, taskPrefs) => taskPrefs.taskSortOptions.groupBy,
              builder: (context, groupBy, _) => SegmentedButton(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: themeColors.tertiaryContainer,
                  selectedForegroundColor: themeColors.onTertiaryContainer,
                  backgroundColor: themeColors.primaryContainer,
                  foregroundColor: themeColors.onPrimaryContainer,
                ),
                segments: ["Priority", "Due Date", "List", "Tag", "None"]
                    .map<ButtonSegment<String>>((String value) {
                  return ButtonSegment(
                    //TODO: Add an icon for each GROUPBY
                    value: value.replaceAll(" ", "_"),
                    label: Text(value),
                  );
                }).toList(),
                selected: <String>{groupBy},
                showSelectedIcon: false,
                onSelectionChanged: (value) {
                  taskPreferences.updateTaskSortOptions(
                    newGroupBy: value.first,
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Sort By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Selector<TaskPreferencesController, TaskSortOptions>(
              selector: (_, p) => p.taskSortOptions,
              builder: (_, taskSortOptions, __) {
                return SortDropdownButton(
                  value: sortByToString(taskSortOptions.sort1stBy),
                  menuItems: taskSortOptions.sortOptions
                      .where((opt) => opt != "None")
                      .toList(),
                  onValueChanged: (value) {
                    if (value == null) return;
                    SortBy sortBy = strToSortBy(value);
                    taskPreferences.updateTaskSortOptions(
                      newSort1stBy: sortBy,
                    );
                  },
                  onToggleSorting: () => taskPreferences.updateTaskSortOptions(
                    newDesc1: !taskSortOptions.desc1,
                  ),
                  desc: taskSortOptions.desc1,
                );
              }),
          Row(children: [
            Text(
              "Then By",
              style: textTheme.titleSmall,
            ),
          ]),
          Selector<TaskPreferencesController, TaskSortOptions>(
              selector: (_, p) => p.taskSortOptions,
              builder: (_, taskSortOptions, __) {
                return SortDropdownButton(
                  value: sortByToString(taskSortOptions.sort2ndBy),
                  menuItems: taskSortOptions.sortOptions,
                  onValueChanged: (value) {
                    if (value == null) return;
                    SortBy sortBy = strToSortBy(value);
                    taskPreferences.updateTaskSortOptions(
                      newSort2ndBy: sortBy,
                    );
                  },
                  onToggleSorting: () => taskPreferences.updateTaskSortOptions(
                    newDesc2: !taskSortOptions.desc2,
                  ),
                  desc: taskSortOptions.desc2,
                );
              }),
        ],
      ),
    );
  }
}

class SortDropdownButton extends StatelessWidget {
  final String value;
  final List<String> menuItems;
  final void Function(String?)? onValueChanged;
  final void Function()? onToggleSorting;
  final bool? desc;

  const SortDropdownButton({
    super.key,
    required this.value,
    required this.menuItems,
    required this.onValueChanged,
    this.onToggleSorting,
    this.desc = true,
  });

  @override
  Widget build(BuildContext context) {
    ColorScheme themeColors = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;

    return DropdownButton(
      isExpanded: true,
      style: textTheme.titleMedium!.copyWith(color: themeColors.primary),
      underline: const SizedBox.shrink(),
      value: value,
      onChanged: onValueChanged,
      items: (menuItems).map<DropdownMenuItem<String>>((String strMenuItem) {
        return DropdownMenuItem(
          value: strMenuItem,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: themeColors.tertiary,
                radius: 5,
              ),
              const SizedBox.square(dimension: 8),
              Text(strMenuItem),
            ],
          ),
        );
      }).toList(),
      icon: onToggleSorting == null
          ? const SizedBox.shrink()
          : IconButton(
              onPressed: onToggleSorting,
              icon: desc!
                  ? Icon(Icons.keyboard_double_arrow_down,
                      color: themeColors.primary)
                  : Icon(Icons.keyboard_double_arrow_up,
                      color: themeColors.primary),
            ),
    );
  }
}

// class SortDropdownButton extends StatelessWidget {
//   final bool sort1st;
//   final List<String> menuItems;
//   final bool includeNone;

//   const SortDropdownButton({
//     super.key,
//     required this.sort1st,
//     required this.menuItems,
//     this.includeNone = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     ColorScheme themeColors = Theme.of(context).colorScheme;
//     TextTheme textTheme = Theme.of(context).textTheme;

//     final taskPreferences = context.read<TaskPreferencesController>();
//     final taskSortOptions =
//         context.select<TaskPreferencesController, TaskSortOptions>(
//             (taskPrefs) => taskPrefs.taskSortOptions);

//     // late final List<String> menuItems;
//     // if (includeNone) {
//     //   menuItems = taskSortOptions.sortOptions;
//     // } else {
//     //   menuItems =
//     //       taskSortOptions.sortOptions.where((opt) => opt != "None").toList();
//     // }
//     return DropdownButton(
//       isExpanded: true,
//       style: textTheme.titleMedium!.copyWith(color: themeColors.primary),
//       underline: const SizedBox.shrink(),
//       value: sort1st
//           ? sortByToString(taskSortOptions.sort1stBy)
//           : sortByToString(taskSortOptions.sort2ndBy),
//       onChanged: (value) {
//         if (value == null) return;
//         SortBy sortBy = strToSortBy(value);
//         if (sort1st) {
//           taskPreferences.updateTaskSortOptions(newSort1stBy: sortBy);
//         } else {
//           taskPreferences.updateTaskSortOptions(newSort2ndBy: sortBy);
//         }
//       },
//       items: (menuItems).map<DropdownMenuItem<String>>((String strMenuItem) {
//         return DropdownMenuItem(
//           value: strMenuItem, //.replaceAll(" ", "_"),
//           child: Row(
//             children: [
//               CircleAvatar(
//                 backgroundColor: themeColors.tertiary,
//                 radius: 5,
//               ),
//               const SizedBox.square(dimension: 8),
//               Text(strMenuItem),
//             ],
//           ),
//         );
//       }).toList(),
//       icon: IconButton(
//         onPressed: () {
//           if (sort1st) {
//             taskPreferences.updateTaskSortOptions(
//               newDesc1: !taskSortOptions.desc1,
//             );
//           } else {
//             taskPreferences.updateTaskSortOptions(
//               newDesc2: !taskSortOptions.desc2,
//             );
//           }
//         },
//         // icon: Icon(Icons.swap_vert, color: themeColors.primary),
//         icon: sort1st
//             ? (taskSortOptions.desc1
//                 ? Icon(Icons.keyboard_double_arrow_down,
//                     color: themeColors.primary)
//                 : Icon(Icons.keyboard_double_arrow_up,
//                     color: themeColors.primary))
//             : (taskSortOptions.desc2
//                 ? Icon(Icons.keyboard_double_arrow_down,
//                     color: themeColors.primary)
//                 : Icon(Icons.keyboard_double_arrow_up,
//                     color: themeColors.primary)),
//       ),
//     );
//   }
// }
