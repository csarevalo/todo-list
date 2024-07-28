import 'package:flutter/material.dart';

import '../screens/settings_view.dart';
import '../widgets/task_sections_builder.dart';
import '../widgets/dialogs/add_task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeColors.primaryContainer,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          "To-Do List",
          style: textTheme.headlineSmall!.copyWith(
            color: themeColors.primary,
          ),
        ),
        backgroundColor: themeColors.primaryContainer,
        foregroundColor: themeColors.primary,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(
                context,
                SettingsView.routeName,
              );
            },
            icon: const Icon(Icons.settings),
          ),
          PopupMenuButton(
            offset: const Offset(0, 45),
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: "Sort",
                child: Text("Sort By"),
              ),
              const PopupMenuItem<String>(
                value: "Filter",
                child: Text("Filter By"),
              ),
            ],
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: const TaskSectionsBuilder(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColors.surfaceTint,
        foregroundColor: themeColors.surface,
        onPressed: () => displayAddTaskDialog(context),
        // onPressed: () => Navigator.of(context).pushNamed('/add-task'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> displayAddTaskDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AddTaskDialog(),
  );
}
