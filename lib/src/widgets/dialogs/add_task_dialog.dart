import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/providers/task_provider.dart';

class AddTaskDialog extends StatefulWidget {
  AddTaskDialog({super.key});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  String? _dropdownPriorityValue = "None";
  int _priority = 0;
  DateTime? _newDueDate;

  void _addTask(BuildContext context) {
    final taskTitleText = _taskTitleController.text;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = taskProvider.createTask(
      title: taskTitleText,
      priority: _priority,
      dueDate: _newDueDate,
    );
    if (taskTitleText.isNotEmpty) {
      taskProvider.addTask(task);
    }
    _taskTitleController.clear();
    Navigator.of(context).pop();
  }

  void dropdownPriorityCallback(String? priority) {
    setState(() {
      _dropdownPriorityValue = priority;
      switch (priority) {
        case "High":
          _priority = 3;
        case "Medium":
          _priority = 2;
        case "Low":
          _priority = 1;
        default:
          _priority = 0;
      }
    });
  }

  void _showDatePicker() {
    final today = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: _newDueDate ?? today,
      firstDate: today.subtract(const Duration(days: 365 * 25)),
      lastDate: today.add(const Duration(days: 365 * 50)),
    ).then(
      (value) {
        setState(() {
          _newDueDate = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: themeColors.primaryContainer,
      title: const Text("Add a Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
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
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            (_newDueDate == null)
                ? IconButton(
                    onPressed: _showDatePicker,
                    icon: Icon(
                      Icons.event_busy,
                      color: themeColors.onPrimaryContainer,
                    ),
                  )
                : TextButton.icon(
                    onPressed: _showDatePicker,
                    label: Text(
                        DateFormat.yMMMd().format(_newDueDate!).toString()),
                    icon: Icon(
                      Icons.date_range_rounded,
                      color: themeColors.onPrimaryContainer,
                    ),
                  ),
            DropdownButton(
              value: _dropdownPriorityValue,
              iconSize: 0,
              items: const [
                DropdownMenuItem(
                  value: "High",
                  child: Icon(Icons.flag, color: Colors.red),
                ),
                DropdownMenuItem(
                  value: "Medium",
                  child: Icon(Icons.flag, color: Colors.yellow),
                ),
                DropdownMenuItem(
                  value: "Low",
                  child: Icon(Icons.flag, color: Colors.blue),
                ),
                DropdownMenuItem(
                  value: "None",
                  child: Icon(Icons.flag_outlined, color: Colors.grey),
                )
              ],
              onChanged: dropdownPriorityCallback,
            )
          ],
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor: themeColors.primary,
              foregroundColor: themeColors.primaryContainer),
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
