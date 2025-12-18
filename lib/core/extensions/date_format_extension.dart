import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  String get formatForNotes => DateFormat('EEE, dd MMM yyyy').format(this);
  String get formatForReminders =>
      DateFormat.jms().addPattern(', ').add_yMMMd().format(this);
}
