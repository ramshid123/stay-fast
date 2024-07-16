import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime, {bool isTimeNeeded = true}) {
  DateTime now = DateTime.now();
  DateFormat timeFormat = DateFormat.jm();
  DateFormat fullDateFormat =
      isTimeNeeded ? DateFormat('EEE MMM d, h:mm a') : DateFormat('EEE MMM d');

  // Check if the given dateTime is today
  if (now.year == dateTime.year &&
      now.month == dateTime.month &&
      now.day == dateTime.day) {
    return 'Today${isTimeNeeded ? ' ${timeFormat.format(dateTime)}' : ''}';
  } else {
    return fullDateFormat.format(dateTime);
  }
}
