import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePriorityDialog extends StatelessWidget {
  const ChangePriorityDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: const Text("Priority"),
      contentPadding: const EdgeInsets.only(top: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          priorityButton(3, active: true),
          priorityButton(2),
          priorityButton(1),
          priorityButton(0),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Cancel",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(vertical: 8),
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  TextButton priorityButton(int priorityLvl, {bool active = false}) {
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
      onPressed: () {},
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
