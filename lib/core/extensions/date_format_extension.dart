import 'package:intl/intl.dart';

extension DateFormatExtension on DateTime {
  String get formatForUi => DateFormat('EEE, dd MMM yyyy').format(this);
}
