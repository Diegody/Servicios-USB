import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class CrearGrupoTutoriaScreen extends StatefulWidget {
  @override
  _CrearGrupoTutoriaScreenState createState() =>
      _CrearGrupoTutoriaScreenState();
}

class _CrearGrupoTutoriaScreenState extends State<CrearGrupoTutoriaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Grupo'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          key: _formKey,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre del grupo',
                prefixIcon: Icon(Icons.add),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _stopLoadingAnimation();
                crearGrupo(_nombreController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Grupo creado correctamente.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text(
                'Crear grupo de tutoría',
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
    );
  }

  void _stopLoadingAnimation() {
    Navigator.of(context).pop();
  }

  void crearGrupo(String nombreGrupo) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/CrearGrupo.php',
        ),
        body: {'NOMBRE_G': nombreGrupo, 'DOC_DOC': globalCodigoDocente},
      );
      print(
          'Datos enviados: {"NOMBRE_G": "$nombreGrupo", "DOC_DOC": "$globalCodigoDocente"}');

      if (response.statusCode == 200) {
        print('Grupo creado exitosamente');
      } else {
        print(
          'Error al crear el grupo. Código de estado: ${response.statusCode}',
        );
      }

      print('Respuesta del servidor: ${response.body}');
    } catch (e) {
      print('Excepción al enviar la solicitud: $e');
    }
  }
}
