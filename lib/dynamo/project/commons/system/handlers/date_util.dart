// ignore_for_file: comment_references

import 'package:dynamo_data_table/dynamo/project/commons/constants/pad_direction_type.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/entities/date_element_type.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/entities/holiday_day_dto.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/entities/holiday_orient_type.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/entities/holiday_weekend_recognition_type.dart';
import 'package:intl/intl.dart';

import 'dynamo_commons.dart';

class DateUtil {
  static final String amMeridiem = "AM";
  //
  static final String pmMeridiem = "PM";
  //
  static List<String> monthNames = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
  //
  static List<String> monthShortNames = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
  //
  static List<String> weekDays = ["SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY"];
  //
  static List<String> weekDaysShort = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];

  static final int weekdaySaturday = 6;
  //
  static final int weekdaySunday = 7;
  //
  static final int maxMonths = 12;
  //
  //print? all time zones:
  //DynamoCommons.printLongString('++++++++ time-zones ==>> ${tz.timeZoneDatabase.locations}');
  //static final SERVER_TIMEZONE = tz.getLocation('Europe/London');

  static DateTime setDateTime(DateTime dateTime, int hour24, int minute) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, hour24, minute);
  }

  static String getServerDateTimeMillis(DateTime? inputDate) {
    if (inputDate != null) {
      /*final serverDate = tz.TZDateTime.local(
          inputDate.year, inputDate.month, inputDate.day, inputDate.hour,
          inputDate.minute);

      return serverDate.millisecondsSinceEpoch.toString();*/
      return inputDate.millisecondsSinceEpoch.toString();
    } else {
      return "";
    }
  }

  static String getStandardDate(DateTime? date, {bool verbose = false}) {
    //DateFormat("yyyy-MM-dd hh:mm:ss").format(now)
    if (date != null) {
      String dayString = DynamoCommons.padString(date.day.toString(), "0", 2, PadDirectionType.left);

      String monthString = DynamoCommons.padString(date.month.toString(), "0", 2, PadDirectionType.left);

      String timePortion = "";

      if (verbose) {
        timePortion = " ${DynamoCommons.padString(date.hour.toString(), "0", 2, PadDirectionType.left)}";
        timePortion += ":${DynamoCommons.padString(date.minute.toString(), "0", 2, PadDirectionType.left)}";
        timePortion += ":${DynamoCommons.padString(date.second.toString(), "0", 2, PadDirectionType.left)}";
      }

      return "$dayString / $monthString / ${date.year.toString()}$timePortion";
    } else {
      return "";
    }
  }

  static String getAsTime(DateTime? date, {bool verbose = true}) {
    DateTime today = DateTime.now();

    if (date != null) {
      if ((date.year == today.year) && (date.month == today.month) && (date.day == today.day)) {
        if (verbose) {
          return "Today, ${DateFormat("hh:mma").format(date)}";
        } else {
          return DateFormat("hh:mma").format(date);
        }
      } else if (date.year == today.year) {
        return DateFormat("d MMM, hh:mma").format(date);
      } else {
        return DateFormat("d MMM y, H:mm").format(date);
      }
    } else {
      return "";
    }
  }

  static String getMonthDate(DateTime date, {bool inWords = false}) {
    String monthDateStr = "";

    if (inWords) {
      monthDateStr = "${monthShortNames[date.month - 1]}/${date.year.toString()}";
    } else {
      monthDateStr = "${date.month.toString()}/${date.year.toString()}";
    }

    return monthDateStr;
  }

  static String? getTimeOnly(DateTime date) {
    return DateFormat("hh:mma").format(date);
  }

  static String? getTimeDuration(DateTime date) {
    String? durationMssg = "";

    DateTime currentTime = DateTime.now();

    Duration duration = currentTime.difference(date);
    if (duration.inDays > 0) {
      if (duration.inDays > 100) {
        durationMssg = "Over 100 Days Ago";
      } else {
        durationMssg = "${duration.inDays} Days Ago";
      }
    } else if (duration.inHours > 0) {
      durationMssg = "${duration.inHours} Hrs Ago";
    } else if (duration.inMinutes > 0) {
      durationMssg = "${duration.inMinutes} Mins Ago";
    }

    return durationMssg;
  }

  static String? toMobileJsonDate(DateTime date) {
    return date.toString();
  }

  static String? padAsDateElement(String element) {
    return DynamoCommons.padString(element, "0", 2, PadDirectionType.left);
  }

  static DateTime? parseDate(String? dateString) {
    DateTime? parsedDate;

    if ((dateString != null) && (dateString.isNotEmpty)) {
      if (DynamoCommons.isDigitSequence(dateString)) {
        parsedDate = DateTime.fromMillisecondsSinceEpoch(int.parse(dateString));
      } else if (DynamoCommons.isAlpha(dateString[0])) {
        String monthName = "";
        String dayNumber = "";
        String yearNumber = "";

        int i = 0;

        while (DynamoCommons.isAlpha(dateString[i])) {
          monthName += dateString[i++];
        }

        if (DynamoCommons.isSpace(dateString[i])) {
          i = DynamoCommons.skipSpace(dateString, i);
        }

        if (DynamoCommons.isDigit(dateString[i])) {
          while (DynamoCommons.isDigit(dateString[i])) {
            dayNumber += dateString[i++];
          }

          if (dayNumber.length == 1) {
            dayNumber = "0$dayNumber";
          }
        }

        if (dateString[i] == ",") {
          i++;
        }

        if (DynamoCommons.isSpace(dateString[i])) {
          i = DynamoCommons.skipSpace(dateString, i);
        }

        if (DynamoCommons.isDigit(dateString[i])) {
          while (i <= dateString.length - 1 && DynamoCommons.isDigit(dateString[i])) {
            yearNumber += dateString[i++];
          }
        }

        String? monthNumber = (monthShortNames.indexOf(monthName.toUpperCase()) + 1).toString();
        if (monthNumber.length == 1) {
          monthNumber = "0$monthNumber";
        }

        parsedDate = DateTime.parse("$yearNumber-$monthNumber-$dayNumber");
      } else if (dateString.contains("/") && dateString.indexOf("/") == 2) {
        List<String> datePart = dateString.split("/");

        parsedDate = DateTime.parse("${datePart[2].substring(0, 4)}-${datePart[1]}-${datePart[0]}");

        if (dateString.contains(" ")) {
          parsedDate = DateFormat("dd/MM/yyyy HH:mm:ss").parse(dateString);
        }
      } else {
        if (dateString.contains(" ")) {
          parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
        } else {
          parsedDate = DateTime.parse(dateString);
        }
      }
    }

    return parsedDate;
  }

  static int getMonth(String inputDateStr) {
    return DateUtil.parseDate(inputDateStr)!.month;
  }

  static int getYear(String inputDateStr) {
    return DateUtil.parseDate(inputDateStr)!.year;
  }

  static int getDay(String inputDateStr) {
    return DateUtil.parseDate(inputDateStr)!.day;
  }

  static bool isSameDateAndTime(String? date1, String? date2) {
    DateTime? dateObj1 = DateUtil.parseDate(date1);

    DateTime? dateObj2 = DateUtil.parseDate(date2);

    return dateObj1!.year == dateObj2!.year && dateObj1.month == dateObj2.month && dateObj1.day == dateObj2.day && dateObj1.hour == dateObj2.hour && dateObj1.minute == dateObj2.minute;
  }

  static bool isSameDate(String? date1, String? date2) {
    DateTime? dateObj1 = DateUtil.parseDate(date1);

    DateTime? dateObj2 = DateUtil.parseDate(date2);

    return dateObj1!.year == dateObj2!.year && dateObj1.month == dateObj2.month && dateObj1.day == dateObj2.day;
  }

  static bool isSameDateObj(DateTime? dateObj1, DateTime? dateObj2) {
    return dateObj1!.year == dateObj2!.year && dateObj1.month == dateObj2.month && dateObj1.day == dateObj2.day;
  }

  static bool isMoreRecent(DateTime? dateObj1, DateTime? dateObj2) {
    return dateObj1!.isAfter(dateObj2!);
  }

  static bool isMoreRecentOrSame(String? date1, String? date2) {
    DateTime? dateObj1 = DateUtil.parseDate(date1);
    DateTime? dateObj2 = DateUtil.parseDate(date2);

    bool? sameDateBool = isSameDateObj(dateObj1, dateObj2);

    return sameDateBool || dateObj1!.isAfter(dateObj2!);
  }

  static bool isLeapYear(int year) {
    bool? leapYear = false;

    if (year < 100) {
      if (year > 40) {
        year += 1900;
      } else {
        year += 2000;
      }
    }
    if (year % 4 == 0) {
      if (year % 100 != 0) {
        leapYear = true;
      } else if (year % 400 == 0) {
        leapYear = true;
      }
    }

    return leapYear;
  }

  static int getDaysOfMonth(int mm, int yy) {
    int daysOfMonth = 0;

    if ((mm == 9) || (mm == 4) || (mm == 6) || (mm == 11)) {
      daysOfMonth = 30;
    } else if (mm != 2) {
      daysOfMonth = 31;
    } else if (isLeapYear(yy)) {
      daysOfMonth = 29;
    } else {
      daysOfMonth = 28;
    }

    return daysOfMonth;
  }

  static int getNumberOfDays(DateTime? previousDate, DateTime? currentDate) {
    if ((previousDate != null) && (currentDate != null)) {
      return currentDate.difference(previousDate).inDays;
    } else {
      return 0;
    }
  }

  static int getNumberOfDaysWithoutWeekends(DateTime? startDate, DateTime? endDate) {
    int dayCount = 0;

    int numberOfDays = getNumberOfDays(startDate, endDate);

    int nextYear = startDate?.year ?? 0;
    int nextDay = startDate?.day ?? 0;
    int nextMonth = startDate?.month ?? 0;

    int counter = 0;
    while (counter <= numberOfDays) {
      DateTime localDate = DateTime(nextYear, nextMonth, nextDay);
      if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
        if ((localDate.weekday != weekdaySaturday) && (localDate.weekday != weekdaySunday)) {
          nextDay++;
          dayCount++;
          counter++;

          localDate = DateTime(nextYear, nextMonth, nextDay);
          if ((localDate.weekday == weekdaySaturday) || (localDate.weekday == weekdaySunday)) {
            int? weekEndLen = (localDate.weekday == weekdaySaturday) ? 2 : 1;

            for (int? weekDay = 0; weekDay! <= weekEndLen - 1; weekDay++) {
              if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
                nextDay++;
                counter++;
              } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
                if (nextMonth < maxMonths) {
                  nextMonth++;
                  nextDay = 1;
                } else if (nextMonth == maxMonths) {
                  nextYear++;
                  nextMonth = 1;
                  nextDay = 1;
                }
                counter++;
              }
            }
          }
        } else {
          int? weekEndLen = (localDate.weekday == weekdaySaturday) ? 2 : 1;

          for (int? weekDay = 0; weekDay! <= weekEndLen - 1; weekDay++) {
            if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
              nextDay++;
              counter++;
            } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
              if (nextMonth < maxMonths) {
                nextMonth++;
                nextDay = 1;
              } else if (nextMonth == maxMonths) {
                nextYear++;
                nextMonth = 1;
                nextDay = 1;
              }
              counter++;
            }
          }
        }
      } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
        if ((localDate.weekday != weekdaySaturday) && (localDate.weekday != weekdaySunday)) {
          dayCount++;
          if (nextMonth < maxMonths) {
            nextMonth++;
            nextDay = 1;
          } else if (nextMonth == maxMonths) {
            nextYear++;
            nextMonth = 1;
            nextDay = 1;
          }
          counter++;
        } else if (nextMonth < maxMonths) {
          nextMonth++;

          int? weekEndLen = (localDate.weekday == weekdaySaturday) ? 3 : 2;
          nextDay = weekEndLen;
          dayCount++;

          counter += weekEndLen;
        } else if (nextMonth == maxMonths) {
          nextYear++;
          nextMonth = 1;

          int? weekEndLen = (localDate.weekday == weekdaySaturday) ? 3 : 2;
          nextDay = weekEndLen;
          dayCount++;

          counter += weekEndLen;
        }
      }
    }

    return dayCount;
  }

  static int? getNumberOfDaysWithoutWeekendsAndHolidays(DateTime startDate, DateTime endDate, List<HolidayDayDTO> holidayDayList) {
    int holidayCount = 0;

    int numberOfDays = getNumberOfDays(startDate, endDate);

    int nextYear = startDate.year;
    int nextDay = startDate.day;
    int nextMonth = startDate.month;

    holidayCount = performHoldayCount(numberOfDays, holidayDayList, nextYear, nextMonth, nextDay);

    int? dayCount = getNumberOfDaysWithoutWeekends(startDate, endDate) - holidayCount;

    return dayCount;
  }

  static DateTime getEndOfPeriod(DateTime todayDate, int numberOfElements, DateElementType elementType, {String? weekDay}) {
    if (elementType == DateElementType.day) {
      if (numberOfElements > 0) {
        todayDate = todayDate.add(Duration(days: numberOfElements));
      }
    } else if (elementType == DateElementType.week) {
      if (numberOfElements > 0) {
        todayDate = todayDate.add(Duration(days: numberOfElements * 7));
      }
    } else if (elementType == DateElementType.month) {
      if (numberOfElements > 0) {
        todayDate = todayDate.add(Duration(days: numberOfElements * 30));
      }
    } else if (elementType == DateElementType.year) {
      if (numberOfElements > 0) {
        todayDate = todayDate.add(Duration(days: numberOfElements * 365));
      }
    }

    if (weekDay != null) {
      while (weekDays[todayDate.weekday].toUpperCase() != weekDay.toUpperCase()) {
        if (numberOfElements > 0) {
          todayDate = todayDate.add(Duration(days: 1));
        }
      }
    }

    return todayDate;
  }

  static DateTime getBeginingOfPeriod(DateTime todayDate, int numberOfElements, DateElementType elementType, {String? weekDay}) {
    if (elementType == DateElementType.day) {
      if (numberOfElements > 0) {
        todayDate = todayDate.subtract(Duration(days: numberOfElements));
      }
    } else if (elementType == DateElementType.week) {
      if (numberOfElements > 0) {
        todayDate = todayDate.subtract(Duration(days: numberOfElements * 7));
      }
    } else if (elementType == DateElementType.month) {
      if (numberOfElements > 0) {
        todayDate = todayDate.subtract(Duration(days: numberOfElements * 30));
      }
    } else if (elementType == DateElementType.year) {
      if (numberOfElements > 0) {
        todayDate = todayDate.subtract(Duration(days: numberOfElements * 365));
      }
    }

    if (weekDay != null) {
      while (weekDays[todayDate.weekday - 1].toUpperCase() != weekDay.toUpperCase()) {
        if (numberOfElements > 0) {
          todayDate = todayDate.subtract(Duration(days: 1));
        }
      }
    }

    return todayDate;
  }

  static DateTime decrementMonth(DateTime date) {
    // Extract components
    int year = date.year;
    int month = date.month - 1; // Subtract 1 month
    int day = date.day;

    // Handle month rollover
    if (month == 0) {
      year -= 1; // Go to previous year
      month = 12; // Set to December
    }

    // Get the last day of the target month to handle invalid days (e.g., 31st)
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth; // Adjust day if it exceeds the month's max
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second, date.millisecond);
  }

  static DateTime incrementMonth(DateTime date) {
    // Extract components
    int year = date.year;
    int month = date.month + 1; // Add 1 month
    int day = date.day;

    // Handle month rollover
    if (month == 13) {
      year += 1; // Go to next year
      month = 1; // Set to January
    }

    // Get the last day of the target month to handle invalid days (e.g., 31st)
    int lastDayOfMonth = DateTime(year, month + 1, 0).day;
    if (day > lastDayOfMonth) {
      day = lastDayOfMonth; // Adjust day if it exceeds the month's max
    }

    return DateTime(year, month, day, date.hour, date.minute, date.second, date.millisecond);
  }

  static DateTime getEndOfPeriodWithoutWeekendsAndHolidays(DateTime startDate, int numberOfDays, List<HolidayDayDTO> holidayDayList) {
    int nextYear = startDate.year;
    int nextDay = startDate.day;
    int nextMonth = startDate.month;

    int holidayCount = performHoldayCount(numberOfDays, holidayDayList, nextYear, nextMonth, nextDay);

    return getEndOfPeriodWithoutWeekends(startDate, numberOfDays + holidayCount);
  }

  static DateTime getEndOfPeriodWithoutWeekends(DateTime currentDate, int numberOfDays) {
    DateTime? localDate;

    int nextYear = currentDate.year;
    int nextDay = currentDate.day;
    int nextMonth = currentDate.month;

    int counter = 0;
    while (counter <= numberOfDays - 1) {
      localDate = DateTime(nextYear, nextMonth, nextDay);

      if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
        if ((localDate.weekday != weekdaySaturday) && (localDate.weekday != weekdaySunday)) {
          nextDay++;
          counter++;

          localDate = DateTime(nextYear, nextMonth, nextDay);
          if ((localDate.weekday == weekdaySaturday) || (localDate.weekday == weekdaySunday)) {
            int weekEndLen = (localDate.weekday == weekdaySaturday) ? 2 : 1;

            for (int weekDay = 0; weekDay <= weekEndLen - 1; weekDay++) {
              if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
                nextDay++;
              } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
                if (nextMonth < maxMonths) {
                  nextMonth++;
                  nextDay = 1;
                } else if (nextMonth == maxMonths) {
                  nextYear++;
                  nextMonth = 1;
                  nextDay = 1;
                }
              }
            }
          }
        } else {
          int weekEndLen = (localDate.weekday == weekdaySaturday) ? 2 : 1;

          for (int weekDay = 0; weekDay <= weekEndLen - 1; weekDay++) {
            if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
              nextDay++;
            } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
              if (nextMonth < maxMonths) {
                nextMonth++;
                nextDay = 1;
              } else if (nextMonth == maxMonths) {
                nextYear++;
                nextMonth = 1;
                nextDay = 1;
              }
            }
          }
        }
      } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
        if ((localDate.weekday != weekdaySaturday) && (localDate.weekday != weekdaySunday)) {
          if (nextMonth < maxMonths) {
            nextMonth++;
            nextDay = 1;
          } else if (nextMonth == maxMonths) {
            nextYear++;
            nextMonth = 1;
            nextDay = 1;
          }
          counter++;
        } else if ((localDate.weekday == weekdaySaturday) || (localDate.weekday == weekdaySunday)) {
          if (nextMonth < maxMonths) {
            nextMonth++;

            int? weekEndLen = (localDate.weekday == weekdaySaturday) ? 3 : 2;
            nextDay = weekEndLen;
          } else if (nextMonth == maxMonths) {
            nextYear++;
            nextMonth = 1;

            int? weekEndLen = (localDate.weekday == weekdaySaturday) ? 3 : 2;
            nextDay = weekEndLen;
          }
        }
      }
    }

    localDate = DateTime(nextYear, nextMonth, nextDay);

    return localDate;
  }

  static int performHoldayCount(int numberOfDays, List<HolidayDayDTO> holidayDayList, int nextYear, int nextMonth, int nextDay) {
    int holidayCount = 0;

    DateTime currentDate = DateTime(nextYear, nextMonth, nextDay);

    int counter = 0;
    while (counter <= numberOfDays) {
      DateTime localDate = DateTime(nextYear, nextMonth, nextDay);

      if ((localDate.weekday != weekdaySaturday) && (localDate.weekday != weekdaySunday)) {
        if (isHoliday(localDate, holidayDayList, false)) {
          if (!isSameDateObj(currentDate, localDate)) {
            holidayCount++;
          }
        }
      } else if (isHoliday(localDate, holidayDayList, true)) {
        if (!isSameDateObj(currentDate, localDate)) {
          holidayCount++;
        }
      }

      if (nextDay < getDaysOfMonth(nextMonth, nextYear)) {
        nextDay++;
      } else if (nextDay == getDaysOfMonth(nextMonth, nextYear)) {
        if (nextMonth < maxMonths) {
          nextMonth++;
          nextDay = 1;
        } else if (nextMonth == maxMonths) {
          nextYear++;
          nextMonth = 1;
          nextDay = 1;
        }
      }

      counter++;
    }

    return holidayCount;
  }

  static bool isHoliday(DateTime localDate, List<HolidayDayDTO> holidayDayList, bool isWeekend) {
    bool foundMatch = false;

    for (HolidayDayDTO holiday in holidayDayList) {
      if (holiday.holidayOrientType == HolidayOrientType.fixedAnnualDate) {
        foundMatch = isSameDateByMonthAndDay(localDate, DateUtil.parseDate(holiday.holidayDate)!);
        if ((isWeekend) && (holiday.weekendRecognitionType == HolidayWeekendRecognitionType.sameDay)) {
          foundMatch = false;
        }
      } else if ((holiday.holidayOrientType == HolidayOrientType.variableAnnualDate) || (holiday.holidayOrientType == HolidayOrientType.oneOffDate)) {
        foundMatch = isSameDate(getStandardDate(localDate), holiday.holidayDate);

        if ((isWeekend) && (holiday.weekendRecognitionType == HolidayWeekendRecognitionType.sameDay)) {
          foundMatch = false;
        }
      }
    }

    return foundMatch;
  }

  static bool isSameDateByMonthAndDay(DateTime date1, DateTime date2) {
    int day1 = date1.day;
    int month1 = date1.month;

    int day2 = date2.day;
    int month2 = date2.month;

    return ((month1 == month2) && (day1 == day2));
  }

}
