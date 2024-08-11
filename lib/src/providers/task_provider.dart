import 'package:flutter/material.dart';
import 'package:todo_list/src/utils/task_provider_service.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  TaskProvider(this._taskProviderService);
  final TaskProviderService _taskProviderService;

  int _internalIdCounter = -1; // id counter starts at 0
  int _getNewId() {
    _internalIdCounter += 1;
    return _internalIdCounter;
  }

  late List<Task> _todoList = [];

  List<Task> get todoList => _todoList;

  Future<void> init() async {
    _todoList = await _taskProviderService.loadTasks();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

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
    DateTime rn = DateTime.now();
    return Task(
      id: _getNewId(),
      title: title,
      isDone: isDone,
      priority: priority,
      dateCreated: rn,
      dateModified: rn,
      dateDue: dateDue,
      dateDone: dateDone,
    );
  }

  void updateTask(
    int taskId, {
    required String newTitle,
    required int newPriority,
    required DateTime? newDateDue,
  }) {
    final index = _todoList.indexWhere((task) => task.id == taskId);
    if (index == -1) return; // exit if index is Not Found
    if (newTitle.isEmpty) newTitle = _todoList[index].title;
    _todoList[index].title = newTitle;
    _todoList[index].priority = newPriority;
    _todoList[index].dateDue = newDateDue;
    _todoList[index].dateModified = DateTime.now();
    notifyListeners();
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
