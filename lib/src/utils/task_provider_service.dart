import 'package:flutter/material.dart';
import 'package:snazzy_todo_list/src/models/task.dart';

class TaskProviderService {
  /// Task Default List
  final TaskList _defaultList = TaskList(
    id: DateTime.timestamp(),
    icon: const Icon(Icons.inbox_rounded),
    name: "Inbox",
  );

  /// Load tasks from external or local database
  Future<List<Task>> loadTasks() async {
    DateTime rn = DateTime.now();
    return [
      Task(
        id: -1,
        title: "Task 1",
        list: _defaultList,
        isDone: false,
        priority: Priority.high,
        dateCreated: rn,
        dateDue: rn,
        hasDueByTime: true,
        dateModified: rn,
      ),
      Task(
        id: -2,
        title: "Task 2",
        list: _defaultList,
        isDone: false,
        priority: Priority.medium,
        dateCreated: rn,
        dateDue: rn,
        hasDueByTime: false,
        dateModified: rn,
      ),
      Task(
        id: -3,
        title: "Task 3",
        list: _defaultList,
        isDone: false,
        priority: Priority.low,
        dateCreated: rn,
        dateDue: rn,
        hasDueByTime: false,
        dateModified: rn,
      ),
      Task(
        id: -4,
        title: "Task 4",
        list: _defaultList,
        isDone: false,
        priority: Priority.none,
        dateCreated: rn,
        dateDue: rn,
        hasDueByTime: false,
        dateModified: rn,
      ),
      Task(
        id: -5,
        title: "Task 5",
        list: _defaultList,
        isDone: false,
        priority: Priority.high,
        dateCreated: rn,
        dateDue: rn,
        hasDueByTime: true,
        dateModified: rn,
      ),
    ];
  }

  /// Persist all changes made to Todo List
  Future<void> saveTodoList(int taskId, int newPriority) async {}
}
