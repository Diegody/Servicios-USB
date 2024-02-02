import 'package:flutter/material.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE.dart';
import 'horarioE.dart';
import 'icetexE.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenE(),
    );
  }
}

class HomeScreenE extends StatelessWidget {
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
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                // Ajusta el espacio horizontal
                child: Text(
                  'La aplicación "Servicios USB" ha sido diseñada para facilitar la interacción y '
                  'el acceso a información relevante para los estudiantes y docentes de la '
                  'Universidad de San Buenaventura Bogotá. Con una interfaz intuitiva y funciones '
                  'específicas, la aplicación ofrece diversas herramientas y servicios para mejorar '
                  'la experiencia académica.',
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
