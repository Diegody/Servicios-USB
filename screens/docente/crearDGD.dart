import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class CrearDGDScreenD extends StatefulWidget {
  final String sesion;
  final String groupID;
  final String fechaTuto;

  const CrearDGDScreenD({
    required this.sesion,
    required this.groupID,
    required this.fechaTuto,
  });

  @override
  _CrearDGDScreenDState createState() => _CrearDGDScreenDState();
}

class _CrearDGDScreenDState extends State<CrearDGDScreenD> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  List<Map<String, dynamic>> _sessionDetails = [];
  List<bool> asistenciaEstudiantes = [];

  // ignore: unused_field
  bool _isLoading = true;
  bool asistencia = false;

  TextEditingController _numeroSesionController = TextEditingController();
  final TextEditingController? _actividadController = TextEditingController();
  final TextEditingController? _acuerdosController = TextEditingController();
  final TextEditingController? _InicioTutoriaController =
      TextEditingController();
  final TextEditingController? _finTutoriaController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _numeroSesionController.text = widget.sesion;
    _InicioTutoriaController!.text = widget.fechaTuto;
    //crearDetalle();
    _datosEstudiante(widget.groupID);
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
        _finTutoriaController!.text =
            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} ${selectedTime.hour}:${selectedTime.minute}';
      });
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

  List<Widget> _buildStudentDetails(List<Map<String, dynamic>> students) {
    List<Widget> widgets = [];
    for (int i = 0; i < students.length; i++) {
      asistenciaEstudiantes.add(false);
      widgets.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orange,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Text(
              'Documento: ${students[i]['CEDULA']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              'Nombre: ${students[i]['NOMBRES']}',
              style: TextStyle(fontSize: 14),
            ),
            trailing: Checkbox(
              value: asistenciaEstudiantes[i],
              onChanged: (bool? value) {
                setState(() {
                  asistenciaEstudiantes[i] = value ?? false;
                });
              },
              activeColor: Colors.orange,
            ),
          ),
        ),
      );
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Detalle'),
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Text(
                'Detallado de sesión grupal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              ..._buildStudentDetails(_sessionDetails),
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
                controller: _InicioTutoriaController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Inicio de la tutoría',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _finTutoriaController,
                decoration: InputDecoration(
                  labelText: 'Fin de la tutoría',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione una fecha de fin de tutoría';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _actividadController,
                decoration: InputDecoration(
                  labelText: 'Actividad realizada',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la actividad realizada';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _acuerdosController,
                decoration: InputDecoration(
                  labelText: 'Acuerdos y compromisos',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la actividad realizada';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _startLoadingAnimation();
                    crearDetalle(
                      estudiantesData: _sessionDetails,
                      asistenciaEstudiantes: asistenciaEstudiantes,
                      numeroSesion: _numeroSesionController.text,
                      fechaInicio: _InicioTutoriaController!.text,
                      fechaFin: _finTutoriaController!.text,
                      actividad: _actividadController!.text,
                      acuerdos: _acuerdosController!.text,
                      idGrupo: widget.groupID,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Detalle creado.'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 5),
                      ),
                    );
                    _stopLoadingAnimation();
                    Navigator.pop(context);
                  } else {
                    _stopLoadingAnimation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Por favor, complete todos los campos correctamente.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                },
                child: Text('Crear detalle',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _datosEstudiante(String groupID) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/ObtenerDatosEstudiantesGrupal.php',
        ),
        body: {'ID_GRUPO': groupID},
      );

      if (response.statusCode == 200) {
        print(response.body);
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            _sessionDetails = List<Map<String, dynamic>>.from(data);
          });
        } else {
          print('No hay estudiante.');
        }
      } else {
        throw Exception('Failed to load student details');
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> crearDetalle({
    required List<Map<String, dynamic>> estudiantesData,
    required List<bool> asistenciaEstudiantes,
    required String numeroSesion,
    required String fechaInicio,
    required String fechaFin,
    required String actividad,
    required String acuerdos,
    required String idGrupo,
  }) async {
    final url =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/CrearDetalleTutoriaGrupal.php';

    List<Map<String, dynamic>> asistenciaData = [];

    for (int i = 0; i < estudiantesData.length; i++) {
      Map<String, dynamic> estudianteData = {
        'CEDULA': estudiantesData[i]['CEDULA'],
        'NOMBRES': estudiantesData[i]['NOMBRES'],
        'ASISTENCIA': asistenciaEstudiantes[i] ? 'Si' : 'No',
      };
      asistenciaData.add(estudianteData);
    }

    Map<String, dynamic> datosFormulario = {
      'ESTUDIANTES': jsonEncode(estudiantesData),
      'ASISTENCIA': jsonEncode(asistenciaData),
      'NUMEROSESION': numeroSesion,
      'FECHA_INICIO': fechaInicio,
      'FECHA_FIN': fechaFin,
      'ACTIVIDAD': actividad,
      'ACUERDOS': acuerdos,
      'ID_GRUPO': idGrupo,
      'DOC_DOC': globalCodigoDocente,
    };

    print('Datos del formulario del detalle: $datosFormulario');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: datosFormulario,
      );

      if (response.statusCode == 200) {
        print('Detalle creado con éxito: ${response.statusCode}');
        print('Datos enviados al servidor: $datosFormulario');
      } else {
        print(
            'Error en la solicitud. Código de estado: ${response.statusCode}');
      }
    } catch (error) {
      print('Error de conexión: $error');
    }
  }
}
