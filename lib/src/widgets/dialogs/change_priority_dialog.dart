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
    //TODO: CHANGE priority to enum and use the name of enum as capitalize and
    // then add "Priority" where necessary
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
        children: List<Widget>.generate(4, (index) {
          int i = index; //3-index
          return priorityButton(
            priority: i,
            active: currentPriority == i,
            onPressed: () {
              _changePriority(context, newPriority: i);
            },
          );
        }),
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
      "High Priority",
      "Medium Priority",
      "Low Priority",
      "No Priority",
    ];
    List<Color> priorityColors = [
      Colors.red.shade600,
      Colors.yellow.shade700,
      Colors.blue,
      Colors.grey.shade500,
    ];
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        priority == 3 ? Icons.flag_outlined : Icons.flag,
        color: priorityColors[priority],
      ),
      label: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                priorityLevels[priority], //FIXME: lousy reference
                style: TextStyle(
                  fontSize: 16,
                  color: priorityColors[priority], //FIXME: lousy reference
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
