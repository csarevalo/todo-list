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

  void checkboxChanged(int index) {
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

  void deleteTask(int index) {
    _todoList.removeAt(index);
    notifyListeners();
  }

  // void priorityChanged(int index){
  //     _todoList[index][2] =
  // notifyListeners();
  // }
}
