import 'package:flutter/material.dart';
import 'package:todo_list/src/providers/settings_controller.dart';

class SortTasksDialog extends StatelessWidget {
  final SettingsController settingsController;
  const SortTasksDialog({
    super.key,
    required this.settingsController,
  });

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
          GroupByRow(settingsController: settingsController),
          Row(
            children: [
              Text(
                "Sort 1st By",
                style: textTheme.titleSmall,
              ),
              TextButton(
                onPressed: () =>
                    settingsController.updateTaskViewOptions(newDesc1: true),
                child: const Text("Desc"),
              ),
              TextButton(
                onPressed: () =>
                    settingsController.updateTaskViewOptions(newDesc1: false),
                child: const Text("Asc"),
              ),
            ],
          ),
          SortByRow(settingsController: settingsController, initSort: true),
          Row(
            children: [
              Text(
                "Sort 2nd By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          SortByRow(settingsController: settingsController, initSort: false),
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
    return Row(
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
