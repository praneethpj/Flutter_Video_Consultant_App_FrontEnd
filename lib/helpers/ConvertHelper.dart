import 'dart:math';

import 'package:intl/intl.dart';

class ConvertHelper {
  static String toCurrencyFormat(double values) {
    String result = values.toStringAsFixed(2);
    return result;
  }

  static String getRandomString(int length) {
    var _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static int calculateTotalMinutes(String startTime, String endTime) {
    List<String> startParts = startTime.split(':');

    int startMinutes = int.parse(startParts[0]) * 60 + int.parse(startParts[1]);

    List<String> endParts = endTime.split(':');
    int endMinutes = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);

    int totalMinutes = endMinutes - startMinutes;

    return totalMinutes;
  }

  static int convertMinutesToEndTime(int minutes) {
    return DateTime.now().millisecondsSinceEpoch + (1000 * 60 * minutes);
  }

  static String formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(price);
  }

  static String generateRandomPassword(int length) {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789";
    final random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }
}
