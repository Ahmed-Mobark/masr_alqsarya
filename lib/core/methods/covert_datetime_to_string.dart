import 'package:intl/intl.dart';

class ConvertDateTime {
  static String convertDateTimeToDate({required DateTime date}) => DateFormat(
    'yyyy-MM-dd',
  ).format(convertDateTimeToSaudiDateTime(date: date));
  static String convertDateTimeToTime({required DateTime date}) =>
      DateFormat.jm().format(convertDateTimeToSaudiDateTime(date: date));

  static DateTime convertDateTimeToSaudiDateTime({required DateTime date}) {
    if (date.isUtc) {
      DateTime saudiDate = DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute,
      );
      return saudiDate.add(const Duration(hours: 3));
    }
    return date;
  }

  static DateTime getFirstDayOfMainMonth(List<DateTime> dates) {
    Map<int, int> monthCounts = {};

    for (DateTime date in dates) {
      monthCounts[date.month] = (monthCounts[date.month] ?? 0) + 1;
    }

    int mainMonth = monthCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return dates.firstWhere((date) => date.month == mainMonth && date.day == 1);
  }
}
