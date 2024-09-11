import 'package:enum_to_string/enum_to_string.dart';

class TaskSortOptions {
  GroupBy groupBy;
  SortBy sort1stBy;
  bool desc1;
  SortBy sort2ndBy;
  bool desc2;
  TaskSortOptions({
    required this.groupBy,
    required this.sort1stBy,
    required this.desc1,
    required this.sort2ndBy,
    required this.desc2,
  });

  /// List of sort options (preferred order)
  static const List<String> _sortOptions = [
    "Title",
    "Priority",
    "Due Date",
    "Tag",
    "Last Modified",
    "Date Created",
    "None"
  ];

  /// List of group options (preferred order)
  static const List<String> _groupOptions = [
    "List",
    "Due Date",
    "Priority",
    "Tag",
    "Not Completed",
    "None",
  ];

  /// Get list of sort options available
  List<String> get sortOptions {
    // var sorts = <String>[];
    // EnumToString.toList(SortBy.values, camelCase: true)
    //     .forEach((name) => sorts.add(_titleCase(name)));
    // return sorts;
    return _sortOptions.reversed.toList();
  }

  /// Get list of group options available
  List<String> get groupOptions {
    // var groups = <String>[];
    // EnumToString.toList(SortBy.values, camelCase: true)
    //     .forEach((name) => groups.add(_titleCase(name)));
    // return groups;
    return _groupOptions.reversed.toList();
  }
}

/// Capitalizes Each Word.
String _titleCase(String name) {
  final stringBuffer = StringBuffer();
  var capitalizeNext = true;
  for (final letter in name.toLowerCase().codeUnits) {
    // UTF-16: A-Z => 65-90, a-z => 97-122.
    if (capitalizeNext && letter >= 97 && letter <= 122) {
      stringBuffer.writeCharCode(letter - 32);
      capitalizeNext = false;
    } else {
      // UTF-16: 32 == space, 46 == period
      if (letter == 32 || letter == 46) capitalizeNext = true;
      stringBuffer.writeCharCode(letter);
    }
  }
  return stringBuffer.toString();
}

String sortByToString(SortBy sortBy) {
  return _titleCase(EnumToString.convertToString(sortBy, camelCase: true));
}

SortBy strToSortBy(String str) {
  return EnumToString.fromString(SortBy.values, str, camelCase: true) ??
      SortBy.none;
}

String groupByToString(GroupBy groupBy) {
  return _titleCase(EnumToString.convertToString(groupBy, camelCase: true));
}

GroupBy strToGroupBy(String str) {
  return EnumToString.fromString(GroupBy.values, str, camelCase: true) ??
      GroupBy.none;
}

/// Determines how to sort tasks.
enum SortBy {
  /// Sort Tasks by the date created.
  dateCreated,

  /// Sort Tasks by the due date.
  dueDate,

  /// Sort Tasks by the last modified date.
  lastModified,

  /// Does not sort Tasks.
  none,

  /// Sort Tasks by priority.
  priority,

  /// Sort Tasks by tag.
  tag,

  /// Sort Tasks by title.
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
