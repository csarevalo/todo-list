import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/providers/task_provider.dart';

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
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: themeColors.primaryContainer,
      title: const Text("Add a Task"),
      content: TextField(
        autofocus: true,
        textInputAction:
            TextInputAction.done, // submit on enter... no new lines
        maxLines: 3, // limit lines displayed
        controller: _taskTitleController,
        decoration: const InputDecoration(
          hintText: 'What are you going to do?',
          border: InputBorder.none, //OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          _addTask(context);
        },
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            _addTask(context);
          },
          child: const Text("Add"),
        ),
      ],
      actionsAlignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 15),
      // contentPadding: EdgeInsets.symmetric(),
      // actionsPadding: const EdgeInsets.only(bottom: 15),
      // insetPadding: const EdgeInsets.all(50), // outside dialog
    );
  }
}
