import 'package:todo_list/src/models/task.dart';
import 'package:todo_list/src/models/task_view_options.dart';

class FilterTasks {
  final List<Task> tasks;
  final TaskViewOptions taskViewOptions;
  FilterTasks({
    required this.tasks,
    required this.taskViewOptions,
  });

  //TODO: add sort option to be controlled from settings_controller

  List<Task> basedOnCompletion({required bool isCompleted}) {
    List<Task> filteredTasks = List.from(tasks);
    filteredTasks.retainWhere((task) => task.isDone == isCompleted);
    filteredTasks.sort(isCompleted
        ? (a, b) => b.dateDone!.compareTo(a.dateDone!)
        : sortTasksBy(sort1stBy: 'title', desc1: true));
    return filteredTasks;
  }

  List<Task> basedOnPriority({
    required String strPriority,
    bool isCompleted = false, //default: uncompleted
  }) {
    List<Task> filteredTasks = List.from(tasks);
    int priority;
    switch (strPriority) {
      case "High":
        priority = 3;
      case "Medium":
        priority = 2;
      case "Low":
        priority = 1;
      default:
        priority = 0;
    }
    filteredTasks.retainWhere(
      (task) => task.priority == priority && task.isDone == isCompleted,
    );
    filteredTasks.sort(sortTasksBy(
      sort1stBy: 'due_date',
      sort2ndBy: 'last_modified',
    ));
    return filteredTasks;
  }

  List<Task> basedOnDate({
    required String
        datePeriod, // Options: overdue, today, tomorrow, next, later
    required String dateType, // Options: done, modified, due, created
    bool isCompleted = false, // Default: uncompleted
  }) {
    dateType = dateType.toLowerCase();
    datePeriod = datePeriod.toLowerCase();
    // DateTime? todaysDate = dateOnly(DateTime.now());

    List<Task> filteredTasks = List.from(tasks);
    filteredTasks.retainWhere(retainTaskWhere(
      dateType: dateType,
      datePeriod: datePeriod,
    ));

    filteredTasks.sort(sortTasksBy(
      sort1stBy: "due_date",
      sort2ndBy: "priority",
      desc1: true,
      desc2: false,
    ));

    return filteredTasks;
  }
}

typedef RetainTaskWhere = bool Function(Task task);

RetainTaskWhere retainTaskWhere({
  required String dateType, // Options: done, modified, due, created
  required String datePeriod, // Options: overdue, today, tomorrow, next, later
  bool isCompleted = false,
}) {
  dateType = dateType.toLowerCase();
  DateTime? todaysDate = dateOnly(DateTime.now());
  bool Function(int) dayComp;
  switch (datePeriod) {
    case 'overdue':
      dayComp = (dayDiff) => dayDiff < 0;
    case 'today':
      dayComp = (dayDiff) => dayDiff == 0;
    case 'tomorrow':
      dayComp = (dayDiff) => dayDiff == 1;
    case 'next': //next 7 days (2-7) days
      dayComp = (dayDiff) => dayDiff >= 2 && dayDiff <= 7;
    case 'later':
      dayComp = (dayDiff) => dayDiff > 7;
    default: //no date.. is not used
      dayComp = (_) => false;
  }
  return (Task task) {
    if (task.isDone != isCompleted) return false;
    DateTime? taskDate = getDateFromTask(task: task, dateType: dateType);
    int? dayDiff = taskDate?.difference(todaysDate!).inDays;
    if (dayDiff != null) return dayComp(dayDiff);
    return true;
  };
}

/// Used to compare date relative to days
DateTime? dateOnly(DateTime? date) {
  if (date == null) return null;
  return DateTime(date.year, date.month, date.day);
}

/// Gets the date only based on datetype (done, modifed, due, created)
DateTime? getDateFromTask({
  required Task task,
  required String dateType,
}) {
  switch (dateType) {
    case "done":
      return dateOnly(task.dateDone);
    case "modified":
      return dateOnly(task.dateModified);
    case "due":
      return dateOnly(task.dateDue);
    default: //created
      return dateOnly(task.dateCreated);
  }
}

typedef SortTask = int Function(Task a, Task b);

SortTask sortTasksBy({
  required String sort1stBy,
  String sort2ndBy = '',
  bool desc1 = true, // order of 1st sort by
  bool desc2 = true, // order of 2nd sort by
  bool isCompleted = false,
}) {
  return (a, b) {
    // Primary comparison by 1st sortBy
    int firstComp = compareBasedOn(sort1stBy, taskA: a, taskB: b, desc: desc1);
    if (firstComp != 0) return firstComp;
    // Secondary comparison by 2nd sortBy
    int secondComp = compareBasedOn(sort2ndBy, taskA: a, taskB: b, desc: desc2);
    return secondComp;
  };
}

int compareBasedOn(
  String compBy, {
  required Task taskA,
  required Task taskB,
  bool desc = true,
}) {
  switch (compBy) {
    case "due_date":
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
    case "last_modified":
      int lastModComp = taskB.dateModified.compareTo(taskA.dateModified);
      return desc ? lastModComp : lastModComp * -1;
    case "date_created":
      int dateCreatedComp = taskB.dateCreated.compareTo(taskA.dateCreated);
      return desc ? dateCreatedComp : dateCreatedComp * -1;
    case "priority":
      int priorityComp = taskB.priority.compareTo(taskA.priority);
      return desc ? priorityComp : priorityComp * -1;
    case "title":
      int titleComp =
          taskB.title.toLowerCase().compareTo(taskA.title.toLowerCase());
      return desc ? titleComp : titleComp * -1;
    default:
      return 0;
  }
}
