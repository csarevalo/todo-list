import 'package:flutter/material.dart';
import 'package:todo_list/src/providers/settings_controller.dart';

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
  // Initial Selected Value
  // String dropdownValue = _sortOptions.first;
  // String dropdownValue2 = "None";
  String segmentedButtonValue = "Priority";

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // dropdownValue = widget.settingsController.taskViewOptions.sort1stBy;
    // dropdownValue2 = widget.settingsController.taskViewOptions.sort2ndBy;

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
          SortButtons(
            settingsController: widget.settingsController,
            sort: "group", // Call update tasks group by in settings
            sortOptions: const ["Priority", "Due Date", "None"],
          ),
          SegmentedButton(
            segments: ["Priority", "Due Date", "None"]
                .map<ButtonSegment<String>>((String value) {
              return ButtonSegment(
                value: value.replaceAll(" ", "_"),
                label: Text(value),
              );
            }).toList(),
            selected: <String>{segmentedButtonValue},
            showSelectedIcon: false,
            onSelectionChanged: (value) {
              setState(() {
                segmentedButtonValue = value.first;
              });
            },
          ),
          Row(
            children: [
              Text(
                "Sort 1st By",
                style: textTheme.titleSmall,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.settingsController.taskViewOptions.desc1
                      ? widget.settingsController
                          .updateTaskViewOptions(newDesc1: false)
                      : widget.settingsController
                          .updateTaskViewOptions(newDesc1: true);
                },
                child: widget.settingsController.taskViewOptions.desc1
                    ? const Text("Desc")
                    : const Text("Asc"),
              ),
            ],
          ),
          // SortByRow(
          //   settingsController: widget.settingsController,
          //   initSort: true,
          // ),
          SortDropdownButton(
            sort1st: true,
            settingsController: widget.settingsController,
            menuItems: _sortOptions,
          ),
          Row(
            children: [
              Text(
                "Sort 2nd By",
                style: textTheme.titleSmall,
              ),
              ElevatedButton(
                onPressed: () {
                  widget.settingsController.taskViewOptions.desc2
                      ? widget.settingsController
                          .updateTaskViewOptions(newDesc2: false)
                      : widget.settingsController
                          .updateTaskViewOptions(newDesc2: true);
                },
                child: widget.settingsController.taskViewOptions.desc2
                    ? const Text("Desc")
                    : const Text("Asc"),
              ),
            ],
          ),
          // SortByRow(
          //   settingsController: widget.settingsController,
          //   initSort: false,
          // ),
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
    // required this.dropdownValue,
    required this.settingsController,
    required this.menuItems,
  });

  final bool sort1st;
  // final String dropdownValue;
  final SettingsController settingsController;
  final List<String> menuItems;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
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
          child: Text(strMenuItem),
        );
      }).toList(),
    );
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

class SortByRow extends StatelessWidget {
  const SortByRow({
    super.key,
    required this.settingsController,
    this.initSort = true,
  });

  final SettingsController settingsController;
  final bool initSort;

  @override
  Widget build(BuildContext context) {
    var update = settingsController.updateTaskViewOptions;
    return Column(
      children: [
        Row(
          children: [
            TextButton(
              onPressed: () => initSort
                  ? update(newSort1stBy: "Priority")
                  : update(newSort2ndBy: "Priority"),
              child: const Text("Priority"),
            ),
            TextButton(
              onPressed: () => initSort
                  ? update(newSort1stBy: "Due_Date")
                  : update(newSort2ndBy: "Due_Date"),
              child: const Text("Due Date"),
            ),
            TextButton(
              onPressed: () => initSort
                  ? update(newSort1stBy: "Title")
                  : update(newSort2ndBy: "Title"),
              child: const Text("Title"),
            ),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => initSort
                  ? update(newSort1stBy: "Last_Modified")
                  : update(newSort2ndBy: "Last_Modified"),
              child: const Text("Last Modified"),
            ),
            TextButton(
              onPressed: () => initSort
                  ? update(newSort1stBy: "Date_Created")
                  : update(newSort2ndBy: "Date_Created"),
              child: const Text("Date Created"),
            ),
          ],
        ),
        initSort
            ? const SizedBox.shrink()
            : TextButton(
                onPressed: () => update(newSort2ndBy: "None"),
                child: const Text("None"),
              ),
      ],
    );
  }
}
