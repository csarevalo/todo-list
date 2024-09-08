import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snazzy_todo_list/src/widgets/task_section.dart';

import '../constants/task_group_headings.dart';
import '../models/section_heading.dart';
import '../models/task.dart';
import '../models/task_sort_options.dart';
import '../providers/task_provider.dart';
import '../providers/task_preferences_controller.dart';
import '../utils/filter_tasks.dart';

import 'expandable_task_sections.dart';
import 'task_tile.dart';

class TaskSectionsBuilder extends StatelessWidget {
  const TaskSectionsBuilder({
    super.key,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    final taskSortOptions =
        context.select<TaskPreferencesController, TaskSortOptions>(
      (taskPrefs) => taskPrefs.taskSortOptions,
    );

    const TaskGroupHeadings headingOptions = TaskGroupHeadings();

    // List<ExpandableTaskSection> getSectionedTaskTiles({
    List<Widget> getSectionedTaskTiles({
      required String groupBy,
    }) {
      groupBy = groupBy.toLowerCase().trim();
      final List<SectionHeading> priorityHeadings =
          headingOptions.priorityHeadings();

      final List<SectionHeading> dateSections = headingOptions.dateHeadings();
      List<SectionHeading> groupHeaders;
      // List<ExpandableTaskSection> sectionTiles = [];
      List<Widget> sectionTiles = [];
      List<TaskTile> Function(String)? getChildren;

      switch (groupBy) {
        case "priority":
          groupHeaders = priorityHeadings;
        // getChildren =
        //     (String s) => getTaskTileBasedOnPriority(strPriority: s);
        case "due_date": //Date Due
          groupHeaders = dateSections;
        // getChildren = (String s) => getTaskTileBasedOnDate(
        //       datePeriod: s,
        //       dateType: 'due',
        //     );
        default:
          //TODO: Do not add a section and just the tasks
          groupHeaders = [SectionHeading(heading: "Not Completed")];
        // getChildren = (String s) => getTaskTilesBasedOnCompletion(
        //       isCompleted: false,
        //     );
      }
      for (var section in groupHeaders) {
        // var children = getChildren(section.heading.split(' ')[0]);
        // if (children.isNotEmpty) {
        sectionTiles.add(
          // ExpandableTaskSection(
          //   titleText: section.heading,
          //   children: children,
          // ),
          TaskSection(
              sectionTitle: section.heading, taskSortOptions: taskSortOptions),
        );
        // }
      }
      return sectionTiles;
    }

    List<Widget> expandableTaskSections = [
      ...getSectionedTaskTiles(
        groupBy: taskSortOptions.groupBy,
      ),
      TaskSection(
        sectionTitle: "Completed",
        taskSortOptions: taskSortOptions,
      ),
      // ExpandableTaskSection(
      //   titleText: "Completed",
      //   children: getTaskTilesBasedOnCompletion(isCompleted: true),
      // ),
    ];
    return ListView.builder(
      itemCount: expandableTaskSections.length,
      itemBuilder: (context, int index) {
        return expandableTaskSections[index];
      },
    );
  }
}
