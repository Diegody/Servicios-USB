import 'dart:convert';
import 'package:flutter/material.dart';
import '../globals.dart';
import 'package:http/http.dart' as http;

class LoginResponse {
  final String DOCUMENTO;
  final String EMPLID;
  final String NOMBRE;
  final String NIT;

  LoginResponse({
    required this.DOCUMENTO,
    required this.EMPLID,
    required this.NOMBRE,
    required this.NIT,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      DOCUMENTO: json['DOCUMENTO'] ?? "",
      EMPLID: json['EMPLID'] ?? "",
      NOMBRE: json['NOMBRE'] ?? "",
      NIT: json['NIT'] ?? "",
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _usernameController = TextEditingController();
  bool _loginError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.yellow],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logousb2.png', height: 200),
                      SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'ID Usuario',
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => authenticateUser(context),
                        child: Text('Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.black,
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    if (_loginError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: Usuario inválido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void authenticateUser(BuildContext context) async {
    final String username = _usernameController.text;

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, ingrese su ID de usuario'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String authenticationEndpoint =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Login.php';

    try {
      final response = await http.post(
        Uri.parse(authenticationEndpoint),
        body: {'identificacion': username},
      );

      print('Server response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('error')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${data['error']}'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          globalCodigoEstudiante = data['EMPLID'];
          globalUsername = data['NOMBRE'];
          globalDocumento = data['DOCUMENTO'];
          if (data['NIT'] == 'DOC') {
            globalCodigoDocente = data['DOCUMENTO'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bienvenid@, $globalUsername'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, '/docente/inicioD');
          } else if (data['NIT'] == 'NO') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bienvenid@, $globalUsername'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, '/estudiante/inicioE');
          } else {
            print('Valor inesperado para NIT: ${data['NIT']}');
          }
        }
      } else {
        print("Error de autenticación: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hubo un problema al procesar la solicitud'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('Excepción durante la solicitud HTTP: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un problema al procesar la solicitud'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
}
