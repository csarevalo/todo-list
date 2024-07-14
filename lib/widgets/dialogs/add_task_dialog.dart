import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/task_provider.dart';

class AddTaskDialog extends StatelessWidget {
  final TextEditingController _taskTitleController = TextEditingController();

  AddTaskDialog({super.key});

  void _addTask(BuildContext context) {
    final taskTitleText = _taskTitleController.text;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = taskProvider.createTask(
      title: taskTitleText,
      priority: 2,
    );
    if (taskTitleText.isNotEmpty) {
      taskProvider.addTask(task);
    }
    _taskTitleController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add a Task"),
      content: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: TextField(
          autofocus: true,
          controller: _taskTitleController,
          decoration: InputDecoration(
            hintText: 'Add New To-Do',
            filled: true,
            fillColor: Colors.deepPurple.shade200,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.deepPurple,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      actions: <Widget>[
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            _addTask(context);
          },
          child: const Text("Add"),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
    );
  }
}
