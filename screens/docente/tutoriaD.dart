import 'package:flutter/material.dart';

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20), // Separación entre los botones
          _buildSectionButton(
            context,
            'Tutoría individual',
            Icons.person,
            () {
              // Acción al presionar "Tutoría individual"
              // Ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualTutoriaScreen()));
            },
          ),
          SizedBox(height: 20), // Separación entre los botones
          _buildSectionButton(
            context,
            'Tutoría grupal',
            Icons.group,
            () {
              // Acción al presionar "Tutoría grupal"
              // Ejemplo: Navigator.push(context, MaterialPageRoute(builder: (context) => GrupalTutoriaScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionButton(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: 30), // Ajusta el margen horizontal según tu preferencia
        width: MediaQuery.of(context).size.width -
            40, // Ancho máximo igual al del dispositivo menos el doble del margen horizontal
        decoration: BoxDecoration(
          color: const Color.fromRGBO(18, 182, 207, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 60, // Tamaño del icono ajustado según tu preferencia
            ),
            SizedBox(height: 10), // Espacio entre el icono y el texto
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
