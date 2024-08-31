import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final bool checkboxState;
  final int priority;
  final Function(bool?)? onCheckboxChanged;
  final void Function(BuildContext)? onDelete;
  final void Function()? onPriorityChange;
  final void Function()? onTapTaskTile;
  final void Function()? onLongPress;
  final void Function()? onDoubleTap;
  final Color tileColor;
  final Color onTileColor;
  final DateTime? dateDue;

  const TaskTile({
    super.key,
    required this.title,
    required this.checkboxState,
    required this.priority,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onPriorityChange,
    this.onTapTaskTile,
    this.onLongPress,
    this.onDoubleTap,
    required this.tileColor,
    required this.onTileColor,
    this.dateDue,
  });

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      top: false,
      bottom: false,
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
        //TODO: Use ListTile here!!!
        child: InkWell(
          onTap: onTapTaskTile,
          onLongPress: onLongPress,
          onDoubleTap: onDoubleTap,
          child: Container(
            decoration: BoxDecoration(
              color: checkboxState ? tileColor.withOpacity(0.7) : tileColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              children: [
                Checkbox(
                  value: checkboxState,
                  onChanged: onCheckboxChanged,
                  checkColor: tileColor.withOpacity(0.4),
                  activeColor: onTileColor.withOpacity(0.4),
                  side: BorderSide(color: onTileColor),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyLarge!.copyWith(
                          color: checkboxState
                              ? onTileColor.withOpacity(0.4)
                              : onTileColor,
                          fontSize: 18,
                          decoration: checkboxState
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: checkboxState
                              ? onTileColor.withOpacity(0.4)
                              : onTileColor,
                          decorationThickness: 1.5,
                        ),
                        softWrap: false,
                      ),
                      if (dateDue != null) ...[
                        Text(
                          DateFormat.yMMMd().format(dateDue!).toString(),
                          style: textTheme.bodySmall!.copyWith(
                            color: themeColors.onPrimary,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onPriorityChange,
                  icon: priority == 0
                      ? const Icon(Icons.flag_outlined)
                      : const Icon(Icons.flag),
                  alignment: Alignment.topRight,
                  color: priority == 0
                      ? Colors.grey.shade500
                      : priority == 1
                          ? Colors.blue
                          : priority == 2
                              ? Colors.yellow.shade700
                              : Colors.red.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
