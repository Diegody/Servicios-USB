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
              // Ajusta la alineación vertical aquí
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logousb2.png', height: 200),
                      SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        keyboardType: TextInputType.number,  // Teclado a número
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
                              color: Colors.black, // Cambia aquí el color del texto
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    if (_loginError) {
                      // Mostrar SnackBar en la parte inferior de la pantalla
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
      // Mostrar SnackBar cuando no se proporciona un nombre de usuario
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
          // Hay un error en la respuesta del servidor, mostrar un SnackBar y evitar la navegación
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${data['error']}'),
              backgroundColor: Colors.red,
            ),
          );
          // No realizar la navegación a la pantalla de inicio
        } else {
          globalCodigoEstudiante = data['EMPLID'];
          // Autenticación exitosa, puedes acceder a los valores result.DOCUMENTO, result.EMPLID, result.NIT
          globalUsername = data['NOMBRE']; // Asigna el nombre de usuario a la variable global
          globalDocumento = data['DOCUMENTO'];
          if (data['NIT'] == 'DOC') {
            globalCodigoDocente = data['DOCUMENTO'];
            // Redirige a la pantalla de inicio de docentes
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bienvenid@, $globalUsername'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, '/docente/inicioD');
          } else if (data['NIT'] == 'NO') {
            // Redirige a la pantalla de inicio de estudiantes
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Bienvenid@, $globalUsername'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushReplacementNamed(context, '/estudiante/inicioE');
          } else {
            // Valor inesperado para NIT
            print('Valor inesperado para NIT: ${data['NIT']}');
          }
        }
      } else {
        // Si la respuesta no es exitosa, imprime el mensaje de error del servidor y evita la navegación
        print("Error de autenticación: ${response.body}");

        // Mostrar SnackBar en la parte inferior de la pantalla
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hubo un problema al procesar la solicitud'),
            backgroundColor: Colors.red,
          ),
        );
        // No realizar la navegación a la pantalla de inicio
      }
    } catch (e) {
      // Captura y maneja cualquier excepción durante la solicitud y evita la navegación
      print('Excepción durante la solicitud HTTP: $e');

      // Mostrar SnackBar en la parte inferior de la pantalla
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hubo un problema al procesar la solicitud'),
          backgroundColor: Colors.red,
        ),
      );

      // No realizar la navegación a la pantalla de inicio
    }
  }
}
