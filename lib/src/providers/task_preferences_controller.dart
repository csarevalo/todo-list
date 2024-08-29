import 'package:flutter/material.dart';

import '../models/task_sort_options.dart';

class TaskPreferencesController with ChangeNotifier {
  // Make private variables so they are not updated directly without
  // also persisting the changes with the ***Service.
  late TaskSortOptions _taskSortOptions;

  // Allow Widgets to read the user's preferred task preferences:
  TaskSortOptions get taskSortOptions => _taskSortOptions;

  /// Load the user's preferences from the ***Service. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadPreferences() async {
    _taskSortOptions = await getTaskSortOptions();
    notifyListeners();
  }

  /// Update and persist the Task View Options based on the user's selection.
  Future<void> updateTaskSortOptions({
    String? newSort1stBy,
    String? newSort2ndBy,
    String? newGroupBy,
    bool? newDesc1,
    bool? newDesc2,
  }) async {
    newGroupBy ??= _taskSortOptions.groupBy;
    newSort1stBy ??= _taskSortOptions.sort1stBy;
    newSort2ndBy ??= _taskSortOptions.sort2ndBy;
    newDesc1 ??= _taskSortOptions.desc1;
    newDesc2 ??= _taskSortOptions.desc2;
    // Do not perform any work if new and old Task Settings are identical
    if (newGroupBy == _taskSortOptions.groupBy &&
        newSort1stBy == _taskSortOptions.sort1stBy &&
        newSort2ndBy == _taskSortOptions.sort2ndBy &&
        newDesc1 == _taskSortOptions.desc1 &&
        newDesc2 == _taskSortOptions.desc2) {
      return;
    }
    // Otherwise, store the new Task Settings in memory
    _taskSortOptions = TaskSortOptions(
      groupBy: newGroupBy,
      sort1stBy: newSort1stBy,
      desc1: newDesc1,
      sort2ndBy: newSort2ndBy,
      desc2: newDesc2,
    );

    // Important! Inform listeners a change has occurred.
    notifyListeners();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await persistTaskSortOptions(taskSortOptions);
  }

  //-----------
  // Service
  //-----------

  /// Loads the User's preferred TaskSettings from local or remote storage.
  Future<TaskSortOptions> getTaskSortOptions() async {
    return TaskSortOptions(
      groupBy: "Completed",
      sort1stBy: "Priority",
      desc1: true,
      sort2ndBy: "None",
      desc2: true,
    );
  }

  /// Persists the user's preferred Task Sort Options to local or remote storage.
  Future<void> persistTaskSortOptions(TaskSortOptions taskSortOptions) async {
    // Todo: in the future
  }
}
