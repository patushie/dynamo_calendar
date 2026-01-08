import 'holiday_orient_type.dart';
import 'holiday_weekend_recognition_type.dart';

class HolidayDayDTO {

  int? holidayDayID = 0;
  String? holidayName = "";
  String? holidayDate = "";
  int? numberOfDays = 0;
  HolidayOrientType? holidayOrientType = HolidayOrientType.none;
  HolidayWeekendRecognitionType? weekendRecognitionType = HolidayWeekendRecognitionType.none;
  String? holidayDateStr = "";

  HolidayDayDTO({
    this.holidayDayID,
    this.holidayName,
    this.holidayDate,
    this.numberOfDays,
    this.holidayOrientType,
    this.weekendRecognitionType,
    this.holidayDateStr,
  });

  HolidayDayDTO.init(){
    holidayDayID = 0;
    holidayName = "";
    holidayDate = "";
    numberOfDays = 0;
    holidayOrientType = HolidayOrientType.none;
    weekendRecognitionType = HolidayWeekendRecognitionType.none;
    holidayDateStr = "";
  }

  HolidayDayDTO fromMap(Map<String, dynamic> json) =>
      HolidayDayDTO(
        holidayDayID: json["holidayDayID"],
        holidayName: json["holidayName"],
        holidayDate: json["holidayDate"],
        numberOfDays: json["numberOfDays"],
        holidayOrientType: HolidayOrientType.fromName(json["holidayOrientType"]),
        weekendRecognitionType: HolidayWeekendRecognitionType.fromName(json["weekendRecognitionType"]),
        holidayDateStr: json["holidayDateStr"],
      );

  Map<String, dynamic> toMap() => {
    "holidayDayID": holidayDayID,
    "holidayName": holidayName,
    "holidayDate": holidayDate,
    "numberOfDays": numberOfDays,
    "holidayOrientType": holidayOrientType.toString(),
    "weekendRecognitionType": weekendRecognitionType.toString(),
    "holidayDateStr": holidayDateStr,
  };

}