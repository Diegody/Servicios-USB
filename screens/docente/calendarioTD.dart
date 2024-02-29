import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(CalendarioD());

class CalendarioD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenD(),
    );
  }
}

class HomeScreenD extends StatefulWidget {
  @override
  _HomeScreenDState createState() => _HomeScreenDState();
}

class _HomeScreenDState extends State<HomeScreenD> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  // ignore: unused_field
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Tutorías'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.orange,
                width: 2.5,
              ),
            ),
            child: TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2034, 12, 31),
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarBuilders: CalendarBuilders(
                selectedBuilder: (context, date, focused) {
                  final isToday = isSameDay(date, DateTime.now());
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.orange,
                        width: 2.0,
                      ),
                      color: isToday ? Colors.orange : null,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        color: isToday ? Colors.white : Colors.orange,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Aquí puedes mostrar las tutorías del día seleccionado en el calendario
          // Puedes utilizar una lista, un ListView, etc.
        ],
      ),
    );
  }
}
