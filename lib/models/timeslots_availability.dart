class TimeSlotAvailability {
  final bool availability;

  TimeSlotAvailability({required this.availability});

  factory TimeSlotAvailability.fromJson(Map<String, dynamic> json) {
    return TimeSlotAvailability(
      availability: json['availability'] as bool,
    );
  }
}

class TimeSlot {
  final String timeSlot;
  final TimeSlotAvailability availability;

  TimeSlot({required this.timeSlot, required this.availability});

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      timeSlot: json.keys.first as String,
      availability: TimeSlotAvailability.fromJson(json.values.first),
    );
  }
}

class Day {
  final int day;
  final List<TimeSlot> timeSlots;

  Day({required this.day, required this.timeSlots});

  factory Day.fromJson(Map<String, dynamic> json) {
    final day = int.parse(json.keys.first);
    final timeSlots = json.values.first
        .map((timeSlotJson) => TimeSlot.fromJson(timeSlotJson))
        .toList();
    return Day(day: day, timeSlots: timeSlots);
  }
}

class Schedule {
  final List<Day> days;

  Schedule({required this.days});

  factory Schedule.fromJson(List<dynamic> json) {
    final days = json.map((dayJson) => Day.fromJson(dayJson)).toList();
    return Schedule(days: days);
  }
}
