import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/task_provider.dart';

class ChangePriorityDialog extends StatelessWidget {
  final String taskID;
  const ChangePriorityDialog({
    super.key,
    required this.taskID,
  });

  void _changePriority(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    // final test = taskProvider.
    //get task priority
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: const Text("Priority"),
      contentPadding: const EdgeInsets.only(top: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          priorityButton(
            3,
            active: true,
            onPressed: () {
              _changePriority(context);
            },
          ),
          priorityButton(
            2,
            onPressed: () {
              _changePriority(context);
            },
          ),
          priorityButton(
            1,
            onPressed: () {
              _changePriority(context);
            },
          ),
          priorityButton(
            0,
            onPressed: () {
              _changePriority(context);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Cancel", textAlign: TextAlign.center),
            ],
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(vertical: 8),
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  TextButton priorityButton(
    int priorityLvl, {
    void Function()? onPressed,
    bool active = false,
  }) {
    List<String> priorityLevels = <String>[
      "No Priority",
      "Low Priority",
      "Medium Priority",
      "High Priority",
    ];
    List<Color> priorityColors = [
      Colors.grey,
      Colors.blue,
      Colors.yellow.shade700,
      Colors.red.shade600,
    ];
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        priorityLvl == 0 ? Icons.flag_outlined : Icons.flag,
        color: priorityColors[priorityLvl],
      ),
      label: Row(
        children: [
          Expanded(
            child: Text(
              priorityLevels[priorityLvl],
              style: TextStyle(
                fontSize: 16,
                color: priorityColors[priorityLvl],
              ),
            ),
          ),
          active ? const Icon(Icons.check) : const SizedBox(),
        ],
      ),
    );
  }
}
