import 'package:flutter/material.dart';

class Task {
  final int id;
  String title;
  bool isDone;
  Priority priority;
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
  high(value: 0, str: "High", color: Colors.red),

  /// Medium Priority
  medium(value: 1, str: "Medium", color: Colors.yellow),

  /// Low Priority
  low(value: 2, str: "Low", color: Colors.blue),

  /// No Priority
  none(value: 3, str: "None", color: Colors.grey);

  const Priority({
    required this.value,
    required this.str,
    required this.color,
  });

  final int value;
  final String str;
  final MaterialColor color;

  @override
  int compareTo(Priority other) => value - other.value;
}
