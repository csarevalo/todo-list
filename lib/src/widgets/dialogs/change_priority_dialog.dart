import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/task_provider.dart';

Future<void> showChangePriorityDialog({
  required BuildContext context,
  required int taskId,
  required int currentPriority,
  bool barrierDismissible = true,
  Color? barrierColor,
  String? barrierLabel,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  TransitionBuilder? builder,
}) async {
  Widget dialog = ChangePriorityDialog(
    taskId: taskId,
    currentPriority: currentPriority,
  );
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
    anchorPoint: anchorPoint,
  );
}

class ChangePriorityDialog extends StatelessWidget {
  final int taskId;
  final int currentPriority;
  const ChangePriorityDialog({
    super.key,
    required this.taskId,
    required this.currentPriority,
  });

  void _changePriority(BuildContext context, {required int newPriority}) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.changePriority(taskId, newPriority);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: themeColors.primaryContainer,
      alignment: Alignment.center,
      title: const Text("Priority"),
      contentPadding: const EdgeInsets.only(top: 10),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          priorityButton(
            priority: 3,
            active: currentPriority == 3,
            onPressed: () {
              _changePriority(context, newPriority: 3);
            },
          ),
          priorityButton(
            priority: 2,
            active: currentPriority == 2,
            onPressed: () {
              _changePriority(context, newPriority: 2);
            },
          ),
          priorityButton(
            priority: 1,
            active: currentPriority == 1,
            onPressed: () {
              _changePriority(context, newPriority: 1);
            },
          ),
          priorityButton(
            priority: 0,
            active: currentPriority == 0,
            onPressed: () {
              _changePriority(context, newPriority: 0);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Cancel",
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!
                      .copyWith(color: themeColors.primary),
                ),
              ],
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.symmetric(vertical: 0),
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  TextButton priorityButton({
    required int priority,
    void Function()? onPressed,
    bool active = false,
  }) {
    List<String> priorityLevels = <String>[
      "No Priority",
      "Low Priority",
      "Medium Priority",
      "High Priority",
    ];
    List<Color> priorityColors = [
      Colors.grey.shade500,
      Colors.blue,
      Colors.yellow.shade700,
      Colors.red.shade600,
    ];
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        priority == 0 ? Icons.flag_outlined : Icons.flag,
        color: priorityColors[priority],
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                priorityLevels[priority],
                style: TextStyle(
                  fontSize: 16,
                  color: priorityColors[priority],
                ),
              ),
            ),
            active ? const Icon(Icons.check) : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
