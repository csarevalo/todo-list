import 'package:flutter/material.dart';

import '../models/section_heading.dart';

class TaskGroupHeadings {
  const TaskGroupHeadings();

  List<SectionHeading> priorityHeadings() {
    return <SectionHeading>[
      SectionHeading(
        heading: "High Priority",
        leadingIcon: const Icon(Icons.flag, color: Colors.red),
      ),
      SectionHeading(
        heading: "Medium Priority",
        leadingIcon: const Icon(Icons.flag, color: Colors.yellow),
      ),
      SectionHeading(
        heading: "Low Priority",
        leadingIcon: const Icon(Icons.flag, color: Colors.blue),
      ),
      SectionHeading(
        heading: "No Priority",
        leadingIcon: const Icon(Icons.flag, color: Colors.grey),
      ),
    ];
  }

  List<SectionHeading> dateHeadings() {
    return <SectionHeading>[
      SectionHeading(heading: "Overdue Pospone"),
      SectionHeading(heading: "Today"),
      SectionHeading(heading: "Tomorrow"),
      SectionHeading(heading: "Next 7 Days"),
      SectionHeading(heading: "Later"),
      SectionHeading(heading: "No Date"),
    ];
  }
}
