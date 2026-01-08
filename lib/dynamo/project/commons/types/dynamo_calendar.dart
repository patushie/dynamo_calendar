// ignore_for_file: comment_references

import 'package:dynamo_data_table/dynamo/project/commons/system/handlers/date_util.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/handlers/dynamo_commons.dart';
import 'package:dynamo_data_table/dynamo/project/commons/views/table_widget_commons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'calendar_day.dart';

/// Calender widget. Create calender in different modes:
/// (1) Datepicker
/// (2) Timepicker
/// (3) Date & Time Picker
/// (4) Scheduler
class DynamoCalendar extends StatefulWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final CalendarMode? calendarMode;
  final List<Event>? calendarEvents;
  final Color? dropdownColor;
  final Color? widgetIconColor;
  //
  final Function(DateTime?)? onDateSelected;
  final Function(TimeOfDay?)? onTimeSelected;
  final Function(List<Event>)? onShowDetailsPressed;
  final Function(DateTime)? onMonthNavigated;

  const DynamoCalendar({
    super.key,
    this.selectedDate,
    this.selectedTime,
    this.onDateSelected,
    this.onTimeSelected,
    this.calendarMode,
    this.calendarEvents,
    this.onShowDetailsPressed,
    this.onMonthNavigated,
    this.dropdownColor,
    this.widgetIconColor,
  });

  @override
  State<DynamoCalendar> createState() => _DynamoCalendarState();
}

/// Calender modes enum
enum CalendarMode {
  datePicker("DATE PICKER"),

  dateAndTimePicker("DATE AND TIME PICKER"),

  scheduler("SCHEDULER"),

  timePicker("TIME PICKER");

  final String enumValue;

  const CalendarMode(this.enumValue);

  factory CalendarMode.fromPosition(int ordinalValue) {
    return values.firstWhere((e) => e.index == ordinalValue);
  }

  factory CalendarMode.fromName(String stringValue) {
    if (stringValue.isNotEmpty) {
      return values.firstWhere((e) => e.enumValue.toUpperCase() == stringValue.toUpperCase());
    } else {
      return datePicker;
    }
  }

  @override
  String toString() {
    return enumValue;
  }
}

class _DynamoCalendarState extends State<DynamoCalendar> {
  CalendarMode _currentMode = CalendarMode.datePicker;

  DateTime? _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime = TimeOfDay.now();

  int calendarFirstYear = 0;
  int calendarLastYear = 0;

  double widgetHeightScale = 0;
  double widgetWidthScale = 0;

  bool _is24HourFormat = false; // Default to 12-hour format
  String _meridiem = DateTime.now().hour >= 12 ? 'PM' : 'AM'; // Default to AM for 12-hour mode
  CalendarFormat _calendarFormat = CalendarFormat.month;

  int selectedHour = 1;
  bool stateInitialized = false;

  List<Event> _events = [
    Event(0, 'Sales Meeting', DateTime(2026, 1, 10), fromTime: const TimeOfDay(hour: 9, minute: 0)),
    Event(0, 'Engineering Review Meeting', DateTime(2026, 1, 10), fromTime: const TimeOfDay(hour: 14, minute: 30)),
    Event(0, 'Client Disbursement', DateTime(2026, 1, 15), fromTime: const TimeOfDay(hour: 11, minute: 0)),
    Event(0, 'Recruitment Review', DateTime(2026, 1, 15),
        fromTime: const Size.fromHeight(16).height.toInt() == 0 ? const TimeOfDay(hour: 16, minute: 0) : const TimeOfDay(hour: 16, minute: 0)),
    Event(0, 'KPMG Audit', DateTime(2026, 1, 20), fromTime: const TimeOfDay(hour: 10, minute: 0)),
  ];

  @override
  Widget build(BuildContext context) {
    widgetHeightScale = DynamoCommons.isMobile(context) ? 0.6 : 0.57;
    widgetWidthScale = DynamoCommons.isMobile(context) ? 0.7 : 0.2;

    if (widget.calendarMode != null) {
      _currentMode = widget.calendarMode!;
    }

    if (_currentMode == CalendarMode.scheduler) {
      widgetHeightScale = DynamoCommons.isMobile(context) ? 0.7 : 0.75;
      widgetWidthScale = DynamoCommons.isMobile(context) ? 0.85 : 0.50;
    } else if (_currentMode == CalendarMode.dateAndTimePicker) {
      widgetHeightScale = DynamoCommons.isMobile(context) ? 0.7 : 0.72;
    }

    if (widget.selectedDate != null) {
      _selectedDate = widget.selectedDate!;
    }

    if (!stateInitialized) {
      if (widget.selectedTime != null) {
        _selectedTime = widget.selectedTime!;
      }
    }

    stateInitialized = true;

    if (_currentMode == CalendarMode.scheduler) {
      if (widget.calendarEvents != null) {
        _events = widget.calendarEvents!;
      }

      return _buildScheduler(context);
    } else {
      Widget calendarWidget = Scaffold(
        appBar: AppBar(
          actions: widget.calendarMode != null
              ? null
              : [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<CalendarMode>(
                      value: _currentMode,
                      items: CalendarMode.values
                          .map((mode) => DropdownMenuItem(
                                value: mode,
                                child: Text(
                                  mode.toString().split('.').last,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ))
                          .toList(),
                      onChanged: (mode) {
                        if (mode != null) {
                          setState(() => _currentMode = mode);
                        }
                      },
                      dropdownColor: widget.dropdownColor ?? Colors.white,
                    ),
                  ),
                ],
        ),
        body: _buildModeContent(context, !DynamoCommons.isMobile(context)),
      );

      return AlertDialog(
        title: Center(child: Text('Calendar')),
        semanticLabel: "Label1",
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.15 : 0.075),
              right: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.15 : 0.075),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                TableWidgetCommons.getFineRoundedButton(
                  "Clear",
                  () {
                    _selectedDate = null;

                    if (widget.onDateSelected != null) {
                      widget.onDateSelected!(_selectedDate);
                    }

                    Navigator.pop(context);
                  },
                  Icon(
                    Icons.brush,
                    color: widget.widgetIconColor ?? Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
        content: SizedBox(
          height: MediaQuery.of(context).size.height * widgetHeightScale,
          width: MediaQuery.of(context).size.width * widgetWidthScale,
          child: calendarWidget,
        ),
      );
    }
  }

  Widget _buildModeContent(BuildContext context, bool isDesktop) {
    switch (_currentMode) {
      case CalendarMode.datePicker:
        return _buildDatePicker(context, isDesktop);
      case CalendarMode.timePicker:
        return _buildTimePicker(context, isDesktop);
      case CalendarMode.dateAndTimePicker:
        return _buildDatePicker(context, isDesktop, includeTimepicker: true);
      case CalendarMode.scheduler:
        return _buildScheduler(context);
    }
  }

  Widget _buildDatePicker(BuildContext context, bool isDesktop, {bool includeTimepicker = false}) {
    DateTime currentDate = DateTime.now();

    List<int> pickableHours = _is24HourFormat ? List.generate(24, (i) => i) : List.generate(12, (i) => i + 1);
    int selectedHour = _is24HourFormat ? _selectedTime!.hour : (_selectedTime!.hour > 12 ? _selectedTime!.hour - 12 : _selectedTime!.hour);

    if (_selectedDate!.year > 0) {
      if (calendarFirstYear == _selectedDate!.year) {
        calendarFirstYear = _selectedDate!.year - 50;
      } else if (calendarFirstYear == 0) {
        calendarFirstYear = currentDate.year - 50;
      }

      if (calendarLastYear == _selectedDate!.year + 1) {
        calendarLastYear = _selectedDate!.year + 50;
      } else if (calendarLastYear == 0) {
        calendarLastYear = currentDate.year + 50;
      }
    } else {
      calendarFirstYear = currentDate.year - 50;
      calendarLastYear = currentDate.year + 50;
    }

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(calendarFirstYear, 1, 1),
          lastDay: DateTime.utc(calendarLastYear, 12, 31),
          focusedDay: _selectedDate!,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
          calendarFormat: _calendarFormat,
          onDaySelected: (selectedDay, focusedDay) {
            if (widget.onDateSelected != null) {
              if (widget.calendarMode == CalendarMode.dateAndTimePicker) {
                selectedDay = DateUtil.setDateTime(selectedDay, _selectedTime!.hour, _selectedTime!.minute);
              }

              widget.onDateSelected!(selectedDay);
            }

            Navigator.pop(context);

            setState(() {
              _selectedDate = selectedDay;
              _calendarFormat = CalendarFormat.month;
            });
          },
          onFormatChanged: (format) {
            setState(() => _calendarFormat = format);
          },
          calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.all(isDesktop ? 8 : 4),
            todayDecoration: BoxDecoration(
              color: Colors.blueAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TableWidgetCommons.buildSlimDropdown(
                value: _selectedDate!.day,
                items: List.generate(31, (i) => i + 1),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      value!,
                    );
                  });
                },
                label: 'Day',
              ),
              TableWidgetCommons.buildSlimDropdown(
                value: _selectedDate!.month,
                items: List.generate(12, (i) => i + 1),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = DateTime(
                      _selectedDate!.year,
                      value!,
                      _selectedDate!.day,
                    );
                  });
                },
                label: 'Month',
              ),
              TableWidgetCommons.buildSlimDropdown(
                value: _selectedDate!.year,
                items: List.generate(calendarLastYear - calendarFirstYear, (i) => calendarFirstYear + i),
                onChanged: (value) {
                  setState(() {
                    _selectedDate = DateTime(
                      value!,
                      _selectedDate!.month,
                      _selectedDate!.day,
                    );
                  });
                },
                label: 'Year',
              ),
            ],
          ),
        ),
        if (includeTimepicker) ...[
          ...TableWidgetCommons.buildSpacerDividerSet(context),
          SwitchListTile(
            title: Text('Use 24-Hour Format'),
            value: _is24HourFormat,
            onChanged: (value) {
              setState(() {
                _is24HourFormat = value;
                // Adjust hour for format change
                if (!_is24HourFormat && _selectedTime!.hour >= 12) {
                  _meridiem = 'PM';
                  _selectedTime = TimeOfDay(
                    hour: _selectedTime!.hour == 12 ? 12 : _selectedTime!.hour - 12,
                    minute: _selectedTime!.minute,
                  );
                } else if (_is24HourFormat && _meridiem == 'PM' && _selectedTime!.hour < 12) {
                  _selectedTime = TimeOfDay(
                    hour: _selectedTime!.hour + 12,
                    minute: _selectedTime!.minute,
                  );
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableWidgetCommons.buildSlimDropdown(
                value: selectedHour,
                items: pickableHours,
                onChanged: (value) {
                  setState(() {
                    int newHour = value!;

                    if (!_is24HourFormat && _meridiem == 'PM' && newHour < 12) {
                      newHour += 12;
                    } else if (!_is24HourFormat && _meridiem == 'AM' && newHour == 12) {
                      newHour = 0;
                    }

                    _selectedTime = TimeOfDay(
                      hour: newHour,
                      minute: _selectedTime!.minute,
                    );
                  });
                },
                label: 'Hour',
              ),
              SizedBox(
                width: 16,
              ),
              TableWidgetCommons.buildSlimDropdown(
                value: _selectedTime!.minute,
                items: List.generate(60, (i) => i),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: _selectedTime!.hour,
                      minute: value!,
                    );
                  });
                },
                label: 'Minute',
              ),
              if (!_is24HourFormat) ...[
                SizedBox(
                  width: 16,
                ),
                TableWidgetCommons.buildSlimDropdown(
                  value: _meridiem,
                  items: ['AM', 'PM'],
                  onChanged: (value) {
                    setState(() {
                      _meridiem = value!;
                      int newHour = _selectedTime!.hour;
                      if (_meridiem == 'PM' && newHour < 12) {
                        newHour += 12;
                      } else if (_meridiem == 'AM' && newHour >= 12) {
                        newHour -= 12;
                      }
                      _selectedTime = TimeOfDay(
                        hour: newHour,
                        minute: _selectedTime!.minute,
                      );
                    });
                  },
                  label: 'Meridiem',
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTimePicker(BuildContext context, bool isDesktop) {
    List<int> pickableHours = _is24HourFormat ? List.generate(24, (i) => i) : List.generate(12, (i) => i + 1);
    //int selectedHour = _is24HourFormat ? _selectedTime!.hour : (_selectedTime!.hour > 12 ? _selectedTime!.hour - 12 : _selectedTime!.hour);

    if (_selectedTime != null) {
      if (_is24HourFormat) {
        selectedHour = _selectedTime!.hour;
      } else {
        if (_selectedTime!.hour > 12) {
          selectedHour = _selectedTime!.hour - 12;
        } else {
          selectedHour = _selectedTime!.hour;
        }
      }
    } else {
      selectedHour = pickableHours.first;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Selected Time: ${_formatTime(context)}',
            style: TextStyle(fontSize: isDesktop ? 24 : 20),
          ),
          SizedBox(
            height: 20,
          ),
          SwitchListTile(
            title: Text('Use 24-Hour Format'),
            value: _is24HourFormat,
            onChanged: (value) {
              setState(() {
                _is24HourFormat = value;

                if (!_is24HourFormat && _selectedTime!.hour >= 12) {
                  _meridiem = 'PM';
                  _selectedTime = TimeOfDay(
                    hour: _selectedTime!.hour == 12 ? 12 : _selectedTime!.hour - 12,
                    minute: _selectedTime!.minute,
                  );
                } else if (_is24HourFormat && _meridiem == 'PM' && _selectedTime!.hour < 12) {
                  _selectedTime = TimeOfDay(
                    hour: _selectedTime!.hour + 12,
                    minute: _selectedTime!.minute,
                  );
                }
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableWidgetCommons.buildSlimDropdown(
                value: selectedHour,
                items: pickableHours,
                onChanged: (value) {
                  setState(() {
                    int newHour = value!;

                    if (!_is24HourFormat && _meridiem == 'PM' && newHour < 12) {
                      newHour += 12;
                    } else if (!_is24HourFormat && _meridiem == 'AM' && newHour == 12) {
                      newHour = 0;
                    }

                    selectedHour = newHour;

                    _selectedTime = TimeOfDay(
                      hour: newHour,
                      minute: _selectedTime!.minute,
                    );

                    if (widget.onTimeSelected != null) {
                      widget.onTimeSelected!(_selectedTime);
                    }
                  });
                },
                label: 'Hour',
              ),
              SizedBox(
                width: 16,
              ),
              TableWidgetCommons.buildSlimDropdown(
                value: _selectedTime!.minute,
                items: List.generate(60, (i) => i),
                onChanged: (value) {
                  setState(() {
                    _selectedTime = TimeOfDay(
                      hour: _selectedTime!.hour,
                      minute: value!,
                    );

                    if (widget.onTimeSelected != null) {
                      widget.onTimeSelected!(_selectedTime);
                    }
                  });
                },
                label: 'Minute',
              ),
              if (!_is24HourFormat) ...[
                SizedBox(
                  width: 16,
                ),
                TableWidgetCommons.buildSlimDropdown(
                  value: _meridiem,
                  items: ['AM', 'PM'],
                  onChanged: (value) {
                    setState(() {
                      _meridiem = value!;
                      int newHour = _selectedTime!.hour;
                      if (_meridiem == 'PM' && newHour < 12) {
                        newHour += 12;
                      } else if (_meridiem == 'AM' && newHour >= 12) {
                        newHour -= 12;
                      }
                      _selectedTime = TimeOfDay(
                        hour: newHour,
                        minute: _selectedTime!.minute,
                      );

                      if (widget.onTimeSelected != null) {
                        widget.onTimeSelected!(_selectedTime);
                      }
                    });
                  },
                  label: 'Meridiem',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScheduler(BuildContext context) {
    DateTime currentDate = DateTime.now();

    int month = _selectedDate!.month;
    int year = _selectedDate!.year;
    List<CalendarDay> monthDayList = <CalendarDay>[];
    int monthDays = DateUtil.getDaysOfMonth(month, year);

    if (_selectedDate!.year > 0) {
      if (calendarFirstYear == _selectedDate!.year) {
        calendarFirstYear = _selectedDate!.year - 50;
      } else if (calendarFirstYear == 0) {
        calendarFirstYear = currentDate.year - 50;
      }

      if (calendarLastYear == _selectedDate!.year + 1) {
        calendarLastYear = _selectedDate!.year + 50;
      } else if (calendarLastYear == 0) {
        calendarLastYear = currentDate.year + 50;
      }
    } else {
      calendarFirstYear = currentDate.year - 50;
      calendarLastYear = currentDate.year + 50;
    }

    int wkDayCount = 0;
    int firstDayIndex = 0;
    int lastDayIndex = 0;

    for (int day = 1; day <= monthDays; day++) {
      DateTime dateTime = DateTime(_selectedDate!.year, _selectedDate!.month, day);

      String weekdayName = DateFormat('EEEE').format(dateTime).toUpperCase();
      CalendarDay calendarDay = CalendarDay(dayNumber: day, weekDay: weekdayName, dateTime: dateTime);

      monthDayList.add(calendarDay);

      if (day == 1) {
        firstDayIndex = DateUtil.weekDays.indexOf(calendarDay.weekDay!);
      } else if (day == monthDays) {
        lastDayIndex = DateUtil.weekDays.indexOf(calendarDay.weekDay!);
      }

      if (wkDayCount == 6) {
        wkDayCount = 0;
      } else {
        wkDayCount++;
      }
    }

    if (firstDayIndex > 0) {
      for (int i = 1; i <= firstDayIndex; i++) {
        DateTime dateTime = DateTime(_selectedDate!.year, _selectedDate!.month, 1);
        dateTime = dateTime.subtract(Duration(days: i));

        String weekdayName = DateFormat('EEEE').format(dateTime).toUpperCase();

        CalendarDay calendarDay = CalendarDay(
          dayNumber: dateTime.day,
          weekDay: weekdayName,
          activeMonthDay: false,
          dateTime: dateTime,
        );

        monthDayList.insert(0, calendarDay);
      }
    }

    if (lastDayIndex < 6) {
      for (int i = 1; i <= 6 - lastDayIndex; i++) {
        DateTime dateTime = DateTime(_selectedDate!.year, _selectedDate!.month, monthDays);
        dateTime = dateTime.add(Duration(days: i));

        String weekdayName = DateFormat('EEEE').format(dateTime).toUpperCase();

        CalendarDay calendarDay = CalendarDay(
          dayNumber: dateTime.day,
          weekDay: weekdayName,
          activeMonthDay: false,
          dateTime: dateTime,
        );

        monthDayList.add(calendarDay);
      }
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.94 : 0.6),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: widget.widgetIconColor ?? Colors.indigo,
                        size: 20,
                      ),
                      onPressed: () {
                        _selectedDate = DateUtil.decrementMonth(_selectedDate!);

                        if (widget.onMonthNavigated != null) {
                          widget.onMonthNavigated!(_selectedDate!);
                        }

                        setState(() {});
                      },
                      tooltip: "Previous Month",
                    ),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        DynamoCommons.isMobile(context)
                            ? DateUtil.monthShortNames[month - 1]
                            : "${DateUtil.monthNames[month - 1]} ${year.toString()}",
                        style: TextStyle(fontSize: DynamoCommons.isMobile(context) ? 16 : 14),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TableWidgetCommons.buildSlimDropdown(
                        value: _selectedDate!.month,
                        items: List.generate(12, (i) => i + 1),
                        onChanged: (value) {
                          _selectedDate = DateTime(_selectedDate!.year, value!, _selectedDate!.day);

                          if (widget.onMonthNavigated != null) {
                            widget.onMonthNavigated!(_selectedDate!);
                          }

                          setState(() {});
                        },
                        label: 'Month',
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TableWidgetCommons.buildSlimDropdown(
                        value: _selectedDate!.year,
                        items: List.generate(calendarLastYear - calendarFirstYear, (i) => calendarFirstYear + i),
                        onChanged: (value) {
                          _selectedDate = DateTime(value!, _selectedDate!.month, _selectedDate!.day);

                          if (widget.onMonthNavigated != null) {
                            widget.onMonthNavigated!(_selectedDate!);
                          }

                          setState(() {});
                        },
                        label: 'Year',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: widget.widgetIconColor ?? Colors.indigo,
                    size: 20,
                  ),
                  onPressed: () {
                    _selectedDate = DateUtil.incrementMonth(_selectedDate!);

                    if (widget.onMonthNavigated != null) {
                      widget.onMonthNavigated!(_selectedDate!);
                    }

                    setState(() {});
                  },
                  tooltip: "Next Month",
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: DynamoCommons.isMobile(context) ? const EdgeInsets.only(left: 20.0) : const EdgeInsets.only(left: 0.0),
            child: GridView.builder(
              itemCount: DateUtil.weekDays.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: DynamoCommons.isMobile(context) ? 72 : 168,
                crossAxisSpacing: DynamoCommons.isMobile(context) ? 1 : 2,
                mainAxisSpacing: DynamoCommons.isMobile(context) ? 1 : 2,
                mainAxisExtent: DynamoCommons.isMobile(context) ? 30 : 30,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Text(
                  DynamoCommons.isMobile(context) ? DateUtil.weekDaysShort[index] : DateUtil.weekDays[index],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: DynamoCommons.isMobile(context) ? const EdgeInsets.only(left: 20.0) : const EdgeInsets.only(left: 0.0),
            child: GridView.builder(
              itemCount: monthDayList.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: DynamoCommons.isMobile(context) ? 72 : 168,
                crossAxisSpacing: DynamoCommons.isMobile(context) ? 1 : 2,
                mainAxisSpacing: DynamoCommons.isMobile(context) ? 1 : 2,
                mainAxisExtent: DynamoCommons.isMobile(context) ? 70 : 174,
              ),
              itemBuilder: (BuildContext context, int index) {
                return buildDocumentDetail(monthDayList[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDocumentDetail(CalendarDay calendarDay, int index) {
    List<Event> events = _getEventsForDay(calendarDay.dateTime!);
    final maxEvents = DynamoCommons.isMobile(context) ? 3 : 3;

    Column recordColumn = Column(children: <Widget>[
      InkWell(
        onTap: () {
          if (widget.onDateSelected != null) {
            widget.onDateSelected!(calendarDay.dateTime);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.03 : 0.05),
                  child: Text(
                    calendarDay.dayNumber.toString(),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: DynamoCommons.isMobile(context) ? 12.0 : 17.0,
                      color: calendarDay.activeMonthDay! ? Colors.black : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);

    recordColumn.children.add(
      SizedBox(
        height: 4,
      ),
    );

    int eventCount = 0;

    if (DynamoCommons.isMobile(context)) {
      if (events.isNotEmpty) {
        Row calEventRow = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.radio_button_checked,
              size: 15,
              color: Colors.blue,
              semanticLabel: events.first.title,
            ),
          ],
        );

        recordColumn.children.add(
          InkWell(
            onTap: () {
              if (widget.onShowDetailsPressed != null) {
                widget.onShowDetailsPressed!(events);
              }
            },
            child: calEventRow,
          ),
        );
      }
    } else {
      for (Event event in events) {
        recordColumn.children.add(
          _buildEventWidget(context, event, DynamoCommons.isMobile(context)),
        );

        if (eventCount >= maxEvents - 1) {
          break;
        }

        eventCount++;
      }
    }

    if (!DynamoCommons.isMobile(context)) {
      if (events.length > maxEvents) {
        recordColumn.children.add(
          InkWell(
            onTap: () {
              if (widget.onShowDetailsPressed != null) {
                widget.onShowDetailsPressed!(events);
              }
            },
            child: Icon(
              Icons.more_horiz,
              size: DynamoCommons.isMobile(context) ? 14 : 16,
              color: Colors.blue,
              semanticLabel: 'More events',
            ),
          ),
        );
      }
    }

    return Card(
      elevation: 7.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: ListTile(
        title: Container(
          height: MediaQuery.of(context).size.height * (DynamoCommons.isMobile(context) ? 0.16 : 0.16),
          padding: DynamoCommons.isMobile(context) ? const EdgeInsets.all(0) : const EdgeInsets.all(5.0),
          child: recordColumn,
        ),
      ),
    );
  }

  Widget _buildEventWidget(BuildContext context, Event event, bool isMobile) {
    return InkWell(
      onTap: () {
        if (widget.onShowDetailsPressed != null) {
          widget.onShowDetailsPressed!([event]);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(4),
        ),
        child: isMobile
            ? Icon(
                Icons.radio_button_checked,
                size: 12,
                color: Colors.blue,
                semanticLabel: event.title,
              )
            : Text(
                event.title,
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }

  int calculateCalendarRows(int year, int month) {
    DateTime firstDay = DateTime(year, month, 1);
    int firstDayOffset = firstDay.weekday % 7;

    int daysInMonth = DateTime(year, month + 1, 0).day;
    int totalCells = daysInMonth + firstDayOffset;

    return (totalCells / 7).ceil();
  }

  String _formatTime(BuildContext context) {
    if (_is24HourFormat) {
      return _selectedTime!.format(context).replaceAll(RegExp(r'\s*(AM|PM)'), '');
    } else {
      final hour = _selectedTime!.hour == 0
          ? 12
          : _selectedTime!.hour > 12
              ? _selectedTime!.hour - 12
              : _selectedTime!.hour;
      return '$hour:${_selectedTime!.minute.toString().padLeft(2, '0')} $_meridiem';
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) => DateUtil.isSameDateObj(event.fromDate, day)).toList();
  }
}

class Event {
  int? entityRecordID = 0;
  final String title;
  final DateTime fromDate;
  TimeOfDay? fromTime;
  DateTime? toDate;
  TimeOfDay? toTime;
  String? narration;

  Event(this.entityRecordID, this.title, this.fromDate, {this.fromTime, this.toDate, this.toTime, this.narration});

  @override
  String toString() {
    return "{'title': '$title', 'date': '$fromDate', 'time': '$fromTime'}";
  }
}
