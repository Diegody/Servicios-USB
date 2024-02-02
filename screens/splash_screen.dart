import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Espera 3 segundos y luego navega a la pantalla de inicio de sesión
    Future.delayed(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      ),
    );

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logousb.png',
                width: 350.0,
                height: 350.0,
              ),
              SizedBox(height: 20.0),
              Text(
                '¡Bienvenido!',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
