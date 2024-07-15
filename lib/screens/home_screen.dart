import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/dialogs/change_priority_dialog.dart';
import '../widgets/task_tile.dart';
import '../widgets/dialogs/add_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            onPriorityChanged: () => displayChangePriorityDialog(context),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white70,
        onPressed: () => displayAddTaskDialog(context),
        // onPressed: () => Navigator.of(context).pushNamed('/add-task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> displayChangePriorityDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => ChangePriorityDialog(),
  );
}

Future<void> displayAddTaskDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AddTaskDialog(),
  );
}
