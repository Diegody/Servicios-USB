import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class CrearDDScreenD extends StatefulWidget {
  final String ciclo;
  final String documento;
  final String sesion;
  final String nombre;
  final String codigoEstudiante;

  const CrearDDScreenD({
    required this.ciclo,
    required this.documento,
    required this.sesion,
    required this.nombre,
    required this.codigoEstudiante,
  });

  @override
  _CrearDDScreenDState createState() => _CrearDDScreenDState();
}

class _CrearDDScreenDState extends State<CrearDDScreenD> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  List<Map<String, dynamic>> _sessionDetails = [];
  // ignore: unused_field
  bool _isLoading = true;

  TextEditingController _numeroSesionController = TextEditingController();
  TextEditingController _nombreEstudianteController = TextEditingController();
  TextEditingController _documentoEstudianteController =
      TextEditingController();
  TextEditingController _codigoEstudianteController = TextEditingController();
  final TextEditingController _asistenciaController = TextEditingController();
  final TextEditingController? _actividadController = TextEditingController();
  final TextEditingController? _acuerdosController = TextEditingController();
  final TextEditingController? _finTutoriaController = TextEditingController();
  final TextEditingController? _InicioTutoriaController =
      TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _documentoEstudianteController.text = widget.documento;
    _numeroSesionController.text = widget.sesion;
    _nombreEstudianteController.text = widget.nombre;
    _codigoEstudianteController.text = widget.codigoEstudiante;
    //enviarSolicitud();
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
          child: ListView(
            children: [
              Text(
                'Detallado de sesión',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                controller: _nombreEstudianteController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Nombre estudiante',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _documentoEstudianteController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Documento',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _codigoEstudianteController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Código estudiantil',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Asistencia',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Si',
                    child: Text('Si asistió'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'No',
                    child: Text('No asistió'),
                  ),
                ],
                onChanged: (value) {
                  _asistenciaController.text = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _actividadController,
                decoration: InputDecoration(
                  labelText: 'Actividad realizada',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _acuerdosController,
                decoration: InputDecoration(
                  labelText: 'Acuerdos y compromisos',
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
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _stopLoadingAnimation();
                    // enviarSolicitud();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Detalle creado.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    _stopLoadingAnimation();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('No se puedo crear el detalle.'),
                        backgroundColor: Colors.red,
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

  // Future<void> enviarSolicitud() async {
  //   final url =
  //       'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/.php';

  //   Map<String, String> datosFormulario = {
  //     '': _numeroSesionController.text,
  //     '': _nombreEstudianteController.text,
  //     '': _documentoEstudianteController.text,
  //     '': _codigoEstudianteController.text,
  //     '': _actividadController?.text ?? '',
  //     '': _acuerdosController?.text ?? '',
  //     '': _asistenciaController.text,
  //     '': _InicioTutoriaController!.text,
  //     '': _finTutoriaController!.text,
  //   };

  //   print('Datos del formulario: $datosFormulario');

  //   try {
  //     final response = await http.post(
  //       Uri.parse(url),
  //       body: datosFormulario,
  //     );

  //     if (response.statusCode == 200) {
  //       // Procesa la respuesta si es necesario
  //       print('Solicitud enviada con éxito: ${response.statusCode}');
  //       print('Datos enviados al servidor: $datosFormulario');
  //     } else {
  //       // Maneja errores de la respuesta
  //       print(
  //           'Error en la solicitud. Código de estado: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Maneja errores de la conexión
  //     print('Error de conexión: $error');
  //   }
  // }
}
