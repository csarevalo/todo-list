import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class TodoListScreen extends StatefulWidget {
  TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final _taskTitleController = TextEditingController();

  void _addTask() {
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _taskTitleController,
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
            ),
            FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white70,
              onPressed: () => _addTask(),
              child: const Icon(
                Icons.add,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
