import 'package:flutter/material.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE.dart';
import 'horarioE.dart';
import 'icetexE.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TutoriaEScreenE(),
    );
  }
}

class TutoriaEScreenE extends StatefulWidget {
  @override
  _TutoriaEScreenEState createState() => _TutoriaEScreenEState();
}

class _TutoriaEScreenEState extends State<TutoriaEScreenE> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _correoInstitucionalController =
      TextEditingController();
  final TextEditingController? _tematicaTutoriaController =
      TextEditingController();

  List<String> programas = [];
  List<String> programasAll = [];
  String correoEstudiante = '';

  String selectedOpcionProgramaT = '';
  String selectedOpcionCursoT = '';
  String selectedOpcionTeachT = '';
  List<Map<String, dynamic>> _opcionProgramaAcademicoListT = [];
  List<Map<String, dynamic>> _opcionCursoTList = [];
  List<Map<String, dynamic>> _opcionTeachTList = [];

  String selectedOption = 'Individual';
  TextEditingController textFieldController = TextEditingController();
  List<String> selectedStudents = [];
  List<String> estudiantesEncontrados = [];
  bool showEstudiantesList = false;
  bool atLeastOneStudentSelected = false;

  @override
  void initState() {
    super.initState();
    _loadOpcProgramaAcademico();
    _loadProgramas();
    _loadCorreoEstudiante();
    buscarEstudiantes(textFieldController.text);
    textFieldController.addListener(() {
      if (textFieldController.text.isNotEmpty) {
        buscarEstudiantes(textFieldController.text);
      }
    });
    _documentoController.text = globalDocumento!;
    _usernameController.text = globalUsername!;
    textFieldController.addListener(() {});
  }

  Future<void> _loadProgramas() async {
    try {
      print('Código del estudiante (globalDocumento): $globalDocumento');
      List<String>? programasData =
          await getProgramasEstudiante(globalDocumento!);
      if (programasData.isNotEmpty) {
        print(
            'Tipo de datos de la respuesta JSON (Programas): ${programasData.runtimeType}');
        print('Cuerpo de la respuesta JSON (Programas): $programasData');

        setState(() {
          programas = programasData;
        });
      } else {
        setState(() {
          programas = [];
        });
        print('Error: programasData es nulo o vacío');
      }
    } catch (e) {
      setState(() {
        programas = [];
      });
      print('Error al cargar programas: $e');
    }
  }

  Future<void> _loadCorreoEstudiante() async {
    try {
      print('Código del estudiante (globalDocumento): $globalDocumento');
      String correoData = await getCorreoEstudiante(globalDocumento!);
      if (correoData.isNotEmpty) {
        print(
            'Tipo de datos de la respuesta JSON (Correo): ${correoData.runtimeType}');
        print('Cuerpo de la respuesta JSON (Correo): $correoData');

        setState(() {
          correoEstudiante = correoData;
          _correoInstitucionalController.text = correoEstudiante;
        });
      } else {
        setState(() {
          correoEstudiante = '';
        });
        print('Error: correoData es nulo o vacío');
      }
    } catch (e) {
      setState(() {
        correoEstudiante = '';
      });
      print('Error al cargar el correo del estudiante: $e');
    }
  }

  Future<void> _loadOpcProgramaAcademico() async {
    try {
      List<Map<String, dynamic>> opcProgramaData = await getOpcPrograma();

      setState(() {
        _opcionProgramaAcademicoListT = opcProgramaData;

        if (_opcionProgramaAcademicoListT.isNotEmpty) {
          if (selectedOpcionProgramaT.isEmpty) {
            selectedOpcionProgramaT = _opcionProgramaAcademicoListT[0]['id'];
            print(
                'Opción seleccionada el el DropDown: $selectedOpcionProgramaT');
          }
        } else {
          selectedOpcionProgramaT = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionProgramaAcademicoListT = [];
        selectedOpcionProgramaT = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de programas: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _loadOpcCursos(String programa) async {
    try {
      List<Map<String, dynamic>> opcCursoData = await getOpcCurso(programa);

      setState(() {
        _opcionCursoTList = opcCursoData;

        if (_opcionCursoTList.isNotEmpty) {
          selectedOpcionCursoT = _opcionCursoTList[0]['id'];
          print('Selected Cursos: $selectedOpcionCursoT');
        } else {
          selectedOpcionCursoT = 'Sin opciones disponibles';
        }
      });

      return opcCursoData;
    } catch (e) {
      setState(() {
        _opcionCursoTList = [];
        selectedOpcionCursoT = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de cursos: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _loadOpcTeachT(String curso) async {
    try {
      List<Map<String, dynamic>> opcTeachData = await getOpcTeach(curso);

      setState(() {
        _opcionTeachTList = opcTeachData;

        if (_opcionTeachTList.isNotEmpty) {
          selectedOpcionTeachT = _opcionTeachTList[0]['id'];
          print('Selected Profesores: $selectedOpcionTeachT');
        } else {
          selectedOpcionTeachT = 'Sin opciones disponibles';
        }
      });

      return opcTeachData;
    } catch (e) {
      setState(() {
        _opcionTeachTList = [];
        selectedOpcionTeachT = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de profesores: $e');
      return [];
    }
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

  Widget _buildTextFieldUnloked(
      String label, String hint, TextEditingController? controller) {
    return TextFormField(
      controller: _tematicaTutoriaController,
      enabled: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese $label';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField(String label, List<String> opciones) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: opciones.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) {
        if (opciones.isEmpty || value == null || value.isEmpty) {
          return 'Por favor, seleccione $label';
        }
        return null;
      },
      onChanged: (String? value) {},
    );
  }

  Widget _buildDropdownFieldWithProg(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionProgramaAcademicoListT.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Text(map['text']),
        );
      }).toList(),
      value:
          selectedOpcionProgramaT.isNotEmpty ? selectedOpcionProgramaT : null,
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedOpcionProgramaT = value;
            selectedOpcionCursoT = '';
            _opcionCursoTList.clear();
            selectedOpcionTeachT = '';
            _opcionTeachTList.clear();
          });
          _startLoadingAnimation();
          try {
            await _loadOpcProgramaAcademico();
            await _loadOpcCursos(selectedOpcionProgramaT);
            print('Selected Programa: $selectedOpcionProgramaT');
          } finally {
            _stopLoadingAnimation();
          }
        }
      },
    );
  }

  Widget _buildDropdownFieldWithCurso(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionCursoTList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Container(
            width: 300,
            child: Text(
              map['text'],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
      value: selectedOpcionCursoT.isNotEmpty ? selectedOpcionCursoT : null,
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedOpcionCursoT = value;
            selectedOpcionTeachT = '';
            _opcionTeachTList.clear();
          });
          _startLoadingAnimation();
          try {
            await _loadOpcTeachT(selectedOpcionCursoT);
            print('Selected Curso: $selectedOpcionCursoT');
          } finally {
            _stopLoadingAnimation();
          }
        }
      },
    );
  }

  Widget _buildDropdownFieldWithTeach(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionTeachTList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Container(
            width: 300,
            child: Text(
              map['text'],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }).toList(),
      value: selectedOpcionTeachT,
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedOpcionTeachT = value;
          });
        }
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
        title: Text('Solicitar Tutoría'),
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
              _buildTextField(
                  'Documento', 'Ingrese el documento', _documentoController),
              SizedBox(height: 16),
              _buildTextField('Estudiante', 'Ingrese el nombre del estudiante',
                  _usernameController),
              SizedBox(height: 16),
              _buildTextField('Correo institucional', 'Ingrese el correo',
                  _correoInstitucionalController),
              SizedBox(height: 16),
              _buildDropdownField('Programa', programas),
              SizedBox(height: 30),
              _buildSectionTitle('Datos de la tutoría'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(7.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  value: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value ?? '';
                    });
                  },
                  items: ['Individual', 'Grupal'].map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                ),
              ),
              if (selectedOption == 'Grupal') ...[
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
                if (showEstudiantesList &&
                    estudiantesEncontrados.isNotEmpty) ...[
                  // Lista de estudiantes encontrados
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
                              title: Text(
                                  'Selecciona un estudiante para eliminar'),
                              content: Column(
                                children: selectedStudents.map((student) {
                                  return ListTile(
                                    title: Text(student),
                                    onTap: () {
                                      setState(() {
                                        selectedStudents.remove(student);
                                        Navigator.of(context)
                                            .pop(); // Cierra el diálogo
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
              ],
              SizedBox(height: 16),
              _buildDropdownFieldWithProg(
                'Programa de la tutoria',
                _opcionProgramaAcademicoListT
                    .map((map) => map['text'].toString())
                    .toList(),
                selectedOpcionProgramaT,
              ),
              SizedBox(height: 16),
              _buildDropdownFieldWithCurso(
                'Curso de la tutoría',
                _opcionCursoTList.map((map) => map['text'].toString()).toList(),
                selectedOpcionCursoT,
              ),
              SizedBox(height: 16),
              _buildDropdownFieldWithTeach(
                'Profesores de tuturìa',
                _opcionCursoTList.map((map) => map['text'].toString()).toList(),
                selectedOpcionTeachT,
              ),
              SizedBox(height: 16),
              _buildTextFieldUnloked(
                'Temática',
                'Tema a tratar en la tutoría',
                _tematicaTutoriaController,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  _startLoadingAnimation();
                  if (selectedOption == 'Grupal' && selectedStudents.isEmpty) {
                    _stopLoadingAnimation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Debe seleccionar al menos un estudiante para la opción grupal.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else {
                    if (_formKey.currentState?.validate() ?? false) {
                      _stopLoadingAnimation();
                      enviarSolicitud();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Solicitud enviada'),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 5),
                        ),
                      );
                    }
                  }
                },
                child: Text('Enviar solicitud',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> getProgramasEstudiante(String documento) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/PeticionPrograma.php'),
      body: {'CODIGO': documento},
    );

    if (response.statusCode == 200) {
      print('Cuerpo de la respuesta (Programas): ${response.body}');

      List<String> programasData =
          (json.decode(response.body) as List<dynamic>).cast<String>();

      return programasData;
    } else {
      throw Exception('Error al cargar los programas del estudiante');
    }
  }

  Future<String> getCorreoEstudiante(String documento) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/PeticionCorreo.php'),
      body: {'CODIGO': documento},
    );

    if (response.statusCode == 200) {
      print('Cuerpo de la respuesta (Correo): ${response.body}');

      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey("CORREOINSTITUCIONAL")) {
        String correo = responseData["CORREOINSTITUCIONAL"].toString();
        return correo;
      } else {
        throw Exception(
            'No se encontró el correo del estudiante en la respuesta');
      }
    } else {
      throw Exception('Error al cargar el correo del estudiante');
    }
  }

  Future<List<Map<String, dynamic>>> getOpcPrograma() async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/ProgramaDeTutoria.php'),
    );

    if (response.statusCode == 200) {
      List<dynamic> opcFincDataList = json.decode(response.body);

      return opcFincDataList
          .map<Map<String, dynamic>>((opc) => {
                'text': opc['D'].toString(),
                'id': opc['R'].toString(),
              })
          .toList();
    } else {
      throw Exception('Error al cargar todas las opciones');
    }
  }

  Future<List<Map<String, dynamic>>> getOpcCurso(String programa) async {
    final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/PeticionCursoTutoria.php'),
        body: {'PROG_ACADEMICO': programa});

    if (response.statusCode == 200) {
      // print('Cuerpo de la respuesta (Opciones de programa academico): ${response.body}');

      List<dynamic> opcFincDataList = json.decode(response.body);

      return opcFincDataList
          .map<Map<String, dynamic>>((opc) => {
                'text': opc['D'].toString(),
                'id': opc['R'].toString(),
              })
          .toList();
    } else {
      throw Exception('Error al cargar todas las opciones');
    }
  }

  Future<List<Map<String, dynamic>>> getOpcTeach(String curso) async {
    final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/ProfesorACargo.php'),
        body: {'CURSO': curso});

    if (response.statusCode == 200) {
      List<dynamic> opcFincDataList = json.decode(response.body);

      return opcFincDataList
          .map<Map<String, dynamic>>((opc) => {
                'text': opc['PROFESOR'].toString(),
                'id': opc['NATIONAL_ID_DOC'].toString(),
              })
          .toList();
    } else {
      throw Exception('Error al cargar todas las opciones');
    }
  }

  void buscarEstudiantes(String query) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/BusquedaEstudiantes.php'),
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

  Future<void> enviarSolicitud() async {
    final url =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/FormularioTutoria/EnvioSolicitudCorreo.php';

    Map<String, String> datosFormulario = {
      'DOCUMENTO': _documentoController.text,
      'NOMBREAPELLIDO': _usernameController.text,
      'CORREO_INST': _correoInstitucionalController.text,
      'CARRERA': selectedOpcionProgramaT,
      'MATERIA_TUTORIA': selectedOpcionCursoT,
      'CODIGOPROFESOR': selectedOpcionTeachT,
      'TEMATICA_TUTORIA': _tematicaTutoriaController?.text ?? '',
    };

    if (selectedOption == 'Grupal') {
      datosFormulario['TIPOTUTORIA'] = selectedOption;
      datosFormulario['INTEGRANTES'] = selectedStudents.join(', ');
      ;
    }

    print('Datos del formulario: $datosFormulario');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: datosFormulario,
      );

      if (response.statusCode == 200) {
        print('Solicitud enviada con éxito: ${response.statusCode}');
      } else {
        print(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
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
                    Navigator.pop(context);

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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
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
                    Navigator.pop(context);
                    AuthManager.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cerrando sesión...'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
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
