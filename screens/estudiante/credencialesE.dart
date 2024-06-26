import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE2.dart';
import 'horarioE.dart';
import 'icetexE.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CredencialesEScreenE(),
    );
  }
}

// ignore: must_be_immutable
class CredencialesEScreenE extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _idController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  MaskTextInputFormatter _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  CredencialesEScreenE({super.key});

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
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Datos del estudiante'),
              TextField(
                controller: _idController,
                keyboardType: TextInputType.number, // Teclado a número
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número de identificación',
                  hintText: 'Ingrese el documento',
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _dateController,
                keyboardType: TextInputType.number, // Teclado a número
                inputFormatters: [_dateMaskFormatter],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de nacimiento',
                  hintText: 'DD/MM/YYYY',
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Mostrar diálogo de carga
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
                      final response = await http.post(
                        Uri.parse(
                          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Credenciales/Validacion.php',
                        ),
                        body: {
                          'identificacion': _idController.text,
                          'fecha': _dateController.text,
                        },
                      );

                      // Cerrar el diálogo de carga después de recibir la respuesta
                      Navigator.pop(context);

                      if (response.statusCode == 200) {
                        Map<String, dynamic> data = json.decode(response.body);

                        print('Respuesta del servidor: ${response.body}');

                        String usuarioAsis = data['USUARIO_ASIS']?.trim() ?? '';
                        String correoInstitucional =
                            data['CORREO_INSTITUCIONAL']?.trim() ?? '';

                        print('Usuario ASIS: $usuarioAsis');
                        print('Correo Institucional: $correoInstitucional');

                        if (usuarioAsis.isNotEmpty &&
                            correoInstitucional.isNotEmpty) {
                          // Redirige a CredencialesE2ScreenE y pasa los datos necesarios
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CredencialesE2ScreenE(
                                usuarioAsis: data['USUARIO_ASIS'],
                                correoInstitucional:
                                    data['CORREO_INSTITUCIONAL'],
                                correoPersonal: data['CORREO_PERSONAL'],
                                tipo: data['TIPO'],
                                documento: data['DOCUMENTO'],
                                emplid: data['CODIGO'],
                                fecha: data['FECHA_NACIMIENTO'],
                              ),
                            ),
                          );
                        } else {
                          // Muestra un Snackbar indicando que no se encontraron resultados para esta búsqueda
                          print(
                              'Mostrar Snackbar: No se encontraron resultados');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'No se encontraron resultados para esta búsqueda.',
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        // Muestra un Snackbar indicando un error en la solicitud
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error en la solicitud'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (error) {
                      // Manejar errores aquí
                      print('Error: $error');
                    }
                  }
                },
                child: Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
