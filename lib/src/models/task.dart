class Task {
  final int id;
  String title;
  bool isDone;
  int priority;
  DateTime dateCreated;
  DateTime? dateModified;
  DateTime? dateDue;
  DateTime? dateDone;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.priority,
    required this.dateCreated,
    this.dateModified,
    this.dateDue,
    this.dateDone,
  });
}
