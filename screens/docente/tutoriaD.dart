import 'package:flutter/material.dart';
import 'package:servicios/auth.dart';
import 'package:servicios/globals.dart';
import 'package:servicios/screens/docente/calendarioTD.dart';
import 'package:servicios/screens/docente/grupalTD.dart';
import 'package:servicios/screens/docente/individualTD.dart';
import 'package:servicios/screens/login.dart';
import 'horarioD.dart';

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
      drawer: MyDrawer(),
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
            () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                    ),
                  );
                },
              );

              await Future.delayed(Duration(seconds: 2));

              Navigator.pop(context);

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
                  builder: (context) => CalendarioTD(),
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

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo_acreditacion.png',
                        width: 300.0,
                        height: 100.0,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        globalUsername ?? 'Nombre de Usuario',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text('Horario de Clases'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HorarioDScreenD()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Tutorías Académicas'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TutoriaDScreenD()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Cerrar Sesión'),
                  onTap: () {
                    Navigator.pop(context);
                    AuthManager.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cerrando sesión...'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.0),
            color: Colors.orange,
            child: Text(
              appVersion,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
