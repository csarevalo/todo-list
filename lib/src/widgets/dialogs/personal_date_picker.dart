import 'package:flutter/material.dart';

Future<void> showPersonalDatePicker(BuildContext context) {
  final today = DateTime.now();
  // void _handleDateChanged(DateTime date) {
  //   setState(() {
  //     _selectedDate.value = date;
  //   });
  // }

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text("Hello World"),
      content: SizedBox(
        height: 200,
        width: 200,
        child: CalendarDatePicker(
          initialCalendarMode: DatePickerMode.day,
          initialDate: today,
          currentDate: today,
          firstDate:
              today.subtract(const Duration(days: 365 * 25)), // 25 yrs ago
          lastDate: today.add(const Duration(days: 365 * 50)),
          onDateChanged: (DateTime value) {}, // 50 yrs in future
          // onDateChanged: _handleDateChanged,
          // selectableDayPredicate: widget.selectableDayPredicate,
        ),
      ),
    ),
  );
}
