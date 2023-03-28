import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(const VisibleAppointments());

class VisibleAppointments extends StatelessWidget {
  const VisibleAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => ScheduleExample();
}

class ScheduleExample extends State<MyApp> {
  List<Meeting>? _appointments;
  List<Appointment>? _visibleAppointments = <Appointment>[];
  final List<String> _subjectCollection = <String>[];
  late _MeetingDataSource _events;
  final List<Color> _colorCollection = <Color>[];

  @override
  void initState() {
    _appointments = _addAppointment();
    _events = _MeetingDataSource(_appointments!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TextButton(
                onPressed: _showDialog,
                child: const Text('Get visible appointments'),
              ),
              Expanded(
                child: Scrollbar(
                  child: SfCalendar(
                    view: CalendarView.month,
                    dataSource: _events,
                    onViewChanged: viewChanged,
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    List<DateTime> date = viewChangedDetails.visibleDates;
    _visibleAppointments =
        _events.getVisibleAppointments(date[0], '', date[date.length - 1]);
  }

  Future<void> _showDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Visible dates contains " +
              _visibleAppointments!.length.toString() +
              " appointments"),
          contentPadding: const EdgeInsets.all(16.0),
          content: Container(
            width: 800,
            height: 800,
            child: ListView.builder(
                itemCount: _visibleAppointments!.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    child: Container(
                        color: _visibleAppointments![index].color,
                        child: Text(_visibleAppointments![index].subject)),
                  );
                }),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<Meeting> _addAppointment() {
    final List<Meeting> meetingCollection = <Meeting>[];
    _subjectCollection.add('Meeting');
    _subjectCollection.add('Planning');
    _subjectCollection.add('Project Plan');
    _subjectCollection.add('Consulting');
    _subjectCollection.add('Support');
    _subjectCollection.add('Testing');
    _subjectCollection.add('Scrum');
    _subjectCollection.add('Documentation');
    _subjectCollection.add('Release');
    _subjectCollection.add('Performance');

    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));

    final DateTime today = DateTime.now();
    final DateTime rangeStartDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: -500));
    final DateTime rangeEndDate = DateTime(today.year, today.month, today.day)
        .add(const Duration(days: 500));
    Random random = Random();
    for (DateTime i = rangeStartDate;
    i.isBefore(rangeEndDate);
    i = i.add(const Duration(days: 1))) {
      final DateTime date = i;
      for (int j = 0; j < 2; j++) {
        final DateTime startDate =
        DateTime(date.year, date.month, date.day, 2, 0, 0);
        meetingCollection.add(Meeting(
            _subjectCollection[random.nextInt(10)],
            startDate,
            startDate.add(const Duration(hours: 1)),
            _colorCollection[random.nextInt(10)],
            false));
      }
    }
    return meetingCollection;
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(this.source);

  List<Meeting> source;

  @override
  List<dynamic> get appointments => source;

  @override
  DateTime getStartTime(int index) {
    return source[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return source[index].to;
  }

  @override
  bool isAllDay(int index) {
    return source[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return source[index].eventName;
  }

  @override
  Color getColor(int index) {
    return source[index].background;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}