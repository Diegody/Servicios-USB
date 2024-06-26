import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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
      home: CredencialesE2ScreenE(
        usuarioAsis: '',
        correoInstitucional: '',
        correoPersonal: '',
        tipo: '',
        documento: '',
        emplid: '',
        fecha: '',
      ),
    );
  }
}

class CredencialesE2ScreenE extends StatelessWidget {
  final String usuarioAsis;
  final String correoInstitucional;

  final String correoPersonal;
  final String tipo;
  final String documento;
  final String emplid;
  final String fecha;

  CredencialesE2ScreenE(
      {required this.usuarioAsis,
      required this.correoInstitucional,
      required this.correoPersonal,
      required this.tipo,
      required this.documento,
      required this.emplid,
      required this.fecha});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Credenciales'),
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
      // drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccione la opción de su interés para restablecer su contraseña. '
              'Recuerde que la clave de acceso al sistema ASIS será notificada a su '
              'correo institucional y su clave de acceso al correo institucional será '
              'enviada al correo personal.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 25),
            Center(
              child: Image.asset(
                'assets/images/logo_usb_completo.png',
                width: 300.0,
                height: 100.0,
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Usuario ASIS: \n $usuarioAsis',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ));
                    },
                  );

                  try {
                    final correoResponse = await http.post(
                      Uri.parse(
                          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Credenciales/CorreoAsis.php'),
                      body: {
                        'USUARIO_ASIS': usuarioAsis,
                        'CORREO_INSTITUCIONAL': correoInstitucional,
                        'CORREO_PERSONAL': correoPersonal,
                        'TIPO': tipo,
                        'DOCUMENTO': documento,
                        'CODIGO': emplid,
                        'FECHA_NACIMIENTO': fecha,
                      },
                    );

                    print(
                        'Demás datos del estudiante (ASIS): \n $correoPersonal, $tipo, $documento, $emplid, $fecha');

                    if (correoResponse.statusCode == 200) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Se ha enviado la nueva contraseña al correo institucional.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          )
                          .closed
                          .then((reason) {
                        Navigator.pop(
                            context); // Cerrar el diálogo de carga después de mostrar el SnackBar
                      });
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al enviar la nueva contraseña al correo.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          )
                          .closed
                          .then((reason) {
                        Navigator.pop(
                            context); // Cerrar el diálogo de carga después de mostrar el SnackBar
                      });
                    }
                  } finally {
                    // Esto se ejecutará incluso si hay un error
                    Navigator.pop(
                        context); // Cerrar el diálogo de carga en caso de error
                  }
                },
                child: Text('Restablecer Usuario ASIS',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size(320, 20)), // Especifica el tamaño deseado
                  backgroundColor: MaterialStateProperty.all(
                      Colors.orange), // Color de fondo del botón
                ),
              ),
            ),
            SizedBox(height: 25),
            Text(
              'Correo Institucional: \n $correoInstitucional',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.orange),
                      ));
                    },
                  );

                  try {
                    final correoResponse = await http.post(
                      Uri.parse(
                          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Credenciales/Correo365.php'),
                      body: {
                        'USUARIO_ASIS': usuarioAsis,
                        'CORREO_INSTITUCIONAL': correoInstitucional,
                        'CORREO_PERSONAL': correoPersonal,
                        'TIPO': tipo,
                        'DOCUMENTO': documento,
                        'CODIGO': emplid,
                        'FECHA_NACIMIENTO': fecha,
                      },
                    );

                    print(
                        'Demás datos del estudiante: \n $correoPersonal, $tipo, $documento, $emplid, $fecha');

                    if (correoResponse.statusCode == 200) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Se ha enviado la nueva contraseña al correo personal.',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          )
                          .closed
                          .then((reason) {
                        Navigator.pop(
                            context); // Cerrar el diálogo de carga después de mostrar el SnackBar
                      });
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error al enviar la nueva contraseña al correo.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          )
                          .closed
                          .then((reason) {
                        Navigator.pop(
                            context); // Cerrar el diálogo de carga después de mostrar el SnackBar
                      });
                    }
                  } finally {
                    // Esto se ejecutará incluso si hay un error
                    Navigator.pop(
                        context); // Cerrar el diálogo de carga en caso de error
                  }
                },
                child: Text(
                  'Restablecer Correo Institucional',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      Size(320, 20)), // Especifica el tamaño deseado
                  backgroundColor: MaterialStateProperty.all(
                      Colors.orange), // Color de fondo del botón
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Si tiene alguna duda o incoveniente, por favor '
              'acerquese a la Unidad de Tecnología ubicada en el Edificio Alberto Montealegre oficina 307. ',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void mostrarSnackBar(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        duration: Duration(seconds: 3),
        backgroundColor:
            Colors.green, // Puedes ajustar el color según tus preferencias
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
                          builder: (context) => HorarioEScreenE()),
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
