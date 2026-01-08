# dynamo_calendar

A powerful, multi-mode Flutter calendar widget designed for flexibility. Whether you need a 
simple date picker, a precise time picker, or a full-scale event scheduler, Dynamo Calendar 
handles the complexity so you can focus on your app's logic.

Optimized for desktop, tablets, and small-screen apps; android, iOS, and web.

[![pub package](https://img.shields.io/pub/v/dynamo_calendar.svg)](https://pub.dev/packages/dynamo_calendar)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## 🌟 Features

Four distinct modes:
   * Simple date selection
   * Time selection only
   * Combined date + time selection
   * Full scheduler with event visualization & interaction

* **📅 Date Picker:** Selection of single dates with a clean, modern UI.
* **⏰ Time Picker:** Precise hour and minute selection.
* **🌓 Date & Time:** Combined picker for appointments and deadlines.
* **🗓️ Scheduler Mode:** View and interact with a list of events assigned to specific dates.
* **📱 Responsive:** Built-in support for both Mobile and Desktop/Web layouts.

## 📦 Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  dynamo_calendar: ^1.0.0
```
Or run:

```flutter pub add dynamo_calendar```

## 🚀 Usage

Import the library

```import 'package:dynamo_calendar/dynamo_calendar.dart';```

Datepicker Example

```
    showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: DynamoCalendar(
          calendarMode: CalendarMode.datePicker,
          selectedDate: selectedDate,
          onDateSelected: (datePicked) {
            selectedDate = datePicked;
            _updateText(selectedDate != null ? DateUtil.getStandardDate(selectedDate) : "");
          },
        ),
      ),
    );
```

Timepicker Example

```
    showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: DynamoCalendar(
          key: ValueKey(++_counter),
          calendarMode: CalendarMode.timePicker,
          selectedTime: selectedTimeOfDay,
          onTimeSelected: (timePicked) {
            selectedTimeOfDay = timePicked;
            _updateText(selectedTimeOfDay?.format(context) ?? "");
          },
        ),
      ),
    );
```

Date & Time Picker Example

```
    showDialog(
      context: context,
      builder: (context) => Material(
        type: MaterialType.transparency,
        child: DynamoCalendar(
          calendarMode: CalendarMode.dateAndTimePicker,
          selectedDate: selectedDate,
          onDateSelected: (datePicked) {
            selectedDate = datePicked;
            _updateText(selectedDate != null ? DateUtil.getStandardDate(selectedDate, verbose: true) : "");
          },
        ),
      ),
    );
```

Scheduler Example

```
      DynamoCalendar(
        calendarMode: CalendarMode.scheduler,
        selectedDate: selectedDate,
        calendarEvents: myCalendarEvents,
        onShowDetailsPressed: (events) => _showEventDetails(context, events),
        onDateSelected: (date) {
          // Navigator logic for new event
        },
      ),
```

Implementation Tips

    ReadOnly TextFields: When using a TextField as a trigger, set readOnly: true. 
    This prevents the system keyboard from overlapping your beautiful calendar.

    Event Handling: In scheduler mode, the onShowDetailsPressed returns a list of events. 
    You can use this to show a detail sheet or a custom popup with event description details.

## 🧪 Example

A complete working example is available in /example, showcasing:

* Datepicker
* Timepicker
* Date & Time Picker
* Scheduler

## 🎥 Demo

![Datepicker](https://raw.githubusercontent.com/patushie/dynamo_calendar/main/assets/date_picker.png)
![Timepicker](https://raw.githubusercontent.com/patushie/dynamo_calendar/main/assets/time_picker.png)
![Date & Time Picker](https://raw.githubusercontent.com/patushie/dynamo_calendar/main/assets/date_time_picker.png)
![Scheduler](https://raw.githubusercontent.com/patushie/dynamo_calendar/main/assets/scheduler.png)

## 📄 License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/patushie/dynamo_calendar/issues).