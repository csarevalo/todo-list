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
          Row(
            children: [
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                  newGroupBy: "Priority",
                ),
                child: const Text("Priority"),
              ),
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                  newGroupBy: "Date_Due",
                ),
                child: const Text("Due Date"),
              ),
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                  newGroupBy: "None",
                ),
                child: const Text("None"),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "Sort 1st By",
                style: textTheme.titleSmall,
              ),
            ],
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                  newSort1stBy: "Priority",
                ),
                child: const Text("Priority"),
              ),
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                  newSort1stBy: "Date_Due",
                ),
                child: const Text("Due Date"),
              ),
              TextButton(
                onPressed: () => settingsController.updateTaskSettings(
                  newSort1stBy: "None",
                ),
                child: const Text("None"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
