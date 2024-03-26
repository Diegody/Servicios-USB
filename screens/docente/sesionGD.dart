import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class SesionGScreenD extends StatefulWidget {
  final String idGrupo;

  SesionGScreenD({required this.idGrupo});

  @override
  _SesionGScreenEState createState() => _SesionGScreenEState();
}

class _SesionGScreenEState extends State<SesionGScreenD> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  List<Map<String, dynamic>> _sessionDetails = [];
  // ignore: unused_field
  bool _isLoading = true;

  late String profesor;
  final TextEditingController _numeroSesionController = TextEditingController();
  TextEditingController _cicloController = TextEditingController();
  final TextEditingController _tipoTutoriaController =
      TextEditingController(text: 'Tutoría académica');
  final TextEditingController _docenteEncargadoController =
      TextEditingController();
  final TextEditingController? _tematicaTutoriaController =
      TextEditingController();
  final TextEditingController _modalidadController = TextEditingController();
  final TextEditingController _metodologiaController =
      TextEditingController(text: 'Grupal');
  final TextEditingController? _fechaTutoriaController =
      TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController? _lugarTutoriaController =
      TextEditingController();

  //++++++++++++++++++++++++++++++++++
  TextEditingController textFieldController = TextEditingController();
  List<String> estudiantesEncontrados = [];
  List<String> selectedStudents = [];
  bool showEstudiantesList = false;
  bool atLeastOneStudentSelected = false;
  List<String> cicloE = [];
  //++++++++++++++++++++++++++++++++++

  String selectedOpcionFacultad = '';
  String selectedOpcionPrograma = '';
  String selectedOpcionCurso = '';
  List<Map<String, dynamic>> _opcionFacultadList = [];
  List<Map<String, dynamic>> _opcionProgramaAcademicoList = [];
  List<Map<String, dynamic>> _opcionCursoList = [];

  @override
  void initState() {
    super.initState();
    // _fetchNextSessionNumber(widget.ciclo, widget.documento);
    // _cicloController.text = widget.ciclo;
    // _docmuentoEstudianteController.text = widget.documento;
    _loadOpcFacultad();
    _loadOpcProgramaAcademico();
    _loadOpcCurso();
    _profesorEncargado();
    obtenerNumeroSesion(widget.idGrupo);
    enviarSolicitud();

    //++++++++++++++++++++++++++++++++
    buscarEstudiantes(textFieldController.text);
    textFieldController.addListener(() {
      if (textFieldController.text.isNotEmpty) {
        buscarEstudiantes(textFieldController.text);
      }
    });
    ciclo();
    //++++++++++++++++++++++++++++++++
  }

  Future<void> _loadOpcFacultad() async {
    try {
      List<Map<String, dynamic>> opcFacultadData = await getOpcFacultad();

      setState(() {
        _opcionFacultadList = opcFacultadData;

        if (_opcionFacultadList.isNotEmpty) {
          selectedOpcionFacultad = _opcionFacultadList[0]['id'];
          print('Opción seleccionada el el DropDown: $selectedOpcionFacultad');
        } else {
          selectedOpcionFacultad = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionFacultadList = [];
        selectedOpcionFacultad = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de facultad: $e');
    }
  }

  Future<void> _loadOpcProgramaAcademico() async {
    try {
      List<Map<String, dynamic>> opcProgramaData =
          await getOpcPrograma(selectedOpcionFacultad);

      setState(() {
        _opcionProgramaAcademicoList = opcProgramaData;
        if (_opcionProgramaAcademicoList.isNotEmpty) {
          selectedOpcionPrograma = _opcionProgramaAcademicoList[0]['id'];
        } else {
          selectedOpcionPrograma = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionProgramaAcademicoList = [];
        selectedOpcionPrograma = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de programas: $e');
    }
  }

  Future<void> _loadOpcCurso() async {
    try {
      List<Map<String, dynamic>> opcCursoData =
          await getOpcCurso(selectedOpcionPrograma);

      setState(() {
        _opcionCursoList = opcCursoData;

        if (_opcionCursoList.isNotEmpty) {
          selectedOpcionCurso = _opcionCursoList[0]['id'];
          print('Opción seleccionada el el DropDown: $selectedOpcionCurso');
        } else {
          selectedOpcionCurso = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionCursoList = [];
        selectedOpcionCurso = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de cursos: $e');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle? style = theme.textTheme.subtitle1;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: colorScheme.copyWith(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
            textTheme: theme.textTheme.copyWith(
              subtitle1: style?.copyWith(color: Colors.orange),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _selectTime(context);
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: colorScheme.copyWith(
              primary: Colors.orange,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        _fechaTutoriaController!.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.hour}:${selectedTime.minute}';
      });
  }

  Widget _buildDropdownFieldWithFacultad(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionFacultadList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Text(map['text']),
        );
      }).toList(),
      value: selectedOpcionFacultad.isNotEmpty ? selectedOpcionFacultad : null,
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedOpcionFacultad = value;
            selectedOpcionPrograma = '';
            _opcionProgramaAcademicoList.clear();
          });
          _startLoadingAnimation();
          try {
            await _loadOpcProgramaAcademico();
          } finally {
            _stopLoadingAnimation();
          }
        }
      },
    );
  }

  Widget _buildDropdownFieldWithPrograma(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionProgramaAcademicoList.map((map) {
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
      value: selectedOpcionPrograma,
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedOpcionPrograma = value;
          });
          _startLoadingAnimation();
          try {
            await _loadOpcCurso();
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
      items: _opcionCursoList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Text(map['text']),
        );
      }).toList(),
      value: selectedOpcionCurso,
      validator: (value) {
        if (opciones.isEmpty || value == null || value.isEmpty) {
          return 'Por favor, seleccione $label';
        }
        return null;
      },
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedOpcionCurso = value;
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

  void _showSesionForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Tutoría Grupal'),
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
              Text(
                'Asignación de tutoría grupal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              //++++++++++++++++++++++++++++++++++++++
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
                            title:
                                Text('Selecciona un estudiante para eliminar'),
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
              //++++++++++++++++++++++++++++++++++++++
              SizedBox(height: 20),
              TextFormField(
                controller: _numeroSesionController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Número de sesión',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cicloController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Periodo académico',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _tipoTutoriaController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Tipo de tutoría',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _buildDropdownFieldWithFacultad(
                'Facultad',
                _opcionFacultadList
                    .map((map) => map['text'].toString())
                    .toList(),
                selectedOpcionFacultad,
              ),
              SizedBox(height: 20),
              _buildDropdownFieldWithPrograma(
                'Programa académico',
                _opcionProgramaAcademicoList
                    .map((map) => map['text'].toString())
                    .toList(),
                selectedOpcionPrograma,
              ),
              SizedBox(height: 20),
              _buildDropdownFieldWithCurso(
                'Curso',
                _opcionCursoList.map((map) => map['text'].toString()).toList(),
                selectedOpcionCurso,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _docenteEncargadoController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Profesor responsable',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _tematicaTutoriaController,
                decoration: InputDecoration(
                  labelText: 'Temática',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la tematica';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Modalidad',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Presencial',
                    child: Text('Presencial'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Virtual',
                    child: Text('Virtual'),
                  ),
                ],
                onChanged: (value) {
                  _modalidadController.text = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione modalidad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _metodologiaController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Metodología',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _fechaTutoriaController,
                decoration: InputDecoration(
                  labelText: 'Fecha de la tutoría',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione una fecha de tutoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _lugarTutoriaController,
                decoration: InputDecoration(
                  labelText: 'Lugar de la tutoría o link de invitación',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese el lugar de tuturía.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _stopLoadingAnimation();
                    enviarSolicitud();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sesión de tutoría creada y enviada.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else {
                    _stopLoadingAnimation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('No se puedo crear la sesión de tutoría.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
                child: Text('Crear tutoría a estudiante',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getOpcFacultad() async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/OpcionFacultad.php'),
    );

    if (response.statusCode == 200) {
      print('Cuerpo de la respuesta (Opciones de facultad): ${response.body}');

      List<dynamic> opcFincDataList = json.decode(response.body);

      return opcFincDataList
          .map<Map<String, dynamic>>((opc) => {
                'text': opc['FACULTAD'].toString(),
                'id': opc['FACULTAD2'].toString(),
              })
          .toList();
    } else {
      throw Exception('Error al cargar todas las opciones');
    }
  }

  Future<List<Map<String, dynamic>>> getOpcPrograma(String programa) async {
    final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/OpcionProgramaAcademico.php'),
        body: {'PROG_ACADEMICO': programa});

    if (response.statusCode == 200) {
      print(
          'Cuerpo de la respuesta (Opciones de programa academico): ${response.body}');

      List<dynamic> opcFincDataList = json.decode(response.body);

      return opcFincDataList
          .map<Map<String, dynamic>>((opc) => {
                'text': opc['PROGRAMA'].toString(),
                'id': opc['PROGRAMA2'].toString(),
              })
          .toList();
    } else {
      throw Exception('Error al cargar todas las opciones');
    }
  }

  Future<List<Map<String, dynamic>>> getOpcCurso(String curso) async {
    final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/OpcionCurso.php'),
        body: {'CURSO': curso});

    if (response.statusCode == 200) {
      print('Cuerpo de la respuesta (Opciones de curso): ${response.body}');

      List<dynamic> opcFincDataList = json.decode(response.body);

      return opcFincDataList
          .map<Map<String, dynamic>>((opc) => {
                'text': opc['MATERIA'].toString(),
                'id': opc['MATERIA2'].toString(),
              })
          .toList();
    } else {
      throw Exception('Error al cargar todas las opciones');
    }
  }

  Future<void> _profesorEncargado() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/ProfesorEncargado.php'),
        body: {'DOC_DOC': globalCodigoDocente},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty && data[0]['PROFE'] != null) {
          String nombreProfesor = data[0]['PROFE'].toString();
          _docenteEncargadoController.text = nombreProfesor;
        } else {
          print('No hay profesores disponibles para este estudiante.');
        }
      } else {
        throw Exception('Failed to load next session number');
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> enviarSolicitud() async {
    final url =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/CrearTutoriaGrupal.php';

    List<Map<String, String>> estudiantesData = [];

    for (String student in selectedStudents) {
      // Separar documento y nombre
      List<String> parts = student.split('/ Nombre ');
      String documento = parts[0].replaceAll('Documento ', '').trim();
      String nombre = parts[1].trim();

      Map<String, String> estudianteData = {
        'NOMBRE_EST': nombre,
        'DOCUMENTO_EST': documento,
      };
      estudiantesData.add(estudianteData);
    }

    Map<String, dynamic> datosFormulario = {
      'ESTUDIANTES': jsonEncode(estudiantesData),
      'NUMEROSESION': _numeroSesionController.text,
      'PERIODOACADEMICO': _cicloController.text,
      'TIPOTUTORIA': _tipoTutoriaController.text,
      'FACULTAD': selectedOpcionFacultad,
      'PROGRAMA': selectedOpcionPrograma,
      'NOMBREDELCURSO': selectedOpcionCurso,
      'PROFESORRESPONSABLE': _docenteEncargadoController.text,
      'TEMATICA': _tematicaTutoriaController?.text ?? '',
      'MODALIDAD': _modalidadController.text,
      'METODOLOGIA': _metodologiaController.text,
      'FECHATUTORIA': _fechaTutoriaController!.text,
      'LUGAR': _lugarTutoriaController!.text,
      'DOCUMENTOP': globalCodigoDocente,
      'ID_GRUPO': widget.idGrupo,
    };
    print('EstudiantesData: $estudiantesData');

    print('Datos del formulario: $datosFormulario');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: datosFormulario,
      );

      if (response.statusCode == 200) {
        print('Solicitud enviada con éxito: ${response.statusCode}');
        print('Datos enviados al servidor: $datosFormulario');
      } else {
        print(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('StackTrace: $stackTrace');
    }
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
      // Manejar errores si la solicitud al servidor falla
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

  void obtenerNumeroSesion(String id_grupo) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/NumeroSesionGrupal.php'),
      body: {'ID_GRUPO': id_grupo},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        _numeroSesionController.text = data[0]['ID_GRUPO'].toString();
      });
    } else {
      print('Error al obtener el número de sesión');
    }
  }
}
