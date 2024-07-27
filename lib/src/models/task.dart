class Task {
  final int id;
  String title;
  bool isDone;
  int priority;
  DateTime createdDate;
  DateTime? dueDate;
  DateTime? doneDate;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.priority,
    required this.createdDate,
    this.dueDate,
    this.doneDate,
  });
}
