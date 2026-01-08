enum HolidayWeekendRecognitionType {
  none("none"),

  nextWorkingDay("next_working_day"),

  sameDay("same_day");

  final String enumValue;

  const HolidayWeekendRecognitionType(this.enumValue);

  factory HolidayWeekendRecognitionType.fromPosition(int ordinalValue) {
    return values.firstWhere((e) => e.index == ordinalValue);
  }

  factory HolidayWeekendRecognitionType.fromName(String stringValue) {
    return values.firstWhere((e) => e.enumValue.toUpperCase() == stringValue.toUpperCase());
  }

  @override
  String toString() {
    return enumValue;
  }
}
