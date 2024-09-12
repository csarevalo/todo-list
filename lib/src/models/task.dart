class Task {
  final int id;
  String title;
  bool isDone;
  // Priority priority;
  int priority;
  DateTime dateCreated;
  DateTime dateModified;
  DateTime? dateDue;
  bool? hasDueByTime;
  DateTime? dateDone;

  Task({
    required this.id,
    required this.title,
    required this.isDone,
    required this.priority,
    required this.dateCreated,
    required this.dateModified,
    this.dateDue,
    this.hasDueByTime,
    this.dateDone,
  });
}

enum Priority implements Comparable<Priority> {
  /// High Priority
  high(value: 0, str: "High"),

  /// Medium Priority
  medium(value: 1, str: "Medium"),

  /// Low Priority
  low(value: 2, str: "Low"),

  /// No Priority
  none(value: 3, str: "No");

  const Priority({
    required this.value,
    required this.str,
  });

  final int value;
  final String str;

  @override
  int compareTo(Priority other) => value - other.value;
}
