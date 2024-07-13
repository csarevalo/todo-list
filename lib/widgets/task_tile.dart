import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final bool isDone;
  final int priority;
  final Function(bool?)? onCompleted;
  final Function(BuildContext)? onDeleted;
  final Function(int)? onPriorityChanged;

  const TaskTile({
    super.key,
    required this.title,
    required this.isDone,
    required this.onCompleted,
    required this.onDeleted,
    required this.priority,
    this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onDeleted,
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
                value: isDone,
                onChanged: onCompleted,
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
                      decoration: isDone
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
                onPressed: () {},
                icon: Icon(Icons.flag),
                alignment: Alignment.centerRight,
                color: priority == 1 ? Colors.blue : Colors.amber.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
