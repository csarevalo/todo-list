import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _textEditingController = TextEditingController();

  void _addTask() {
    final taskTitleText = _textEditingController.text;
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final task = taskProvider.createTask(
      title: taskTitleText,
      priority: 2,
    );
    if (taskTitleText.isNotEmpty) {
      taskProvider.addTask(task);
    }
    _textEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).todoList;

    return Scaffold(
      backgroundColor: Colors.deepPurple.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do List"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white70,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, index) {
          final task = tasks[index];
          final taskProvider =
              Provider.of<TaskProvider>(context, listen: false);
          return TaskTile(
            title: task.title,
            isDone: task.isDone,
            priority: task.priority,
            onCompleted: (value) => taskProvider.checkboxChanged(index),
            onDeleted: (context) => taskProvider.deleteTask(index),
            // onPriorityChanged: (p0) => priorityChanged(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white70,
        // onPressed: () => _addTask(),
        onPressed: () => _displayAddTaskDialog(context),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Future<dynamic> _displayAddTaskDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Add a Task"),
        content: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              hintText: 'Add New To-Do',
              filled: true,
              fillColor: Colors.deepPurple.shade200,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                  ),
                  borderRadius: BorderRadius.circular(10)),
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
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              _addTask();
            },
            child: Text("Add"),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
