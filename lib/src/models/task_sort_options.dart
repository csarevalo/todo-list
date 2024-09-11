class TaskSortOptions {
  String groupBy;
  SortBy sort1stBy;
  // String sort1stBy;
  bool desc1;
  SortBy sort2ndBy;
  // String sort2ndBy;
  bool desc2;
  TaskSortOptions({
    required this.groupBy,
    required this.sort1stBy,
    required this.desc1,
    required this.sort2ndBy,
    required this.desc2,
  });

  /// List of sort options
  static const List<String> _sortOptions = [
    "Title",
    "Priority",
    "Last Modified",
    "Due Date",
    "Date Created",
    "None"
  ];

  /// List of sort options available as a list of strings
  List<String> get sortOptions => _sortOptions;
}

String sortByToString(SortBy sortBy) {
  switch (sortBy) {
    case SortBy.dateCreate:
      return "Date Created";
    case SortBy.dueDate:
      return "Due Date";
    case SortBy.lastModified:
      return "Last Modified";
    case SortBy.priority:
      return "Priority";
    case SortBy.title:
      return "Title";
    default:
      return 'None';
  }
}

SortBy strToSortBy(String str) {
  String sortBy = str.toLowerCase().replaceAll(" ", "_");
  switch (sortBy) {
    case "date_created":
      return SortBy.dateCreate;
    case "due_date":
      return SortBy.dueDate;
    case "last_modified":
      return SortBy.lastModified;
    case "priority":
      return SortBy.priority;
    case "title":
      return SortBy.title;
    default:
      return SortBy.none;
  }
}

/// Determines how to sort tasks.
enum SortBy {
  /// Sort Tasks by the date created.
  dateCreate,

  /// Sort Tasks by the due date.
  dueDate,

  /// Sort Tasks by the last modified date.
  lastModified,

  /// Does not sort Tasks.
  none,

  /// Sort Tasks by priority.
  priority,

  ///Sort Tasks by title.
  title,
}

/// Determines how to group tasks.
enum GroupBy {
  /// Group Tasks by priority.
  priority,

  /// Group Tasks by due date.
  dueDate,

  /// Group Tasks by List
  list,

  /// Group Tasks by Tag
  tag,

  /// Group Tasks by those NOT completed.
  notCompleted,

  /// Does NOT group tasks.
  none,
}
