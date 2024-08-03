import 'package:todo_list/src/models/task.dart';

class FilterTasks {
  final List<Task> tasks;
  FilterTasks({required this.tasks});

  List<Task> basedOnCompletion({required bool isCompleted}) {
    List<Task> filteredTasks = List.from(tasks);
    filteredTasks.retainWhere((task) => task.isDone == isCompleted);
    filteredTasks.sort((a, b) {
      if (isCompleted && b.dateDone != null && a.dateDone != null) {
        return b.dateDone!.compareTo(a.dateDone!);
      }
      return 0; //no completion date (so all are the same)
    });
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
        (task) => task.priority == priority && task.isDone == isCompleted);
    filteredTasks.sort((a, b) {
      if (a.dateDue != null && b.dateDue != null) {
        // Primary comparison by due date
        return b.dateDue!.compareTo(a.dateDue!);
      } else if (a.dateDue == null && b.dateDue != null) {
        return 1; // b is after a (task w/date goes 1st)
      } else if (b.dateDue == null && a.dateDue != null) {
        return -1; // a is after b (task w/date goes 1st)
      }
      // Secondary comparison by date created
      return b.dateCreated.compareTo(a.dateCreated);
    });
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
    DateTime? todaysDate = DateTime.now();
    todaysDate = dateOnly(todaysDate);

    List<Task> filteredTasks = List.from(tasks);
    switch (datePeriod) {
      case "overdue":
        filteredTasks.retainWhere((task) {
          bool logic = task.isDone == isCompleted;
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff < 0 && logic;
          }
          return false;
        });
      case "today":
        filteredTasks.retainWhere((task) {
          bool logic = task.isDone == isCompleted;
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff == 0 && logic;
          }
          return false;
        });
      case "tomorrow":
        filteredTasks.retainWhere((task) {
          bool logic = task.isDone == isCompleted;
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff == 1 && logic;
          }
          return false;
        });
      case "next": //next 7 days (2-7) days
        filteredTasks.retainWhere((task) {
          bool logic = task.isDone == isCompleted;
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff > 1 && dayDiff <= 7 && logic;
          }
          return false;
        });
      case "later": //later
        filteredTasks.retainWhere((task) {
          bool logic = task.isDone == isCompleted;
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff > 7 && logic;
          }
          return false;
        });
      default: //no date
        filteredTasks.retainWhere((task) {
          bool logic = task.isDone == isCompleted;
          DateTime? date = getDateFromTask(task: task, dateType: dateType);
          if (date == null) {
            return logic;
          }
          return false;
        });
    }
    return filteredTasks;
  }

  DateTime? getDateFromTask({
    required Task task,
    required String dateType,
  }) {
    dateType = dateType.toLowerCase();
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

  DateTime? dateOnly(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }
}
