import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/icetexE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE.dart';
import 'horarioE.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreditoE2ScreenE(),
    );
  }
}

class CreditoE2ScreenE extends StatefulWidget {
  final OpcionesSeleccionadasC opcionesSeleccionadasC;

  CreditoE2ScreenE({OpcionesSeleccionadasC? opcionesSeleccionadasC})
      : this.opcionesSeleccionadasC = opcionesSeleccionadasC ??
            OpcionesSeleccionadasC(
                nivelAcademico: '', programaAcademico: '', ciclo: '');

  @override
  _CreditoE2ScreenEState createState() => _CreditoE2ScreenEState();
}

class _CreditoE2ScreenEState extends State<CreditoE2ScreenE> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _documentoController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _programaAcademicoIDController =
      TextEditingController();
  final TextEditingController _vinculacionController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _nivelAcademicoController =
      TextEditingController();
  final TextEditingController _programaAcademicoController =
      TextEditingController();
  final TextEditingController _valorMatriculaController =
      TextEditingController();
  final TextEditingController _cicloController = TextEditingController();
  final TextEditingController _fechaPagoController = TextEditingController();
  final TextEditingController _ValorCuotaIDController = TextEditingController();
  final TextEditingController _valorFinanciadoController =
      TextEditingController();

  Future<List<Map<String, dynamic>>>? loadDataFuture;

  Map<String, dynamic>? _formData;

  String? pdfPath1;
  String? pdfPath2;
  String? pdfPath3;
  String? pdfPath4;
  String? pdfPath5;
  String? pdfPath6;
  String? pdfPath7;
  String? pdfPath8;
  String? pdfPath9;
  String? pdfPath10;
  String? pdfPath11;
  String? pdfPath12;
  String? pdfPath13;

  String? selectedFileName1;
  String? selectedFileName2;
  String? selectedFileName3;
  String? selectedFileName4;
  String? selectedFileName5;
  String? selectedFileName6;
  String? selectedFileName7;
  String? selectedFileName8;
  String? selectedFileName9;
  String? selectedFileName10;
  String? selectedFileName11;
  String? selectedFileName12;
  String? selectedFileName13;

  bool allFilesSelected = false;
  bool acceptedTerms = false;

  @override
  void initState() {
    super.initState();
    _documentoController.text = globalDocumento!;

    fetchData(globalDocumento!).then((dataList) {
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList[0];
        print('Datos del estudiante en IE2: $data');
        setState(() {
          _formData = data;
          _nationalIdController.text = _formData?['NATIONAL_ID'] ?? '';
          _vinculacionController.text = _formData?['VINCULACION'] ?? '';
          _nombreController.text = _formData?['NOMBRES'] ?? '';
          _apellidoController.text = _formData?['APELLIDOS'] ?? '';
          _telefonoController.text = _formData?['PHONE'] ?? '';
          _correoController.text = _formData?['EMAIL_ADDR'] ?? '';
          _nivelAcademicoController.text = _formData?['NIVEL'] ?? '';
          _programaAcademicoIDController.text = _formData?['ACAD_PROG'] ?? '';
          _programaAcademicoController.text = _formData?['PROGRAMA'] ?? '';
          _valorMatriculaController.text = _formData?['VALOR'] ?? '';
          _cicloController.text = _formData?['CICLO'] ?? '';
          _fechaPagoController.text = '';
          _valorFinanciadoController.text = _formData?['CUOTA_INICIAL'] ?? '';
          _ValorCuotaIDController.text = _formData?['R'] ?? '';
        });
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    }).catchError((error) {
      print('Error al cargar datos (Autocompletado): $error');
    });
  }

  Future<void> _pickPDF1() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath1 = pdfPath;
          selectedFileName1 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 1: $e');
    }
  }

  Future<void> _pickPDF2() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        setState(() {
          pdfPath2 = pdfPath;
          selectedFileName2 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 2: $e');
    }
  }

  Future<void> _pickPDF3() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath3 = pdfPath;
          selectedFileName3 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 3: $e');
    }
  }

  Future<void> _pickPDF4() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath4 = pdfPath;
          selectedFileName4 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 4: $e');
    }
  }

  Future<void> _pickPDF5() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath5 = pdfPath;
          selectedFileName5 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 4: $e');
    }
  }

  Future<void> _pickPDF6() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath6 = pdfPath;
          selectedFileName6 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 6: $e');
    }
  }

  Future<void> _pickPDF7() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath7 = pdfPath;
          selectedFileName7 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 7: $e');
    }
  }

  Future<void> _pickPDF8() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath8 = pdfPath;
          selectedFileName8 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 8: $e');
    }
  }

  Future<void> _pickPDF9() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath9 = pdfPath;
          selectedFileName9 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 9: $e');
    }
  }

  Future<void> _pickPDF10() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath10 = pdfPath;
          selectedFileName10 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 10: $e');
    }
  }

  Future<void> _pickPDF11() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath11 = pdfPath;
          selectedFileName11 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 11: $e');
    }
  }

  Future<void> _pickPDF12() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath12 = pdfPath;
          selectedFileName12 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 12: $e');
    }
  }

  Future<void> _pickPDF13() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String pdfPath = result.files.single.path!;
        String pdfFileName = result.files.single.name;

        List<int> pdfBytes = await File(pdfPath).readAsBytes();
        // ignore: unused_local_variable
        String pdfBase64 = base64Encode(pdfBytes);

        if (pdfBytes.length > (2 * 1024 * 1024)) {
          print('Error: El tamaño del archivo supera los 2 MB.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('El tamaño del archivo "$pdfFileName" supera los 2 MB.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        // Actualizar el estado solo si el archivo es válido
        setState(() {
          pdfPath13 = pdfPath;
          selectedFileName13 = pdfFileName;
          allFilesSelected = _areAllFilesSelected();
        });
      }
    } catch (e) {
      print('Error al seleccionar el archivo PDF 13: $e');
    }
  }

  bool _areAllFilesSelected() {
    return pdfPath1 != null &&
        pdfPath2 != null &&
        pdfPath3 != null &&
        pdfPath4 != null &&
        pdfPath5 != null &&
        pdfPath6 != null &&
        pdfPath7 != null;
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
      String label, String hint, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (controller.text.isEmpty) {
          return 'Por favor, ingrese $label';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crédito Directo USB'),
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
      // drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Documentos Requeridos'),
              Text(
                'Seleccione el archivo correspondiente. Cuando desee '
                'enviarlos oprima el check de políticas seguido del botón "Enviar Solicitud". Por favor '
                'verifique los archivos seleccionados antes del envío de la solicitud, solo se permite PDF. Puede '
                'reemplazar o cancelar la selección de cualquier archivo antes de realizar el envío. ',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              Column(
                children: [
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Formulario de solicitud de crédito diligenciado y firmado. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF1(),
                    child: Text(
                      'SELECCIONAR FORMULARIO',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(
                          Size(320, 20)), // Especifica el tamaño deseado
                      backgroundColor: MaterialStateProperty.all(
                          Colors.orange), // Color de fondo del botón
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName1 != null)
                    Text('Archivo seleccionado: $selectedFileName1'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Carta de respuesta emitida por Vicerrectoría '
                      'Financiera donde indica número de cuotas y fechas. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF2(),
                    child: Text(
                      'SELECCIONAR CARTA RESPUESTA',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName2 != null)
                    Text('Archivo seleccionado: $selectedFileName2'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Copia del documento de identidad del '
                      'estudiante. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF3(),
                    child: Text(
                      'SELECCIONAR DOCUMENTO ESTUDIANTE',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName3 != null)
                    Text('Archivo seleccionado: $selectedFileName3'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Copia del documento de identidad del codeudor. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF4(),
                    child: Text(
                      'SELECCIONAR DOCUMENTO CODEUDOR',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName4 != null)
                    Text('Archivo seleccionado: $selectedFileName4'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Carta de instrucciones Firmada, Con huella, datos en los campos de firma '
                      'únicamente, y Autenticada por estudiante y codeudor. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF5(),
                    child: Text(
                      'SELECCIONAR CARTA INSTRUCCIONES',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName5 != null)
                    Text('Archivo seleccionado: $selectedFileName5'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Clausula compromisoria diligenciada únicamente en los campos de '
                      'Firma y datos y autenticada por estudiante y codeudor. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF6(),
                    child: Text(
                      'SELECCIONAR CLAUSULA',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName6 != null)
                    Text('Archivo seleccionado: $selectedFileName6'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Pagaré únicamente diligenciado en la parte de firma y huellas, '
                      'por estudiante y codeudor, Se recuerda que el pagaré no se '
                      'autentica, de hacerlo se tendrá que repetir. *',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF7(),
                    child: Text(
                      'SELECCIONAR PAGARÉ',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName7 != null)
                    Text('Archivo seleccionado: $selectedFileName7'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Si indicó que es empleado adjuntar certificado laboral no mayor '
                      'a 30 días que incluya sueldo, fecha de ingreso y tipo de contrato.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF8(),
                    child: Text(
                      'SELECCIONAR CERTIFICADO LABORAL',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName8 != null)
                    Text('Archivo seleccionado: $selectedFileName8'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Si indicó que es empleado adjuntar certificado de ingresos '
                      'y retenciones del año inmediatamente anterior en FORMATO 220 DIAN.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF9(),
                    child: Text(
                      'SELECCIONAR CERTIFICADO I/R',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName9 != null)
                    Text('Archivo seleccionado: $selectedFileName9'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Adjuntar declaración de renta (Si está obligado a declarar).',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF10(),
                    child: Text(
                      'SELECCIONAR DECLARACIÓN RENTA',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName10 != null)
                    Text('Archivo seleccionado: $selectedFileName10'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Si indicó que es independiente, adjuntar certificado '
                      'de ingresos por un contador el cual debe incluir copia de la cédula y tarjeta profesional del contador.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF11(),
                    child: Text(
                      'SELECCIONAR CERTIFICADO INGRESOS',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName11 != null)
                    Text('Archivo seleccionado: $selectedFileName11'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'En caso de presentar ingresos adicionales, adjuntar '
                      'certificado de ingresos por un contador el cual debe incluir copia de la cédula y tarjeta profesional del contador.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF12(),
                    child: Text(
                      'SELECCIONAR CERTIFICADO INGRESOS',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName12 != null)
                    Text('Archivo seleccionado: $selectedFileName12'),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context)
                        .size
                        .width, // Puedes ajustar esto según tus necesidades
                    child: Text(
                      'Si indicó que es independiente, y es persona jurídica, '
                      'certificado de Cámara y Comercio no mayor a 30 días.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF13(),
                    child: Text(
                      'SELECCIONAR DOCUMENTO',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all(Size(320, 20)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                    ),
                  ),
                  SizedBox(height: 05),
                  if (selectedFileName13 != null)
                    Text('Archivo seleccionado: $selectedFileName13'),
                  SizedBox(height: 25),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Theme(
                    data: ThemeData(
                      unselectedWidgetColor: Colors.orange,
                    ),
                    child: Checkbox(
                      value: acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          acceptedTerms = value!;
                        });
                      },
                      activeColor: Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(
                            text: 'He leído, acepto y autorizo las ',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                          TextSpan(
                            text: 'políticas de uso y privacidad',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 10,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                const url =
                                    'https://www.usbbog.edu.co/politicas-de-uso-y-privacidad/';
                                launch(url);
                              },
                          ),
                          TextSpan(
                            text: '. *',
                            style: TextStyle(fontSize: 10, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed:
                    acceptedTerms && allFilesSelected ? _submitForm : null,
                child: Text(
                  'Enviar Solicitud',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    // Verificar que los archivos estén seleccionados
    if (pdfPath1 == null ||
        pdfPath2 == null ||
        pdfPath3 == null ||
        pdfPath4 == null ||
        pdfPath5 == null ||
        pdfPath6 == null ||
        pdfPath7 == null) {
      print(
          'Por favor, seleccione todos los archivos antes de enviar la solicitud.');
      return;
    }

    // Crear una instancia de http.Client para realizar la petición
    final client = http.Client();

    try {
      String documento = _documentoController.text;
      String ciclo = _cicloController.text;
      String nombres = _nombreController.text;
      String apellidos = _apellidoController.text;
      String correo = _correoController.text;
      String telefono = _telefonoController.text;
      String programa = _programaAcademicoController.text;
      String id_programa = _programaAcademicoIDController.text;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ));
        },
      );

      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/CreditoDirectoUSB/EnvioDatosRenovacion.php'),
        body: {
          'DOCUMENTO': documento,
          'CICLO': ciclo,
          'NOMBRES': nombres,
          'APELLIDOS': apellidos,
          'CORREO': correo,
          'TELEFONO': telefono,
          'PROGRAMA': programa,
          'COD_PROGRAMA': id_programa,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          String idProceso = responseData['ID_PROCESO'].toString();
          print(
              'Solicitud enviada exitosamente. Respuesta del servidor: ${response.body}');
          print('************************************');

          // Archivo 1
          List<int> pdfBytes1 = await File(pdfPath1!).readAsBytes();
          String pdfBase64_1 = base64Encode(pdfBytes1);
          print('Contenido PDF 1: ${pdfBase64_1.substring(0, 20)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_1, selectedFileName1!);

          // Archivo 2
          List<int> pdfBytes2 = await File(pdfPath2!).readAsBytes();
          String pdfBase64_2 = base64Encode(pdfBytes2);
          print('Contenido PDF 2: ${pdfBase64_2.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_2, selectedFileName2!);

          // Archivo 3
          List<int> pdfBytes3 = await File(pdfPath3!).readAsBytes();
          String pdfBase64_3 = base64Encode(pdfBytes3);
          print('Contenido PDF 3: ${pdfBase64_3.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_3, selectedFileName3!);

          // Archivo 4
          List<int> pdfBytes4 = await File(pdfPath4!).readAsBytes();
          String pdfBase64_4 = base64Encode(pdfBytes4);
          print('Contenido PDF 4: ${pdfBase64_4.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_4, selectedFileName4!);

          // Archivo 5
          List<int> pdfBytes5 = await File(pdfPath5!).readAsBytes();
          String pdfBase64_5 = base64Encode(pdfBytes5);
          print('Contenido PDF 5: ${pdfBase64_5.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_5, selectedFileName5!);

          // Archivo 6
          List<int> pdfBytes6 = await File(pdfPath6!).readAsBytes();
          String pdfBase64_6 = base64Encode(pdfBytes6);
          print('Contenido PDF 6: ${pdfBase64_6.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_6, selectedFileName6!);

          // Archivo 7
          List<int> pdfBytes7 = await File(pdfPath7!).readAsBytes();
          String pdfBase64_7 = base64Encode(pdfBytes7);
          print('Contenido PDF 7: ${pdfBase64_7.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_7, selectedFileName7!);

          // Archivo 8
          List<int> pdfBytes8 = await File(pdfPath8!).readAsBytes();
          String pdfBase64_8 = base64Encode(pdfBytes8);
          print('Contenido PDF 8: ${pdfBase64_8.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_8, selectedFileName8!);

          // Archivo 9
          List<int> pdfBytes9 = await File(pdfPath9!).readAsBytes();
          String pdfBase64_9 = base64Encode(pdfBytes9);
          print('Contenido PDF 9: ${pdfBase64_9.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_9, selectedFileName9!);

          // Archivo 10
          List<int> pdfBytes10 = await File(pdfPath10!).readAsBytes();
          String pdfBase64_10 = base64Encode(pdfBytes10);
          print('Contenido PDF 10: ${pdfBase64_10.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_10, selectedFileName10!);

          // Archivo 11
          List<int> pdfBytes11 = await File(pdfPath11!).readAsBytes();
          String pdfBase64_11 = base64Encode(pdfBytes11);
          print('Contenido PDF 11: ${pdfBase64_11.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_11, selectedFileName11!);

          // Archivo 12
          List<int> pdfBytes12 = await File(pdfPath12!).readAsBytes();
          String pdfBase64_12 = base64Encode(pdfBytes12);
          print('Contenido PDF 12: ${pdfBase64_12.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_12, selectedFileName12!);

          // Archivo 13
          List<int> pdfBytes13 = await File(pdfPath13!).readAsBytes();
          String pdfBase64_13 = base64Encode(pdfBytes13);
          print('Contenido PDF 13: ${pdfBase64_13.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_13, selectedFileName13!);

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Solicitud enviada con éxito'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          print('Error al enviar la solicitud: ${responseData['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al enviar la solicitud.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error en la solicitud HTTP.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (error) {
      print('Error al enviar la solicitud: $error');
    } finally {
      client.close();
    }
  }

  Future<void> enviarArchivosPDF(
      String idProceso, String pdfBase64, String pdfFileName) async {
    final String url =
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/CreditoDirectoUSB/EnvioArchivosRenovacion.php';
    try {
      // Crear el cuerpo de la solicitud en formato JSON
      Map<String, dynamic> requestBody = {
        'ID_PROCESO': idProceso,
        'pdf_file': pdfBase64,
        "pdf_file_name": pdfFileName,
      };

      // Realizar la solicitud HTTP POST
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Respuesta del servidor: $jsonEncode(requestBody)');
      print('************************************');
      print('Respuesta del ID Proceso: $idProceso');
      print('************************************');
      print('Respuesta del pdf_file: $pdfBase64');
      print('************************************');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          print('Archivos enviado exitosamente.');
        } else {
          print('Error al enviar el archivo: ${responseData['message']}');
          print('************************************');
        }
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }

  Future<List<Map<String, dynamic>>> fetchData(String nationalId) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/SimuladorFinanciero/Autocompletado.php'),
      body: {'NATIONAL_ID': nationalId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);

      if (dataList.isNotEmpty && dataList[0] is Map<String, dynamic>) {
        return dataList.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'El servidor no devolvió datos válidos para el usuario con el ID nacional: $nationalId');
      }
    } else {
      throw Exception('Error al cargar datos: ${response.statusCode}');
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
                      // Imagen en el DrawerHeader
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
                    // Acción al hacer clic en "Horario de Clases"
                    Navigator.pop(context); // Cierra el Drawer

                    // Dirigirse a la nueva actividad (ventana)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HorarioEScreenE()), // Reemplaza 'HorarioScreen' con el nombre de tu nueva actividad
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.group),
                  title: Text('Solicitar Tutoría'),
                  onTap: () {
                    // Acción al hacer clic en "Horarios de Tutorías"
                    Navigator.pop(context); // Cierra el Drawer
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
                    // Acción al hacer clic en "Simulador Financiero"
                    Navigator.pop(context); // Cierra el Drawer
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
                    // Acción al hacer clic en ""
                    Navigator.pop(context); // Cierra el Drawer
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
                    // Acción al hacer clic en "Crédito Directo USB"
                    Navigator.pop(context); // Cierra el Drawer
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
                    // Acción al hacer clic en "Restablecer Credenciales"
                    Navigator.pop(context); // Cierra el Drawer
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
                    // Cierra el Drawer
                    Navigator.pop(context);
                    // Cierra la sesión utilizando el AuthManager
                    AuthManager.logout();
                    // Redirige al usuario a la pantalla de inicio de sesión
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cerrando sesión...'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Información adicional en toda la base del menú con las mismas propiedades
          Container(
            width: double.infinity, // Ancho máximo posible
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
