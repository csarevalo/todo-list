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
      backgroundColor: Colors.purple.shade50,
      // title: const Text("Add a Task"),
      content: TextField(
        autofocus: true,
        textInputAction:
            TextInputAction.done, // submit on enter... no new lines
        maxLines: 3, // limit lines displayed
        controller: _taskTitleController,
        decoration: const InputDecoration(
          hintText: 'What are you going to do?',
          border: InputBorder.none,
        ),
        onSubmitted: (value) {
          _addTask(context);
        },
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
      actionsPadding: const EdgeInsets.only(bottom: 15),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 15),
      insetPadding: const EdgeInsets.all(80), // outside dialog
    );
  }
}
