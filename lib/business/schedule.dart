import 'package:intl/intl.dart'; // for date format
import 'package:trabajo_practico/managers/user_manager.dart'; // for other locales

class Schedule {
  final int number;
  final String text;
  final Map bookings;

  String? get user
  {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(UserManager.selectedDate);

    Map map = bookings;
    String? user = (map.containsKey(formattedDate)) ? map[formattedDate] : "";

    return user == null ? "" : user;
  }

  set user(String ?user) {
    DateFormat dateFormat =   DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormat.format(UserManager.selectedDate);

    this.bookings[formattedDate] = user;
  }

  Schedule({
    required this.number,
    required this.text,
    required this.bookings,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'number': int number,
        'text': String text,
        'bookings': Map bookings,
      } =>
        Schedule(
          number: number,
          text: text,
          bookings: bookings,
        ),
      _ => throw const FormatException('Failed to load schedule.'),
    };
  }
}