import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final bool checkboxState;
  final int priority;
  final Function(bool?)? onCheckboxChanged;
  final Function(BuildContext)? onDelete;
  final void Function()? onPriorityChange;

  const TaskTile({
    super.key,
    required this.title,
    required this.checkboxState,
    required this.priority,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onPriorityChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
              backgroundColor: Colors.red,
            )
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Checkbox(
                value: checkboxState,
                onChanged: onCheckboxChanged,
                checkColor: Colors.deepPurple,
                activeColor: Colors.white70,
                side: const BorderSide(color: Colors.white70),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: SizedBox(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      decoration: checkboxState
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: Colors.white70,
                      decorationThickness: 2,
                    ),
                    softWrap: false,
                  ),
                ),
              ),
              IconButton(
                onPressed: onPriorityChange,
                icon: const Icon(Icons.flag),
                alignment: Alignment.centerRight,
                color: priority == 0
                    ? Colors.grey.shade400
                    : priority == 1
                        ? Colors.blue
                        : priority == 2
                            ? Colors.yellow.shade700
                            : Colors.red.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
