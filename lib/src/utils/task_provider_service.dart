import 'package:snazzy_todo_list/src/models/task.dart';

class TaskProviderService {
  Future<List<Task>> loadTasks() async {
    DateTime rn = DateTime.now();
    return [
      Task(
        id: -1,
        title: "Task 1",
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
