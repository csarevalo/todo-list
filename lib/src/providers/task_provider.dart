import 'package:collection/collection.dart';
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
  late List<Task> _activeTasks = [];

  /// Used to determine active tasks from task todo list
  late bool Function(Task task) activeTaskTest;

  /// Task Default List
  TaskList defaultList = TaskList(
    id: DateTime.timestamp(),
    icon: const Icon(Icons.inbox_rounded),
    name: "Inbox",
  );

  /// Get a mutable copy of app todo list
  List<Task> get todoList => List.from(_todoList);

  /// Get mutable active tasks list
  List<Task> get activeTasks => _activeTasks;

  Future<void> init() async {
    _todoList = await _taskProviderService.loadTasks();
    _todoList.sort((a, b) => a.id.compareTo(b.id)); // Sort tasks by id (asc)
    _internalIdCounter = _todoList.last.id; // Init task id counter

    //NEW STUFF
    activeTaskTest = (Task t) => true; //FIXME: retrieve from somewhere
    _activeTasks = List.from(_todoList); //FIXME: need filter here
    _activeTasks.retainWhere(activeTaskTest);
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
    addToActiveTasks(newTask); //First try adding to active tasks
    _todoList.add(newTask);
    notifyListeners();
  }

  void addToActiveTasks(Task newTask) {
    if (activeTaskTest(newTask)) _activeTasks.add(newTask);
  }

  void updateActiveTaskTest(bool Function(Task t) f) {
    activeTaskTest = f; //no need to notify listeners
    List<Task> newActiveTasks = List.from(_todoList);
    newActiveTasks.retainWhere(f);
    updateActiveTasks(newActiveTasks);
  }

  void updateActiveTasks(List<Task> newActiveTasks) {
    if (!const DeepCollectionEquality().equals(_activeTasks, newActiveTasks)) {
      _activeTasks = newActiveTasks;
      debugPrint("Updated active tasks\n\n");
      notifyListeners();
    }
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
      list: defaultList,
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
