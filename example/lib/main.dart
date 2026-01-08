import 'package:dynamo_data_table/dynamo/project/commons/system/entities/message_type.dart';
import 'package:dynamo_data_table/dynamo/project/commons/system/handlers/dynamo_commons.dart';
import 'package:dynamo_data_table/dynamo/project/commons/views/table_widget_commons.dart';
import 'package:dynamo_data_table/dynamo_calendar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamo Calendar Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // HomeScreen now sits "below" MaterialApp, so it has access to Material context
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarViewMode _currentMode = CalendarViewMode.datePicker;
  final TextEditingController dateTextFilter = TextEditingController();
  //
  DateTime? selectedDate;
  TimeOfDay? selectedTimeOfDay = TimeOfDay.now();
  int _counter = 0;

  final List<Event> myCalendarEvents = [
    Event(0, 'Sales Meeting', DateTime(2026, 1, 10), fromTime: const TimeOfDay(hour: 9, minute: 0)),
    Event(0, 'Engineering Review Meeting', DateTime(2026, 1, 10), fromTime: const TimeOfDay(hour: 14, minute: 30)),
    Event(0, 'Client Disbursement', DateTime(2026, 1, 15), fromTime: const TimeOfDay(hour: 11, minute: 0)),
    Event(0, 'Recruitment Review', DateTime(2026, 1, 15),
        fromTime: const Size.fromHeight(16).height.toInt() == 0 ? const TimeOfDay(hour: 16, minute: 0) : const TimeOfDay(hour: 16, minute: 0)),
    Event(0, 'KPMG Audit', DateTime(2026, 1, 20), fromTime: const TimeOfDay(hour: 10, minute: 0)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamo Calendar Demo'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65.0),
          child: Container(
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            child: DropdownButton<CalendarViewMode>(
              value: _currentMode,
              icon: const Icon(Icons.calendar_month, color: Colors.deepPurple),
              underline: const SizedBox.shrink(),
              onChanged: (CalendarViewMode? newValue) {
                if (newValue != null) {
                  setState(() => _currentMode = newValue);
                }
              },
              items: CalendarViewMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(mode.name.toUpperCase()),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      // Added SingleChildScrollView to fix the "RenderFlex overflow" error
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: <Widget>[
                buildDynamoCalendar(context),
                if (_currentMode == CalendarViewMode.scheduler) ...[
                  SizedBox(
                    height: 20,
                  ),
                  createScheduler(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDynamoCalendar(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.9 : 0.6),
      child: TextField(
        controller: dateTextFilter,
        readOnly: true,
        style: const TextStyle(fontFamily: 'Montserrat', fontSize: 17.0),
        onTap: () {
          switch (_currentMode) {
            case CalendarViewMode.datePicker:
              createDatePicker();
            case CalendarViewMode.dateAndTimePicker:
              createDateTimePicker();
            case CalendarViewMode.timePicker:
              createTimePicker();
            case CalendarViewMode.scheduler:
              createScheduler();
          }
        },
        decoration: const InputDecoration(
          labelText: 'Select Date/Time',
          hintText: 'Click to open calendar',
          prefixIcon: Icon(Icons.event),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  // Helper to update text and state
  void _updateText(String text) {
    setState(() {
      dateTextFilter.text = text;
    });
  }

  void createDatePicker() async {
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
  }

  void createDateTimePicker() async {
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
  }

  void createTimePicker() async {
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
  }

  Widget createScheduler() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (DynamoCommons.isMobile(context) ? 0.94 : 0.6),
      child: DynamoCalendar(
        calendarMode: CalendarMode.scheduler,
        selectedDate: selectedDate,
        calendarEvents: myCalendarEvents,
        onShowDetailsPressed: (events) => _showEventDetails(context, events),
        onDateSelected: (date) {
          // Navigator logic for new event
        },
      ),
    );
  }

  void _showEventDetails(BuildContext context, List<Event> eventList) {
    // This simply displays one item in the day's activities.
    // You should create a more robust widget to display
    if (eventList.isEmpty) return;
    TableWidgetCommons.showMessageAlert(
      context,
      "Event: ${eventList.first.title}",
      "From: ${DateUtil.getStandardDate(eventList.first.fromDate)} To: ${eventList.first.toDate ?? ''}",
      messageType: MessageType.info,
    );
  }
}

enum CalendarViewMode { datePicker, timePicker, dateAndTimePicker, scheduler }
