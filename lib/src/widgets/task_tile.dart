import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/task.dart';
import 'dialogs/change_priority_dialog.dart';
import 'dialogs/small_task_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?)? onCheckboxChanged;
  final void Function(BuildContext)? onDelete;

  const TaskTile({
    super.key,
    required this.task,
    this.onCheckboxChanged,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    // final textTheme = Theme.of(context).textTheme;

    /// Set the tile colors
    Color tileColor = themeColors.primary;
    Color onTileColor = themeColors.primaryContainer;

    _TaskTile taskTile = _TaskTile(
      key: super.key,
      title: task.title,
      checkboxState: task.isDone,
      priority: task.priority,
      dateDue: task.dateDue,
      onCheckboxChanged: onCheckboxChanged,
      onDelete: onDelete,
      onPriorityChange: () => showChangePriorityDialog(
        context: context,
        taskId: task.id,
        currentPriority: task.priority,
      ),
      onTap: () => showSmallTaskDialog(
        context: context,
        task: task,
      ),
      onLongPress: () => showSmallTaskDialog(
        context: context,
        task: task,
      ),
      tileColor: tileColor,
      onTileColor: onTileColor,
    );
    return taskTile;
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final bool checkboxState;
  final int priority;
  final Function(bool?)? onCheckboxChanged;
  final void Function(BuildContext)? onDelete;
  final void Function()? onPriorityChange;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Color tileColor;
  final Color onTileColor;
  final DateTime? dateDue;

  const _TaskTile({
    super.key,
    required this.title,
    this.dateDue,
    required this.checkboxState,
    required this.priority,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onPriorityChange,
    this.onTap,
    this.onLongPress,
    required this.tileColor,
    required this.onTileColor,
  });

  @override
  Widget build(BuildContext context) {
    // final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final iconColor = priority == 0
        ? Colors.grey.shade500
        : priority == 1
            ? Colors.blue
            : priority == 2
                ? Colors.yellow.shade700
                : Colors.red.shade600;
    return RepaintBoundary(
      child: Slidable(
        groupTag: '0', // only keep 1 open
        endActionPane: ActionPane(
          extentRatio: 0.25,
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(15),
              backgroundColor: Colors.red,
              foregroundColor: onTileColor,
            )
          ],
        ),
        child: Material(
          child: ListTile(
            onTap: onTap,
            onLongPress: onLongPress,
            dense: true,
            tileColor: checkboxState ? tileColor.withOpacity(0.9) : tileColor,
            textColor:
                checkboxState ? onTileColor.withOpacity(0.4) : onTileColor,
            iconColor: checkboxState ? iconColor.withOpacity(0.7) : iconColor,
            leading: Checkbox(
              value: checkboxState,
              onChanged: onCheckboxChanged,
              checkColor: tileColor.withOpacity(0.4),
              activeColor: onTileColor.withOpacity(0.4),
              side: BorderSide(color: onTileColor),
            ),
            title: Text(
              title,
              style: textTheme.bodyLarge!.copyWith(
                fontSize: 18,
                color:
                    checkboxState ? onTileColor.withOpacity(0.4) : onTileColor,
                decoration: checkboxState
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor:
                    checkboxState ? onTileColor.withOpacity(0.4) : onTileColor,
                decorationThickness: 1.5,
              ),
              softWrap: false,
            ),
            subtitle: dateDue == null
                ? null
                : Text(
                    DateFormat.yMMMd().format(dateDue!).toString(),
                  ),
            trailing: IconButton(
              onPressed: onPriorityChange,
              icon: priority == 0
                  ? const Icon(Icons.flag_outlined)
                  : const Icon(Icons.flag),
              alignment: Alignment.topRight,
            ),
          ),
        ),
      ),
    );
  }
}
