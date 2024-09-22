import 'package:flutter/material.dart';

/// Task List Model
class TaskList {
  final String id;
  Icon icon;
  String listName;
  TaskList({
    required this.id,
    required this.icon,
    required this.listName,
  });
}