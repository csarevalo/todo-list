import 'package:flutter/material.dart';

import '../../providers/settings_controller.dart';

class SortTasksDialog extends StatefulWidget {
  final SettingsController settingsController;
  const SortTasksDialog({
    super.key,
    required this.settingsController,
  });

  @override
  State<SortTasksDialog> createState() => _SortTasksDialogState();
}

//TODO: Shorten Button names to make it more appealing...
// es: "Last Modified" to simply "Modified"

class _SortTasksDialogState extends State<SortTasksDialog> {
  // List of items in our dropdown menu
  static const List<String> _sortOptions = [
    "Priority",
    "Due Date",
    "Title",
    "Last Modified",
    "Date Created",
  ];

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
          // SortButtons(
          //   settingsController: widget.settingsController,
          //   sort: "group", // Call update tasks group by in settings
          //   sortOptions: const ["Priority", "Due Date", "None"],
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton(
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: themeColors.tertiaryContainer,
                selectedForegroundColor: themeColors.onTertiaryContainer,
                backgroundColor: themeColors.primaryContainer,
                foregroundColor: themeColors.onPrimaryContainer,
              ),
              segments: ["Priority", "Due Date", "None"]
                  .map<ButtonSegment<String>>((String value) {
                return ButtonSegment(
                  //TODO: Add an icon for each GROUPBY
                  value: value.replaceAll(" ", "_"),
                  label: Text(value),
                );
              }).toList(),
              selected: <String>{
                widget.settingsController.taskViewOptions.groupBy
              },
              showSelectedIcon: false,
              onSelectionChanged: (value) {
                widget.settingsController.updateTaskViewOptions(
                  newGroupBy: value.first,
                );
              },
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
          SortDropdownButton(
            sort1st: true,
            settingsController: widget.settingsController,
            menuItems: _sortOptions,
          ),
          Row(
            children: [
              Text(
                "Then By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          SortDropdownButton(
            sort1st: false,
            settingsController: widget.settingsController,
            menuItems: _sortOptions + ["None"],
          ),
        ],
      ),
    );
  }
}

class SortDropdownButton extends StatelessWidget {
  const SortDropdownButton({
    super.key,
    required this.sort1st,
    required this.settingsController,
    required this.menuItems,
  });

  final bool sort1st;
  final SettingsController settingsController;
  final List<String> menuItems;

  @override
  Widget build(BuildContext context) {
    ColorScheme themeColors = Theme.of(context).colorScheme;
    TextTheme textTheme = Theme.of(context).textTheme;
    return DropdownButton(
        isExpanded: true,
        style: textTheme.titleMedium!.copyWith(color: themeColors.primary),
        underline: const SizedBox.shrink(),
        value: sort1st
            ? settingsController.taskViewOptions.sort1stBy
            : settingsController.taskViewOptions.sort2ndBy,
        onChanged: (String? value) {
          if (sort1st) {
            settingsController.updateTaskViewOptions(newSort1stBy: value);
          } else {
            settingsController.updateTaskViewOptions(newSort2ndBy: value);
          }
        },
        items: (menuItems).map<DropdownMenuItem<String>>((String strMenuItem) {
          return DropdownMenuItem(
            value: strMenuItem.replaceAll(" ", "_"),
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
        icon: IconButton(
          onPressed: () {
            if (sort1st) {
              settingsController.updateTaskViewOptions(
                newDesc1: !settingsController.taskViewOptions.desc1,
              );
            } else {
              settingsController.updateTaskViewOptions(
                newDesc2: !settingsController.taskViewOptions.desc2,
              );
            }
          },
          // icon: Icon(Icons.swap_vert, color: themeColors.primary),
          icon: sort1st
              ? (settingsController.taskViewOptions.desc1
                  ? Icon(Icons.keyboard_double_arrow_down,
                      color: themeColors.primary)
                  : Icon(Icons.keyboard_double_arrow_up,
                      color: themeColors.primary))
              : (settingsController.taskViewOptions.desc2
                  ? Icon(Icons.keyboard_double_arrow_down,
                      color: themeColors.primary)
                  : Icon(Icons.keyboard_double_arrow_up,
                      color: themeColors.primary)),
        ));
  }
}

class SortButtons extends StatelessWidget {
  const SortButtons({
    super.key,
    required this.settingsController,
    required this.sort,
    required this.sortOptions,
  });

  final SettingsController settingsController;
  final List<String> sortOptions;
  final String sort; //options: "group", "sort1", "sort2"

  @override
  Widget build(BuildContext context) {
    var update = settingsController.updateTaskViewOptions;
    return Row(
      children: (sortOptions).map<Widget>((String strOption) {
        return TextButton(
          onPressed: () {
            switch (sort.toLowerCase()) {
              case "group":
                update(
                  newGroupBy: strOption.replaceAll(" ", "_"),
                );
              case "sort1":
                update(
                  newSort1stBy: strOption.replaceAll(" ", "_"),
                );
              case "sort2":
                update(
                  newSort2ndBy: strOption.replaceAll(" ", "_"),
                );
              default:
            }
          },
          child: Text(strOption),
        );
      }).toList(),
    );
  }
}

// class SortByRow extends StatelessWidget {
//   const SortByRow({
//     super.key,
//     required this.settingsController,
//     this.initSort = true,
//   });

//   final SettingsController settingsController;
//   final bool initSort;

//   @override
//   Widget build(BuildContext context) {
//     var update = settingsController.updateTaskViewOptions;
//     return Column(
//       children: [
//         Row(
//           children: [
//             TextButton(
//               onPressed: () => initSort
//                   ? update(newSort1stBy: "Priority")
//                   : update(newSort2ndBy: "Priority"),
//               child: const Text("Priority"),
//             ),
//             TextButton(
//               onPressed: () => initSort
//                   ? update(newSort1stBy: "Due_Date")
//                   : update(newSort2ndBy: "Due_Date"),
//               child: const Text("Due Date"),
//             ),
//             TextButton(
//               onPressed: () => initSort
//                   ? update(newSort1stBy: "Title")
//                   : update(newSort2ndBy: "Title"),
//               child: const Text("Title"),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             TextButton(
//               onPressed: () => initSort
//                   ? update(newSort1stBy: "Last_Modified")
//                   : update(newSort2ndBy: "Last_Modified"),
//               child: const Text("Last Modified"),
//             ),
//             TextButton(
//               onPressed: () => initSort
//                   ? update(newSort1stBy: "Date_Created")
//                   : update(newSort2ndBy: "Date_Created"),
//               child: const Text("Date Created"),
//             ),
//           ],
//         ),
//         initSort
//             ? const SizedBox.shrink()
//             : TextButton(
//                 onPressed: () => update(newSort2ndBy: "None"),
//                 child: const Text("None"),
//               ),
//       ],
//     );
//   }
// }
