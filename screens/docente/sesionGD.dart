import 'package:flutter/material.dart';
import '../../globals.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SesionGScreenD(),
    );
  }
}

class SesionGScreenD extends StatefulWidget {
  @override
  _SesionGScreenEState createState() => _SesionGScreenEState();
}

class _SesionGScreenEState extends State<SesionGScreenD> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  TextEditingController _cicloController = TextEditingController();

  String selectedOption = 'Individual';
  TextEditingController textFieldController = TextEditingController();
  List<String> selectedStudents = [];
  List<String> estudiantesEncontrados = [];
  List<String> cicloE = [];
  bool showEstudiantesList = false;
  bool atLeastOneStudentSelected = false;

  @override
  void initState() {
    super.initState();
    buscarEstudiantes(textFieldController.text);
    _documentoController.text = globalDocumento!;
    _usernameController.text = globalUsername!;
    textFieldController.addListener(() {});
    ciclo();
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

  Widget _buildTextField(
      String label, String hint, TextEditingController? controller) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (controller == null && (value == null || value.isEmpty)) {
          return 'Por favor, ingrese $label';
        }
        return null;
      },
    );
  }

  void _startLoadingAnimation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        );
      },
    );
  }

  void _stopLoadingAnimation() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selección de estudiantes'),
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Datos de la tutoría'),
              SizedBox(height: 16),
              TextField(
                controller: textFieldController,
                decoration: InputDecoration(
                  labelText: 'Buscar estudiante',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  setState(() {
                    showEstudiantesList = true;
                  });
                },
              ),
              if (showEstudiantesList && estudiantesEncontrados.isNotEmpty) ...[
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: estudiantesEncontrados.length > 5
                      ? 5
                      : estudiantesEncontrados.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(estudiantesEncontrados[index]),
                      onTap: () {
                        setState(() {
                          selectedStudents.add(estudiantesEncontrados[index]);
                          textFieldController.clear();
                          showEstudiantesList = false;
                        });
                      },
                    );
                  },
                ),
              ],
              SizedBox(height: 16),
              Row(
                children: [
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title:
                                Text('Selecciona un estudiante para eliminar'),
                            content: Column(
                              children: selectedStudents.map((student) {
                                return ListTile(
                                  title: Text(student),
                                  onTap: () {
                                    setState(() {
                                      selectedStudents.remove(student);
                                      Navigator.of(context).pop();
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                    child: Text('Eliminar',
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                height: 150,
                child: ListView(
                  children: selectedStudents.map((student) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 0.5),
                      child: ListTile(
                        title: Text(student),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _cicloController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Periodo académico',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: Text('Continuar', style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buscarEstudiantes(String query) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/BusquedaEstudiantes.php'),
      body: {'ESTUDIANTE': query},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        estudiantesEncontrados =
            data.map((item) => item['DATO'] as String).toList();
      });
    } else {
      print('Error al buscar estudiantes');
    }
  }

  void ciclo() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/Ciclo.php'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          String ciclo = data['CICLO'] as String;
          _cicloController.text = ciclo;
        });
      } else {
        print(
            'Error al buscar el ciclo. Código de estado: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (error) {
      print('Error inesperado al buscar el ciclo: $error');
    }
  }
}
