import 'package:flutter/material.dart';
import 'package:servicios/screens/docente/calendarioTD.dart';
import 'package:servicios/screens/docente/grupalTD.dart';
import 'package:servicios/screens/docente/individualTD.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TutoriaDScreenD(),
    );
  }
}

class TutoriaDScreenD extends StatelessWidget {
  final double _buttonMargin = 30.0;
  final double _buttonWidth = double.infinity - 40.0;
  final double _iconSize = 80.0;
  final double _textSize = 20.0;
  final double _titlePadding = 20.0;
  final double _verticalSpacing = 10.0;
  final double _borderRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorías Académicas'),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: _verticalSpacing),
          _buildSectionTitle('Tipo de tutoría'),
          SizedBox(height: _verticalSpacing),
          _buildSectionButton(
            context,
            'Tutoría individual',
            Icons.person,
            const Color.fromRGBO(18, 182, 207, 1),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IndividualTutoriaScreen(),
                ),
              );
            },
          ),
          SizedBox(height: _verticalSpacing),
          _buildSectionButton(
            context,
            'Tutoría grupal',
            Icons.group,
            const Color.fromRGBO(18, 182, 207, 1),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GrupalTutoriaScreen(),
                ),
              );
            },
          ),
          SizedBox(height: _verticalSpacing * 3),
          _buildSectionTitle('Calendario de sesiones de tutoría'),
          SizedBox(height: _verticalSpacing),
          _buildSectionButton(
            context,
            'Calendario de sesiones',
            Icons.calendar_month,
            const Color.fromRGBO(48, 159, 219, 1),
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CalendarioTutoriaScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: _titlePadding),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: _textSize,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: _buttonMargin),
        width: _buttonWidth,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: _iconSize,
            ),
            SizedBox(height: _verticalSpacing),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: _textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
