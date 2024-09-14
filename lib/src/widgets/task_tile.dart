import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../models/task.dart';
import 'dialogs/change_priority_dialog.dart';
import 'dialogs/small_task_dialog.dart';

class TaskTile extends StatelessWidget {
  final ImmutableTask task;
  final Function(bool?)? onCheckboxChanged;
  final void Function(BuildContext)? onDelete;
  final void Function()? onPriorityChange;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Color? tileColor;
  final Color? onTileColor;

  const TaskTile({
    super.key,
    required this.task,
    this.onCheckboxChanged,
    this.onDelete,
    this.onPriorityChange,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.onTileColor,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("Built TaskTile: ${task.title}");

    return _CloseSlidableOnTap(
      task: task,
      onCheckboxChanged: onCheckboxChanged,
      onDelete: onDelete,
      onPriorityChange: onPriorityChange,
      onTap: onTap,
      onLongPress: onLongPress,
      tileColor: tileColor,
      onTileColor: onTileColor,
    );
  }
}

class _CloseSlidableOnTap extends StatefulWidget {
  final ImmutableTask task;
  final Function(bool?)? onCheckboxChanged;
  final void Function(BuildContext)? onDelete;
  final void Function()? onPriorityChange;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Color? tileColor;
  final Color? onTileColor;

  const _CloseSlidableOnTap({
    required this.task,
    this.onCheckboxChanged,
    this.onDelete,
    this.onPriorityChange,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.onTileColor,
  });

  @override
  State<_CloseSlidableOnTap> createState() => _CloseSlidableOnTapState();
}

class _CloseSlidableOnTapState extends State<_CloseSlidableOnTap>
    with TickerProviderStateMixin {
  late final SlidableController _slidableController;
  late bool _enTapOutside;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this);
    _enTapOutside = false;
  }

  @override
  void dispose() {
    if (mounted) _slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ImmutableTask task = widget.task;
    final _TaskTile taskTile = _TaskTile(
      // key: super.key,
      controller: _slidableController,
      task: task,
      onCheckboxChanged: widget.onCheckboxChanged,
      onDelete: widget.onDelete,
      onPriorityChange: widget.onPriorityChange,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      tileColor: widget.tileColor,
      onTileColor: widget.onTileColor,
    );
    return TapRegion(
      onTapInside: (_) {
        if (_enTapOutside) return;
        _enTapOutside = true;
        // debugPrint("Hit inside TaskTile ${task.title}");
      },
      onTapOutside: (_) {
        if (!mounted || !_enTapOutside) return;
        if (!_slidableController.closing) {
          _slidableController.close();
          _enTapOutside = false;
          // debugPrint("Hit outside TaskTile ${task.title}");
        }
      },
      child: taskTile,
    );
  }
}

class _TaskTile extends StatelessWidget {
  final SlidableController? controller;
  final ImmutableTask task;
  final Function(bool?)? onCheckboxChanged;
  final void Function(BuildContext)? onDelete;
  final void Function()? onPriorityChange;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Color? tileColor;
  final Color? onTileColor;

  const _TaskTile({
    // super.key,
    this.controller,
    required this.task,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onPriorityChange,
    this.onTap,
    this.onLongPress,
    this.tileColor,
    this.onTileColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    /// Set shorter variables
    String title = task.title;
    bool completed = task.isDone;
    Priority priority = task.priority;
    DateTime? dateDue = task.dateDue;

    /// Set the tile colors
    final Color tileColor = this.tileColor ?? themeColors.primary;
    final Color onTileColor = this.onTileColor ?? themeColors.primaryContainer;

    return RepaintBoundary(
      child: Slidable(
        groupTag: '0', // SlideableAutoClose closes by group tag
        key: UniqueKey(),
        controller: controller,
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
        child: ListTile(
          onTap: onTap ??
              () {
                showSmallTaskDialog(
                  context: context,
                  task: task,
                );
              },
          onLongPress: onLongPress,
          dense: true,
          // shape: const Border(),
          tileColor: completed ? tileColor.withOpacity(0.9) : tileColor,
          textColor: completed ? onTileColor.withOpacity(0.4) : onTileColor,
          iconColor:
              completed ? priority.color.withOpacity(0.7) : priority.color,
          // iconColor: completed ? iconColor.withOpacity(0.7) : iconColor, //TODO: remove
          leading: Checkbox(
            value: completed,
            onChanged: onCheckboxChanged,
            checkColor: tileColor.withOpacity(0.4),
            activeColor: onTileColor.withOpacity(0.4),
            side: BorderSide(color: onTileColor),
          ),
          title: Text(
            title,
            style: textTheme.bodyLarge!.copyWith(
              fontSize: 18,
              color: completed ? onTileColor.withOpacity(0.4) : onTileColor,
              decoration:
                  completed ? TextDecoration.lineThrough : TextDecoration.none,
              decorationColor:
                  completed ? onTileColor.withOpacity(0.4) : onTileColor,
              decorationThickness: 1.5,
            ),
            softWrap: false,
          ),
          subtitle: dateDue == null
              ? null
              : Text(
                  DateFormat.yMMMd().format(dateDue).toString(),
                ),
          trailing: IconButton(
            onPressed: task.isDone
                ? null
                : onPriorityChange ??
                    () {
                      showChangePriorityDialog(
                        context: context,
                        taskId: task.id,
                        currentPriority: priority,
                      );
                    },
            disabledColor: priority.color.withOpacity(0.7),
            icon: priority == Priority.none //3
                ? const Icon(Icons.flag_outlined)
                : const Icon(Icons.flag),
            alignment: Alignment.topRight,
          ),
        ),
      ),
    );
  }
}
