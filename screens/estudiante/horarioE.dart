import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE.dart';
import 'icetexE.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HorarioEScreenE(),
    );
  }
}

class HorarioEScreenE extends StatefulWidget {
  @override
  _HorarioEScreenEState createState() => _HorarioEScreenEState();
}

class _HorarioEScreenEState extends State<HorarioEScreenE> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _originalHorarioData = [];
  List<dynamic> _filteredHorarioData = [];
  CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    _fetchHorarioData();
  }

  void _fetchHorarioData() async {
    try {
      final String codigo = globalCodigoEstudiante;
      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Horarios/Horario.php'),
        body: {'Codigo': codigo},
      );

      if (response.statusCode == 200) {
        List<dynamic> horarioData = json.decode(response.body);

        setState(() {
          _originalHorarioData = horarioData;
          _filteredHorarioData = horarioData;
        });
      } else {
        throw Exception('Error al cargar el horario');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _filterHorarioData(String query) {
    setState(() {
      _filteredHorarioData = _originalHorarioData
          .where((horario) =>
              horario['DATOS'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horario de Clases'),
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
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterHorarioData,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SfCalendar(
            view: CalendarView.month,
            controller: _calendarController,
            // Personaliza la apariencia del calendario según tus necesidades
          ),
          Expanded(
            child: _buildHorarioList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHorarioList() {
    if (_filteredHorarioData.isEmpty) {
      return Center(child: Text('No hay datos disponibles'));
    }

    return ListView.builder(
      itemCount: _filteredHorarioData.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(
              _filteredHorarioData[index]['DATOS'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Día: ${_filteredHorarioData[index]['FECHA_INICIO_DIA']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hora: ${_filteredHorarioData[index]['FECHA_INICIO']} - ${_filteredHorarioData[index]['FECHA_FIN']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
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
                      // Imagen en el DrawerHeader
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
                    // Acción al hacer clic en "Horario de Clases"
                    Navigator.pop(context); // Cierra el Drawer

                    // Dirigirse a la nueva actividad (ventana)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HorarioEScreenE()), // Reemplaza 'HorarioScreen' con el nombre de tu nueva actividad
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Solicitar Tutoría'),
                  onTap: () {
                    // Acción al hacer clic en "Horarios de Tutorías"
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TutoriaEScreenE()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.attach_money),
                  title: Text('Simulador Financiero'),
                  onTap: () {
                    // Acción al hacer clic en "Simulador Financiero"
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SimuladorEScreenE()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.rotate_left),
                  title: Text('Renovación ICETEX'),
                  onTap: () {
                    // Acción al hacer clic en "Renovación ICETEX"
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IcetexEScreenE()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.check),
                  title: Text('Crédito Directo USB'),
                  onTap: () {
                    // Acción al hacer clic en "Crédito Directo USB"
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreditoEScreenE()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Restablecer Credenciales'),
                  onTap: () {
                    // Acción al hacer clic en "Restablecer Credenciales"
                    Navigator.pop(context); // Cierra el Drawer
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CredencialesEScreenE()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Cerrar Sesión'),
                  onTap: () {
                    // Cierra el Drawer
                    Navigator.pop(context);
                    // Cierra la sesión utilizando el AuthManager
                    AuthManager.logout();
                    // Redirige al usuario a la pantalla de inicio de sesión
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
          // Información adicional en toda la base del menú con las mismas propiedades
          Container(
            width: double.infinity, // Ancho máximo posible
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
