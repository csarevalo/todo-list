import 'package:flutter/material.dart';

class ChangePriorityDialog extends StatelessWidget {
  const ChangePriorityDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Priority"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          priorityButton(0),
          priorityButton(1),
          priorityButton(2),
          priorityButton(3, active: true),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel"),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  ElevatedButton priorityButton(int priorityLvl, {bool active = false}) {
    List<String> priorityLevels = <String>[
      "No Priority",
      "Low Priority",
      "Medium Priority",
      "High Priority",
    ];
    List<Color> priorityColors = [
      Colors.grey,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    return ElevatedButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(
            Icons.flag,
            color: priorityColors[priorityLvl],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(priorityLevels[priorityLvl]),
            ),
          ),
          active ? Icon(Icons.check) : SizedBox(),
        ],
      ),
    );
  }
}
