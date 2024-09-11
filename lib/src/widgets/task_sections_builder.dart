import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snazzy_todo_list/src/widgets/task_section.dart';

import '../constants/task_group_headings.dart';
import '../models/section_heading.dart';
import '../models/task_sort_options.dart';
import '../providers/task_preferences_controller.dart';

class TaskSectionsBuilder extends StatelessWidget {
  const TaskSectionsBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskSortOptions =
        context.select<TaskPreferencesController, TaskSortOptions>(
      (taskPrefs) => taskPrefs.taskSortOptions,
    );

    const TaskGroupHeadings headingOptions = TaskGroupHeadings();

    List<Widget> getSectionedTaskTiles({
      required GroupBy groupBy,
    }) {
      groupBy = groupBy; //.toLowerCase().trim(); TODO: remove comment 
      final List<SectionHeading> priorityHeadings =
          headingOptions.priorityHeadings();

      final List<SectionHeading> dateSections = headingOptions.dateHeadings();
      List<SectionHeading> groupHeaders;
      List<Widget> sectionTiles = [];

      switch (groupBy) {
        case GroupBy.priority://"priority":
          groupHeaders = priorityHeadings;
        case GroupBy.dueDate://"due_date": //Date Due
          groupHeaders = dateSections;
        default:
          //TODO: Do not add a section and just the tasks
          groupHeaders = [SectionHeading(heading: "Not Completed")];
      }
      for (var section in groupHeaders) {
        sectionTiles.add(
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
    ];
    return ListView.builder(
      itemCount: expandableTaskSections.length,
      itemBuilder: (context, int index) {
        return expandableTaskSections[index];
      },
    );
  }
}
