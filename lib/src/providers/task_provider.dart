import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  int _internalIdCounter = 0;
  int _getNewId() {
    _internalIdCounter += 1;
    return _internalIdCounter;
  }

  final List<Task> _todoList = [
    //should leave empty list here
    //get todo list from somewhere else
    //avoid using negative integers
    Task(
      id: -1,
      title: "Task 1",
      isDone: false,
      priority: 1,
      dateCreated: DateTime.now(),
    ),
    Task(
      id: -2,
      title: "Task 2",
      isDone: true,
      priority: 2,
      dateCreated: DateTime.now(),
    ),
    Task(
      id: -3,
      title: "Task 3",
      isDone: false,
      priority: 3,
      dateCreated: DateTime.now(),
    ),
  ];

  List<Task> get todoList => _todoList;

  void toggleDone(int taskId) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    _todoList[index].isDone = !_todoList[index].isDone;
    if (_todoList[index].isDone) {
      _todoList[index].dateDone = DateTime.now();
    }
    notifyListeners();
  }

  void addTask(Task newTask) {
    _todoList.add(newTask);
    notifyListeners();
  }

  Task createTask({
    required String title,
    bool isDone = false,
    int priority = 1,
    DateTime? dateModified,
    DateTime? dateDue,
    DateTime? dateDone,
  }) {
    return Task(
      id: _getNewId(),
      title: title,
      isDone: isDone,
      priority: priority,
      dateCreated: DateTime.now(),
      dateModified: dateModified,
      dateDue: dateDue,
      dateDone: dateDone,
    );
  }

  void deleteTask(int taskId) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    _todoList.removeAt(index);
    notifyListeners();
  }

  void changePriority(int taskId, int newPriority) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    _todoList[index].priority = newPriority;
    notifyListeners();
  }
}
