import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/src/providers/task_provider.dart';

import '../../models/task.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  const EditTaskDialog({super.key, required this.task});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  _EditTaskDialogState();
  final TextEditingController _taskTitleController = TextEditingController();
  final List<String> _priorityCallbackOptions = [
    "None",
    "Low",
    "Medium",
    "High",
  ];
  String? _dropdownPriorityValue;
  int _priority = 0;
  DateTime? _newDateDue;

  bool _isTextFieldEmpty = false;

  void _editTask(BuildContext context) {
    String taskTitleText = _taskTitleController.text;
    while (taskTitleText.contains(RegExp(r'  '))) {
      // Remove all extra spaces in sentence.
      taskTitleText = taskTitleText.replaceAll(RegExp(r'  '), ' ');
    }
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    if (taskTitleText.isNotEmpty) {
      taskProvider.updateTask(
        widget.task.id,
        newTitle: taskTitleText,
        newPriority: _priority,
        newDateDue: _newDateDue,
      );
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
    final today = DateUtils.dateOnly(DateTime.now());
    showDatePicker(
      context: context,
      cancelText: "Clear",
      initialDate: _newDateDue ?? today,
      firstDate: today.subtract(const Duration(days: 365 * 25)), // 25 yrs ago
      lastDate: today.add(const Duration(days: 365 * 50)), // 50 yrs in future
    ).then(
      (value) {
        setState(() {
          _newDateDue = value;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _taskTitleController.text = widget.task.title; //task title
    _dropdownPriorityValue =
        _priorityCallbackOptions[widget.task.priority]; //dropdown priority val
    _priority = widget.task.priority; //task priority
    _newDateDue = widget.task.dateDue; //task due date
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      backgroundColor: themeColors.primaryContainer,
      title: const Text("My Task"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: true,
            textInputAction:
                TextInputAction.done, // submit on enter... no new lines
            maxLines: 3, // limit lines displayed
            maxLength: 150, // max # of chars
            maxLengthEnforcement:
                MaxLengthEnforcement.truncateAfterCompositionEnds,
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(r"\n")),
              FilteringTextInputFormatter.deny(RegExp(r"\t")),
            ],
            controller: _taskTitleController,
            decoration: const InputDecoration(
              hintText: 'What are you going to do?',
              border: InputBorder.none, //OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              _editTask(context);
            },
            onChanged: (value) {
              setState(() {
                _isTextFieldEmpty = value.isEmpty;
              });
            },
          ),
        ],
      ),
      actions: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_newDateDue == null) ...[
              IconButton(
                onPressed: _showDatePicker,
                icon: Icon(
                  Icons.event_busy,
                  color: themeColors.onPrimaryContainer,
                ),
              ),
            ] else ...[
              TextButton.icon(
                onPressed: _showDatePicker,
                label: Text(DateFormat.yMMMd().format(_newDateDue!).toString()),
                icon: Icon(
                  Icons.date_range_rounded,
                  color: themeColors.onPrimaryContainer,
                ),
              ),
            ],
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
            foregroundColor: themeColors.primaryContainer,
            disabledBackgroundColor: themeColors.error,
            disabledForegroundColor: themeColors.onError,
          ),
          onPressed: _isTextFieldEmpty
              ? null // to disable update button
              : () => _editTask(context),
          child: const Text("Update"),
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
