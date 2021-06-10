import 'package:intl/intl.dart';

class DateFormatter {

  static String? parseDate(DateTime? dateTime) {
    return dateTime != null? DateFormat('dd.MM.yyyy').format(dateTime) : null;
  }

}