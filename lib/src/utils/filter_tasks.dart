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

    // filteredTasks.sort((a, b) {
    //   int dueDateComp = 0;
    //   if (b.dateDue != null && a.dateDue != null) {
    //     dueDateComp = b.dateDue!.compareTo(a.dateDue!);
    //   } else if (a.dateDue == null && b.dateDue != null) {
    //     dueDateComp = 1; // b is after a (task w/date goes 1st)
    //   } else if (b.dateDue == null && a.dateDue != null) {
    //     dueDateComp = -1; // a is after b (task w/date goes 1st)
    //   }
    //   // Primary comparison by due date
    //   if (dueDateComp != 0) return dueDateComp;
    //   // Secondary comparison by date created
    //   return b.dateCreated.compareTo(a.dateCreated);
    // });

    filteredTasks.sort(sortTasksBy("due_date", desc: true));
    // filteredTasks.sort(sortTasksBy("priority", desc: true));

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

typedef SortTask = int Function(Task a, Task b);
// typedef SortF = SortTask Function(String sortField);
SortTask sortTasksBy(
  String sortBy, {
  bool desc = true, // order of sort by
  bool isCompleted = false,
}) {
  switch (sortBy) {
    case 'due_date':
      return (a, b) {
        // Primary comparison by due date
        int dueDateComp = compareBasedOn(
          "due_date",
          taskA: a,
          taskB: b,
          desc: desc,
        );
        if (dueDateComp != 0) {
          return desc ? dueDateComp : dueDateComp * -1;
        }
        // Secondary comparison by date created
        int dateCreatedComp = compareBasedOn(
          "date_created",
          taskA: a,
          taskB: b,
          desc: desc,
        );
        return dateCreatedComp;
      };
    case 'priority':
      return (a, b) {
        int priorityComp = compareBasedOn(
          "priority",
          taskA: a,
          taskB: b,
          desc: desc,
        );
        return priorityComp;
      };
    case 'title':
      break;
    case 'last_modified':
      break;
    default: // 'date_created'
  }
  return (a, b) => 0;
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
