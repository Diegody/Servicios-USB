import 'package:flutter/material.dart';

class CalendarioTutoriaScreen extends StatefulWidget {
  @override
  _CalendarioTutoriaScreenState createState() =>
      _CalendarioTutoriaScreenState();
}

class _CalendarioTutoriaScreenState extends State<CalendarioTutoriaScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario'),
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
    );
  }
}
