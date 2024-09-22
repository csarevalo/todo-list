import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/task_provider_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskProviderService _taskProviderService = TaskProviderService();

  late int _internalIdCounter; // Task id counter
  int _getNewId() {
    _internalIdCounter += 1;
    return _internalIdCounter;
  }

  late List<Task> _todoList = [];

  List<Task> get todoList => _todoList; //not immutable

  Future<void> init() async {
    _todoList = await _taskProviderService.loadTasks();
    _todoList.sort((a, b) => a.id.compareTo(b.id)); // Sort tasks by id (asc)
    _internalIdCounter = _todoList.last.id; // Init task id counter
    notifyListeners();
  }

  void toggleDone(int taskId) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    assert(index != -1, "Task not found."); //task not found
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
    Priority priority = Priority.none,
    DateTime? dateModified,
    DateTime? dateDue,
    bool? hasDueByTime,
    DateTime? dateDone,
  }) {
    DateTime rn = DateTime.now();
    return Task(
      id: _getNewId(),
      title: title,
      priority: priority,
      isDone: isDone,
      dateCreated: rn,
      dateModified: rn,
      dateDue: dateDue,
      hasDueByTime: hasDueByTime,
      dateDone: dateDone,
    );
  }

  void updateTask(
    int taskId, {
    required String newTitle,
    required Priority newPriority,
    required DateTime? newDateDue,
    required bool? hasDueByTime,
  }) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    assert(index != -1, "Task not found."); //task not found
    assert(newTitle.isNotEmpty, "Task title cannot be empty"); //missing title
    final todo = _todoList[index];
    if (todo.title != newTitle ||
        todo.priority != newPriority ||
        todo.dateDue != newDateDue ||
        todo.hasDueByTime != hasDueByTime) {
      _todoList[index].title = newTitle;
      _todoList[index].priority = newPriority;
      _todoList[index].dateDue = newDateDue;
      _todoList[index].hasDueByTime = hasDueByTime;
      _todoList[index].dateModified = DateTime.now();
      notifyListeners();
    }
  }

  void deleteTask(int taskId) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    assert(index != -1, "Task not found."); //task not found
    _todoList.removeAt(index);
    notifyListeners();
  }

  void changePriority(int taskId, Priority newPriority) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    assert(index != -1, "Task not found."); //task not found
    if (_todoList[index].priority.value != newPriority.value) {
      _todoList[index].priority = newPriority;
      notifyListeners();
    }
  }
}
