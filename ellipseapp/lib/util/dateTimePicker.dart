import 'package:flutter/material.dart';

Future<DateTime> dateTimePicker(BuildContext context) async {
  final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100));
  if (date != null) {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );
    return DateTime(
        date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);
  }
  return null;
}
