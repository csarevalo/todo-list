import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/todo_list_screen.dart';
import 'providers/task_provider.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TaskProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoListScreen(),
      ),
    );
  }
}
