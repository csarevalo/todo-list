import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _todoList = [
    Task(
      id: DateTime.now().toString(),
      title: "Task 1",
      isDone: false,
      priority: 1,
    ),
    Task(
      id: DateTime.now().toString(),
      title: "Task 2",
      isDone: true,
      priority: 2,
    ),
    Task(
      id: DateTime.now().toString(),
      title: "Task 3",
      isDone: false,
      priority: 3,
    ),
  ];

  List get todoList => _todoList;

  void checkboxChanged(String taskId) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    _todoList[index].isDone = !_todoList[index].isDone;
    notifyListeners();
  }

  void addTask(Task newTask) {
    _todoList.add(newTask);
    notifyListeners();
  }

  Task createTask(
      {required String title, bool isDone = false, int priority = 1}) {
    return Task(
      id: DateTime.now().toString(),
      title: title,
      isDone: isDone,
      priority: priority,
    );
  }

  void deleteTask(String taskId) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    _todoList.removeAt(index);
    notifyListeners();
  }

  void changePriority(String taskId, int newPriority) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    _todoList[index].priority = newPriority;
    notifyListeners();
  }
}
