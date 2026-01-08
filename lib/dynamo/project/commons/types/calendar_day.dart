// ignore_for_file: comment_references

class CalendarDay {
  int? dayNumber = 0;
  String? weekDay = "";
  bool? activeMonthDay = true;
  DateTime? dateTime;

  CalendarDay({
    this.dayNumber,
    this.weekDay,
    this.activeMonthDay = true,
    this.dateTime,
  });

  CalendarDay.init(){
    dayNumber = 0;
    weekDay = "";
    activeMonthDay = true;
  }

  @override
  bool operator ==(Object other) {
    bool? isEqls = false;

    if (other is CalendarDay) {
      CalendarDay entity = other;

      if ((entity.dayNumber! > 0) && (dayNumber! > 0)) {
        isEqls = entity.dayNumber == dayNumber;
      }
    }

    return isEqls;
  }

  @override
  int get hashCode => weekDay.hashCode;

  @override
  String toString() {
    return "{'dayNumber': $dayNumber, 'weekDay': $weekDay}";
  }
}