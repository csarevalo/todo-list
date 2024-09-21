import '../models/task.dart';
import '../models/task_sort_options.dart';

class SortAndFilterTasks {
  final List<Task> tasks;
  final TaskSortOptions taskSortOptions;
  SortAndFilterTasks({
    required this.tasks,
    required this.taskSortOptions,
  });

  ///Filter tasks by completion
  List<Task> byCompletion({
    required final bool isCompleted,
    final bool sort = true, //sort by default
  }) {
    List<Task> filteredTasks = List.from(tasks);
    filteredTasks.retainWhere((task) => task.isDone == isCompleted);
    if (sort) {
      filteredTasks.sort(isCompleted
          ? (a, b) => b.dateDone!.compareTo(a.dateDone!)
          : _sortTasksBy(
              sort1stBy: taskSortOptions.sort1stBy,
              desc1: taskSortOptions.desc1,
              sort2ndBy: taskSortOptions.sort2ndBy,
              desc2: taskSortOptions.desc2,
            ));
    }
    return filteredTasks;
  }

  /// Filter tasks by priority
  List<Task> byPriority({
    required final String strPriority,
    final bool sort = true, //sort by default
    final bool isCompleted = false, //filter uncompleted tasks by default
  }) {
    List<Task> filteredTasks = List.from(tasks);
    final Priority priority = Priority.values.firstWhere(
      (p) => p.str == strPriority,
      orElse: () => Priority.none,
    );
    filteredTasks.retainWhere(
      (task) => task.priority == priority && task.isDone == isCompleted,
    );
    if (sort) {
      filteredTasks.sort(_sortTasksBy(
        sort1stBy: taskSortOptions.sort1stBy,
        desc1: taskSortOptions.desc1,
        sort2ndBy: taskSortOptions.sort2ndBy,
        desc2: taskSortOptions.desc2,
      ));
    }
    return filteredTasks;
  }

  /// Filter tasks by date
  ///
  /// datePeriod: 'overdue', 'today', 'tomorrow', 'next', 'later', 'no' ..date
  List<Task> byDate({
    required final TaskDateField dateField,
    required String datePeriod,
    final bool sort = true, //sort by default
    final bool isCompleted = false, //filter uncompleted tasks by default
  }) {
    datePeriod = datePeriod.toLowerCase();

    List<Task> filteredTasks = List.from(tasks);
    filteredTasks.retainWhere(retainTasksByDate(
      dateField: dateField,
      datePeriod: datePeriod,
    ));

    if (sort) {
      filteredTasks.sort(_sortTasksBy(
        sort1stBy: taskSortOptions.sort1stBy,
        desc1: taskSortOptions.desc1,
        sort2ndBy: taskSortOptions.sort2ndBy,
        desc2: taskSortOptions.desc2,
      ));
    }

    return filteredTasks;
  }
}

/// Assign a list of tasks to continue applying filters
/// The assigned tasks will continue to be modified.
class ContinousTaskFilter {
  List<Task> tasks;
  ContinousTaskFilter({required this.tasks});

  /// Filter tasks by completion
  void byCompletion(final bool isCompleted) {
    tasks.retainWhere((task) => task.isDone == isCompleted); //Update tasks
  }

  /// Filter tasks by priority
  void byPriority(final Priority priority) {
    tasks.retainWhere((task) => task.priority == priority); //Update tasks
  }

  /// Filter tasks by date on a specific task datefield
  void byDate({
    required final TaskDateField taskDateField,
    required final DateTime date,
  }) {
    switch (taskDateField) {
      case TaskDateField.due:
        return tasks.retainWhere((Task t) => t.dateDue == dateOnly(date));
      case TaskDateField.modified:
        return tasks.retainWhere((Task t) => t.dateModified == dateOnly(date));
      case TaskDateField.done:
        return tasks.retainWhere((Task t) => t.dateDone == dateOnly(date));
      case TaskDateField.created:
        return tasks.retainWhere((Task t) => t.dateCreated == dateOnly(date));
      default:
    }
  }

  /// Filter tasks by those occuring in a duration, for a specific datefield
  void byDuration({
    required final TaskDateField dateField,
    required final DateTime start,
    required final DateTime end,
  }) {
    tasks.retainWhere((Task t) {
      final DateTime? taskDate = getTaskDate(task: t, dateField: dateField);
      if (taskDate == null) return false;
      final DateTime startDate = dateOnly(start)!;
      final DateTime endDate = dateOnly(end)!;
      assert(
        startDate.isBefore(endDate),
        "Starting date should not be after ending date",
      );
      taskDate.difference(startDate).inDays >= 0;
      if (taskDate.difference(startDate).inDays >= 0 &&
          taskDate.difference(endDate).inDays <= 0) {
        return true;
      }
      return false;
    });
  }
}

typedef RetainTaskWhere = bool Function(Task task);

/// Retain Tasks where
///
/// datePeriod: 'overdue', 'today', 'tomorrow', 'next', 'later', 'no' ..date
RetainTaskWhere retainTasksByDate({
  required final TaskDateField dateField,
  required final String datePeriod,
  final bool isCompleted = false, //filter uncompleted tasks by default
}) {
  // Create dayComp function to check if tasks is within date range
  late final bool Function(int) dayComp;
  switch (datePeriod) {
    case 'overdue':
      dayComp = (dayDiff) => dayDiff < 0;
    case 'today':
      dayComp = (dayDiff) => dayDiff == 0;
    case 'tomorrow':
      dayComp = (dayDiff) => dayDiff == 1;
    case 'next': //'next 7 days' (2-7) days
      dayComp = (dayDiff) => dayDiff >= 2 && dayDiff <= 7;
    case 'later':
      dayComp = (dayDiff) => dayDiff > 7;
    default: //'no date'.. is never called bc dayDiff==null
      dayComp = (_) => false;
  }

  final DateTime? todaysDate = dateOnly(DateTime.now());
  return (Task task) {
    if (task.isDone != isCompleted) return false;
    // Get specific date from task datefield
    final DateTime? taskDate = getTaskDate(task: task, dateField: dateField);
    final int? dayDiff = taskDate?.difference(todaysDate!).inDays;
    if (dayDiff != null) return dayComp(dayDiff);
    if (datePeriod == "no") return true; // show 'no date' tasks
    return false; // don't show irrelevant tasks
  };
}

/// Extract the date from a specific task datetime field
DateTime? getTaskDate({
  required final Task task,
  required final TaskDateField dateField,
}) {
  switch (dateField) {
    case TaskDateField.done:
      return dateOnly(task.dateDone);
    case TaskDateField.modified:
      return dateOnly(task.dateModified);
    case TaskDateField.due:
      return dateOnly(task.dateDue);
    case TaskDateField.created:
      return dateOnly(task.dateCreated);
    default:
      return null;
  }
}

/// Get date only from datetime
DateTime? dateOnly(final DateTime? date) {
  if (date == null) return null;
  return DateTime(date.year, date.month, date.day);
}

/// Used to specify what datefield to consider from tasks
enum TaskDateField {
  /// Refers to Task.dateCreated
  created,

  /// Refers to Task.dateDone
  done,

  /// Refers to Task.dateDue
  due,

  /// Refers to Task.dateModified
  modified
}

typedef _SortTask = int Function(Task a, Task b);

/// Sorts Tasks accordingly
_SortTask _sortTasksBy({
  required final SortBy sort1stBy,
  final SortBy sort2ndBy = SortBy.none,
  final bool desc1 = true, // order of 1st sort by
  final bool desc2 = true, // order of 2nd sort by
}) {
  return (a, b) {
    // Primary comparison by 1st sortBy
    int firstComp = compareBy(sort1stBy, taskA: a, taskB: b, desc: desc1);
    if (firstComp != 0) return firstComp;
    // Secondary comparison by 2nd sortBy
    int secondComp = compareBy(sort2ndBy, taskA: a, taskB: b, desc: desc2);
    return secondComp;
  };
}

/// Used to sort tasks by comparing Task B to Task A
int compareBy(
  final SortBy compBy, {
  required final Task taskA,
  required final Task taskB,
  final bool desc = true,
}) {
  switch (compBy) {
    case SortBy.dateCreated: //"date_created":
      int dateCreatedComp = taskB.dateCreated.compareTo(taskA.dateCreated);
      return desc ? dateCreatedComp : dateCreatedComp * -1;
    case SortBy.dueDate: //"due_date":
      int dueDateComp;
      if (taskB.dateDue == null && taskA.dateDue == null) {
        dueDateComp = 0; // both a & b have no due date
      } else if (taskA.dateDue == null) {
        dueDateComp = 1; // b is after a (task w/date goes 1st)
      } else if (taskB.dateDue == null) {
        dueDateComp = -1; // a is after b (task w/date goes 1st)
      } else {
        dueDateComp = taskB.dateDue!.compareTo(taskA.dateDue!);
      }
      return desc ? dueDateComp : dueDateComp * -1;
    case SortBy.lastModified:
      int lastModComp = taskB.dateModified.compareTo(taskA.dateModified);
      return desc ? lastModComp : lastModComp * -1;
    case SortBy.priority:
      int priorityComp = taskB.priority.compareTo(taskA.priority);
      return desc ? priorityComp * -1 : priorityComp;
    case SortBy.title:
      int titleComp = taskB.title.toLowerCase().compareTo(
            taskA.title.toLowerCase(),
          );
      return desc ? titleComp : titleComp * -1;
    default:
      return 0;
  }
}
