import 'package:flutter/material.dart';
import 'package:servicios/screens/docente/tutoriaD.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'horarioD.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenD(),
    );
  }
}

class HomeScreenD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
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
      body: ClipPath(
        clipper: MyClipper(),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.5,
          width: MediaQuery.of(context).size.width / 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange, Colors.yellow],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logousb.png',
                height: 200,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0), // Ajusta el espacio horizontal
                child: Text(
                  'La aplicación "Servicios USB" ha sido diseñada para facilitar la interacción y '
                  'el acceso a información relevante para los estudiantes y docentes de la '
                  'Universidad de San Buenaventura Bogotá. Usted como docente, tendrá la posibilidad'
                  'de vizualizar su horario de clases y las solicitudes de tutorias emitidas por los estudiantes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Centra el texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width * 0.7, size.height, size.width, size.height * 0.95);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
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
