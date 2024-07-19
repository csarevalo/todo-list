import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/providers/task_provider.dart';

class ChangePriorityDialog extends StatelessWidget {
  final int taskId;
  final int currentPriority;
  const ChangePriorityDialog({
    super.key,
    required this.taskId,
    required this.currentPriority,
  });

  void _changePriority(BuildContext context, {required int newPriority}) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.changePriority(taskId, newPriority);
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
            priority: 3,
            active: currentPriority == 3,
            onPressed: () {
              _changePriority(context, newPriority: 3);
            },
          ),
          priorityButton(
            priority: 2,
            active: currentPriority == 2,
            onPressed: () {
              _changePriority(context, newPriority: 2);
            },
          ),
          priorityButton(
            priority: 1,
            active: currentPriority == 1,
            onPressed: () {
              _changePriority(context, newPriority: 1);
            },
          ),
          priorityButton(
            priority: 0,
            active: currentPriority == 0,
            onPressed: () {
              _changePriority(context, newPriority: 0);
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

  TextButton priorityButton({
    required int priority,
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
      Colors.grey.shade400,
      Colors.blue,
      Colors.yellow.shade700,
      Colors.red.shade600,
    ];
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        priority == 0 ? Icons.flag_outlined : Icons.flag,
        color: priorityColors[priority],
      ),
      label: Row(
        children: [
          Expanded(
            child: Text(
              priorityLevels[priority],
              style: TextStyle(
                fontSize: 16,
                color: priorityColors[priority],
              ),
            ),
          ),
          active ? const Icon(Icons.check) : const SizedBox.shrink(),
          // if (active) const Icon(Icons.check),
        ],
      ),
    );
  }
}
