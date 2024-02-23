import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class CrearDDScreenD extends StatefulWidget {
  final String ciclo;
  final String documento;
  final String sesion;
  final String nombre;
  final String codigoEstudiante;
  final String fechaTutoria;
  final String curso;

  const CrearDDScreenD({
    required this.ciclo,
    required this.documento,
    required this.sesion,
    required this.nombre,
    required this.codigoEstudiante,
    required this.fechaTutoria,
    required this.curso,
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
  final TextEditingController? _InicioTutoriaController =
      TextEditingController();
  final TextEditingController? _finTutoriaController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController? _cursoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _documentoEstudianteController.text = widget.documento;
    _numeroSesionController.text = widget.sesion;
    _nombreEstudianteController.text = widget.nombre;
    _codigoEstudianteController.text = widget.codigoEstudiante;
    _InicioTutoriaController!.text = widget.fechaTutoria;
    _cursoController!.text = widget.curso;
    crearDetalle(widget.ciclo);
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
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, seleccione una opción de asistencia';
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _startLoadingAnimation();
                    crearDetalle(widget.ciclo);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Detalle creado.'),
                        backgroundColor: Colors.green,
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

  Future<void> crearDetalle(String ciclo) async {
    final url =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/CrearDetalleTutoria.php';

    Map<String, String> datosFormulario = {
      'NUMEROSESION': _numeroSesionController.text,
      'NOMBRE_EST': _nombreEstudianteController.text,
      'DOCUMENTO_EST': _documentoEstudianteController.text,
      'CODIGO_EST': _codigoEstudianteController.text,
      'ACTIVIDAD': _actividadController?.text ?? '',
      'ACUERDO': _acuerdosController?.text ?? '',
      'ASISTENCIA': _asistenciaController.text,
      'FECH_INICIO': _InicioTutoriaController!.text,
      'FECH_FIN': _finTutoriaController!.text,
      'CURSO': _cursoController!.text,
      'DOC_DOC': globalCodigoDocente,
      'CICLO': ciclo,
    };

    print('Datos del formulario del detalle xD: $datosFormulario');

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
