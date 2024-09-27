import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';
import '../screens/settings_view.dart';
import '../utils/filter_tasks.dart';
import '../widgets/dialogs/sort_tasks_dialog.dart';
import '../widgets/task_sections_builder.dart';
import '../widgets/dialogs/small_task_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: themeColors.primaryContainer,
      appBar: const MyAppBar(),
      drawer: const MyDrawer(),
      body: const TaskSectionsBuilder(),
      floatingActionButton: RepaintBoundary(
        child: FloatingActionButton(
          backgroundColor: themeColors.surfaceTint,
          foregroundColor: themeColors.surface,
          onPressed: () => showSmallTaskDialog(context: context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: themeColors.primaryContainer,
      child: const SampleDrawerItems(),
    );
  }
}

class SampleDrawerItems extends StatelessWidget {
  const SampleDrawerItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final taskProvider = context.read<TaskProvider>();
    return Column(
      children: [
        DrawerHeader(
          child: Card(
            child: Column(
              children: [
                const Icon(Icons.account_circle_rounded),
                Text(
                  "FirstName LastName",
                  style: textTheme.titleMedium,
                ),
                Text(
                  "firstName.lastName@email.com",
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: const Icon(Icons.account_circle_rounded),
            title: Text(
              "FirstName LastName",
              style: textTheme.titleMedium,
            ),
            trailing: IconButton(
              onPressed: () {
                Navigator.restorablePushNamed(
                  context,
                  SettingsView.routeName,
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            //TODO: use a builder instead
            //FIXME: add a fixed heigh based on media query or whatever
            shrinkWrap: true,
            children: [
              ListTile(
                leading: const Icon(Icons.search_rounded),
                title: const Text("Search"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.all_inbox),
                title: const Text("All"),
                onTap: () {
                  taskProvider.updateActiveTaskTest((Task t) => true);
                  taskProvider.updateActiveTasks(taskProvider.todoList);
                },
              ),
              ListTile(
                leading: const Icon(Icons.inbox_rounded),
                title: const Text("Inbox"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.today_rounded),
                title: const Text("Today"),
                onTap: () {
                  taskProvider.updateActiveTaskTest((Task task) {
                    if (task.dateDue == null) return false;
                    final DateTime today = DateUtils.dateOnly(DateTime.now());
                    final DateTime due = DateUtils.dateOnly(task.dateDue!);
                    return due.difference(today).inDays <=
                        0; //due on or before today
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.signpost_rounded),
                title: const Text("Tomorrow"),
                onTap: () {
                  taskProvider.updateActiveTaskTest((Task task) {
                    if (task.dateDue == null) return false;
                    final DateTime today = DateUtils.dateOnly(DateTime.now());
                    final DateTime due = DateUtils.dateOnly(task.dateDue!);
                    return due.difference(today).inDays == 1; //due tomorrow
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_month_rounded),
                title: const Text("Next 7 Days"),
                onTap: () {
                  taskProvider.updateActiveTaskTest((Task task) {
                    if (task.dateDue == null) return false;
                    final DateTime today = DateUtils.dateOnly(DateTime.now());
                    final DateTime due = DateUtils.dateOnly(task.dateDue!);
                    return due.difference(today).inDays <=
                        7; //on or b/f next 7 days
                  });
                },
              ),
              ExpansionTile(
                leading: const Icon(Icons.style_rounded),
                shape: const Border(),
                title: const Text("Tags"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text("Appts"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text("Family"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.savings_rounded),
                    title: const Text("Finances"),
                    onTap: () {},
                  ),
                ],
              ),
              ListTile(
                leading: const Icon(Icons.workspace_premium_rounded),
                title: const Text("Passion"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.business_center_rounded),
                title: const Text("Career"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.home_work_rounded),
                title: const Text("Personal"),
                onTap: () {},
              ),
              ExpansionTile(
                leading: const Icon(Icons.playlist_remove_rounded),
                shape: const Border(),
                title: const Text("Archived Lists"),
                children: [
                  ListTile(
                    leading: const Icon(Icons.verified_rounded),
                    title: const Text("Test"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.nearby_error_rounded),
                    title: const Text("Not Important Plans"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.running_with_errors_rounded),
                    title: const Text("Not Urgent Reminders"),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        Row(
          // direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {},
              label: const Text("Add"),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.settings),
              // icon: const Icon(Icons.rule_rounded),
            ),
          ],
        ),
      ],
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AppBar(
      backgroundColor: themeColors.primaryContainer,
      foregroundColor: themeColors.primary,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        "To-Do List",
        style: textTheme.headlineSmall!.copyWith(
          color: themeColors.primary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            //focus timer
          },
          icon: const Icon(Icons.av_timer_rounded),
        ),
        PopupMenuButton(
          offset: const Offset(0, 45),
          itemBuilder: (context) => [
            PopupMenuItem<String>(
              value: "Sort",
              child: const Text("Sort"),
              onTap: () => showSortTasksDialog(context: context),
            ),
            //TODO: add more options
            //show completed
            //show details
            //show select.. tasks for bulk edits/deletes
          ],
        ),
        const SizedBox(width: 16)
      ],
    );
  }
}
