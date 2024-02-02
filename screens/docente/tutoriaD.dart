import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:http/http.dart' as http;
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
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

class TutoriaDScreenD extends StatefulWidget {
  @override
  _TutoriaDScreenDState createState() => _TutoriaDScreenDState();
}

class _TutoriaDScreenDState extends State<TutoriaDScreenD> {
  List<Map<String, dynamic>> tutorias = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Llamar a la función al iniciar la pantalla
  }

  Future<void> fetchData() async {
    final String codigo = globalCodigoDocente;
    final url =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/TutoriasDisponibles.php';
    final response = await http.post(
      Uri.parse(url),
      body: {'CREDENCIALES': codigo},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final Map<String, dynamic> resulta = data.first;
      final String conteo = resulta['CONTEO'];

      setState(() {
        isLoading = false;

        if (conteo == 'NO') {
          // No hay tutorías, no se actualiza la lista
        } else {
          tutorias = List<Map<String, dynamic>>.from(data);
        }
      });
    } else {
      // Manejar el error de la solicitud
      print('Error en la solicitud al servidor');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Petición de Tutorias'),
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : tutorias.isEmpty
              ? Center(
                  child: Container(
                    child: Text(
                      'Por ahora no tiene tutorías pendientes',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: tutorias.length,
                  itemBuilder: (context, index) {
                    final tutoria = tutorias[index];
                    return Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 4.0,
                      child: ListTile(
                        title: Text(tutoria['DATOS'] ?? 'Sin datos'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: ${tutoria['FECHA_TUTORIA'] ?? ''}'),
                            Text('Hora: ${tutoria['HORA'] ?? ''}'),
                            Text('Sesiones: ${tutoria['NUM_SESIONES'] ?? ''}'),
                            Text('Curso: ${tutoria['NOMBREDELCURSO'] ?? ''}'),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HorarioDScreenD()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.group),
            title: Text('Petición de Tutorías'),
            onTap: () {
              // Acción al hacer clic en "Horarios de Tutorías"
              Navigator.pop(context); // Cierra el Drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TutoriaDScreenD()),
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
            },
          ),
        ],
      ),
    );
  }
}
