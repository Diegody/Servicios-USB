import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      home: IcetexE2ScreenE(),
    );
  }
}

class IcetexE2ScreenE extends StatefulWidget {
  final OpcionesSeleccionadas opcionesSeleccionadas;

  IcetexE2ScreenE({OpcionesSeleccionadas? opcionesSeleccionadas})
      : this.opcionesSeleccionadas = opcionesSeleccionadas ??
            OpcionesSeleccionadas(
                nivelAcademico: '', programaAcademico: '', ciclo: '');

  @override
  _IcetexE2ScreenEState createState() => _IcetexE2ScreenEState();
}

class _IcetexE2ScreenEState extends State<IcetexE2ScreenE> {
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
  String? selectedFileName1;
  String? selectedFileName2;
  String? selectedFileName3;
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

  bool _areAllFilesSelected() {
    return pdfPath1 != null && pdfPath2 != null && pdfPath3 != null;
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
        title: Text('Renovación ICETEX'),
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
              _buildSectionTitle('Documentos Requeridos'),
              Text(
                'Seleccione el archivo correspondiente. Cuando desee '
                'enviarlos oprima el check de políticas seguido del botón "Enviar Solicitud". Por favor '
                'verifique los archivos seleccionados antes del envío de la solicitud, solo se permite PDF. Puede '
                'reemplazar o cancelar la selección de cualquier archivo antes de realizar el envío. ',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Cargue aquí la orden de matrícula. *',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickPDF1(),
                    child: Text(
                      'SELECCIONAR ORDEN MATRICULA',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (selectedFileName1 != null)
                    Text('Archivo seleccionado: $selectedFileName1'),
                  SizedBox(height: 20),
                  Text(
                    'Cargue aquí formato de actualización de datos. Recuerde diligenciar los campos '
                    'de ciudad, fecha y en el caso de la firma sólo la línea que contiene su número de '
                    'documento, las tres líneas siguientes son para recibido de la universidad. *',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF2(),
                    child: Text(
                      'SELECCIONAR FORMATO DE DATOS',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 10),
                  if (selectedFileName2 != null)
                    Text('Archivo seleccionado: $selectedFileName2'),
                  SizedBox(height: 20),
                  Text(
                    'Cargue aquí el tabulado de notas descargado desde la plataforma Asis: Recuerde que el '
                    'promedio permitido para renovar su crédito con ICETEX es 3.0 en adelante, si se encuentra '
                    'por debajo de éste promedio no podemos proceder con la solicitud. *',
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _pickPDF3(),
                    child: Text(
                      'SELECCIONAR TABULADO DE NOTAS',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (selectedFileName3 != null)
                    Text('Archivo seleccionado: $selectedFileName3'),
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
                  backgroundColor: Colors.orange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (pdfPath1 == null || pdfPath2 == null || pdfPath3 == null) {
      print(
          'Por favor, seleccione todos los archivos antes de enviar la solicitud.');
      return;
    }
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
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/ICETEX/EnvioDatosRenovacion.php'),
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

          List<int> pdfBytes1 = await File(pdfPath1!).readAsBytes();
          String pdfBase64_1 = base64Encode(pdfBytes1);
          print('Contenido PDF 1: ${pdfBase64_1.substring(0, 20)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_1, selectedFileName1!);

          List<int> pdfBytes2 = await File(pdfPath2!).readAsBytes();
          String pdfBase64_2 = base64Encode(pdfBytes2);
          print('Contenido PDF 2: ${pdfBase64_2.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_2, selectedFileName2!);

          List<int> pdfBytes3 = await File(pdfPath3!).readAsBytes();
          String pdfBase64_3 = base64Encode(pdfBytes3);
          print('Contenido PDF 3: ${pdfBase64_3.substring(0, 50)}...');
          print('************************************');
          await enviarArchivosPDF(idProceso, pdfBase64_3, selectedFileName3!);

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
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/ICETEX/EnvioArchivosRenovacion.php';
    try {
      Map<String, dynamic> requestBody = {
        'ID_PROCESO': idProceso,
        'pdf_file': pdfBase64,
        "pdf_file_name": pdfFileName,
      };

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
                      MaterialPageRoute(
                          builder: (context) => IcetexE2ScreenE(
                                opcionesSeleccionadas: null,
                              )),
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
