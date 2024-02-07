import 'package:flutter/material.dart';
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

class TutoriaDScreenD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Petición de Tutorías'),
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
      drawer: MyDrawer(), // Agrega el Drawer a la interfaz
      body: Center(
        child: Text('Docente Petición de Tutorías'),
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
                      MaterialPageRoute(
                          builder: (context) => HorarioDScreenD()),
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
                      MaterialPageRoute(
                          builder: (context) => TutoriaDScreenD()),
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
