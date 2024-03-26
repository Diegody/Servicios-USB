import 'dart:io';
import 'package:flutter/material.dart';
import 'package:servicios/screens/docente/inicioD.dart';
import 'package:servicios/screens/estudiante/inicioE.dart';
import 'screens/splash_screen.dart';

void main() {
  // Desactivar verificación SSL en desarrollo
  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/estudiante/inicioE': (context) => HomeScreenE(),
        '/docente/inicioD': (context) => HomeScreenD(),
      },

      home: SplashScreen(),
    );
  }
}


