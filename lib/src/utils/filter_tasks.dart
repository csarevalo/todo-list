import 'package:todo_list/src/models/task.dart';

class FilterTasks {
  final List<Task> tasks;
  FilterTasks({required this.tasks});

  //TODO: add sort option to be controlled from settings_controller

  List<Task> basedOnCompletion({required bool isCompleted}) {
    List<Task> filteredTasks = List.from(tasks);
    filteredTasks.retainWhere((task) => task.isDone == isCompleted);
    filteredTasks.sort((a, b) {
      // Primary comparison by completion date
      if (isCompleted && b.dateDone != null && a.dateDone != null) {
        return b.dateDone!.compareTo(a.dateDone!);
      }
      // Secondary comparison by due date
      if (a.dateDue != null && b.dateDue != null) {
        return b.dateDue!.compareTo(a.dateDue!);
      } else if (a.dateDue == null && b.dateDue != null) {
        return 1; // b is after a (task w/date goes 1st)
      } else if (b.dateDue == null && a.dateDue != null) {
        return -1; // a is after b (task w/date goes 1st)
      }
      // Tertiary comparison by date created
      return b.dateCreated.compareTo(a.dateCreated);
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
      (task) => task.priority == priority && task.isDone == isCompleted,
    );
    filteredTasks.sort((a, b) {
      int dueDateComp = 0;
      if (b.dateDue != null && a.dateDue != null) {
        dueDateComp = b.dateDue!.compareTo(a.dateDue!);
      } else if (a.dateDue == null && b.dateDue != null) {
        dueDateComp = 1; // b is after a (task w/date goes 1st)
      } else if (b.dateDue == null && a.dateDue != null) {
        dueDateComp = -1; // a is after b (task w/date goes 1st)
      }

      // Primary comparison by due date
      if (dueDateComp != 0) return dueDateComp;
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
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff < 0 && task.isDone == isCompleted;
          }
          return false;
        });
      case "today":
        filteredTasks.retainWhere((task) {
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff == 0 && task.isDone == isCompleted;
          }
          return false;
        });
      case "tomorrow":
        filteredTasks.retainWhere((task) {
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff == 1 && task.isDone == isCompleted;
          }
          return false;
        });
      case "next": //next 7 days (2-7) days
        filteredTasks.retainWhere((task) {
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff > 1 && dayDiff <= 7 && task.isDone == isCompleted;
          }
          return false;
        });
      case "later": //later
        filteredTasks.retainWhere((task) {
          int? dayDiff = getDateFromTask(task: task, dateType: dateType)
              ?.difference(todaysDate!)
              .inDays;
          if (dayDiff != null) {
            return dayDiff > 7 && task.isDone == isCompleted;
          }
          return false;
        });
      default: //no date
        filteredTasks.retainWhere((task) {
          DateTime? date = getDateFromTask(task: task, dateType: dateType);
          if (date == null) {
            return task.isDone == isCompleted;
          }
          return false;
        });
    }

    filteredTasks.sort((a, b) {
      int dueDateComp = 0;
      if (b.dateDue != null && a.dateDue != null) {
        dueDateComp = b.dateDue!.compareTo(a.dateDue!);
      } else if (a.dateDue == null && b.dateDue != null) {
        dueDateComp = 1; // b is after a (task w/date goes 1st)
      } else if (b.dateDue == null && a.dateDue != null) {
        dueDateComp = -1; // a is after b (task w/date goes 1st)
      }

      // Primary comparison by due date
      if (dueDateComp != 0) return dueDateComp;
      // Secondary comparison by date created
      return b.dateCreated.compareTo(a.dateCreated);
    });

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

//TODO: Pass Settings Controller here
List<Task> sortTasks() {
  return [];
}
