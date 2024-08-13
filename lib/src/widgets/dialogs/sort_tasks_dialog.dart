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
  String dropdownValue = _sortOptions.first;
  String dropdownValue2 = "None";

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    dropdownValue = widget.settingsController.taskViewOptions.sort1stBy;

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
          GroupByRow(settingsController: widget.settingsController),
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
          SortByRow(
            settingsController: widget.settingsController,
            initSort: true,
          ),
          DropdownButton(
            value: dropdownValue,
            onChanged: (String? value) {
              // setState(() {
              //   dropdownValue = value!;
              // });
              widget.settingsController.updateTaskViewOptions(
                newSort1stBy: value,
              );
            },
            items: _sortOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value.toLowerCase().replaceAll(" ", "_"),
                child: Text(value),
              );
            }).toList(),
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
          SortByRow(
            settingsController: widget.settingsController,
            initSort: false,
          ),
          DropdownButton(
            value: dropdownValue2,
            onChanged: (String? value) {
              setState(() {
                dropdownValue2 = value!;
              });
            },
            items: (_sortOptions + ["None"])
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value.replaceAll(" ", "_"),
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class GroupByRow extends StatelessWidget {
  const GroupByRow({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => settingsController.updateTaskViewOptions(
            newGroupBy: "Priority",
          ),
          child: const Text("Priority"),
        ),
        TextButton(
          onPressed: () => settingsController.updateTaskViewOptions(
            newGroupBy: "Date_Due",
          ),
          child: const Text("Due Date"),
        ),
        TextButton(
          onPressed: () => settingsController.updateTaskViewOptions(
            newGroupBy: "None",
          ),
          child: const Text("None"),
        ),
      ],
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
                  ? update(newSort1stBy: "Last_modified")
                  : update(newSort2ndBy: "Last_modified"),
              child: const Text("Last Modified"),
            ),
            TextButton(
              onPressed: () => initSort
                  ? update(newSort1stBy: "Date_created")
                  : update(newSort2ndBy: "Date_created"),
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
