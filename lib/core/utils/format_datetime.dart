import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateFormat timeFormat = DateFormat.jm();
  DateFormat fullDateFormat = DateFormat('EEE MMM d, h:mm a');

  // Check if the given dateTime is today
  if (now.year == dateTime.year &&
      now.month == dateTime.month &&
      now.day == dateTime.day) {
    return 'Today ${timeFormat.format(dateTime)}';
  } else {
    return fullDateFormat.format(dateTime);
  }
}
