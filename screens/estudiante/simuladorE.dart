import 'package:flutter/material.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/simuladorE2.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
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
      home: SimuladorEScreenE(),
    );
  }
}

class SimuladorEScreenE extends StatefulWidget {
  @override
  _SimuladorEScreenEState createState() => _SimuladorEScreenEState();
}

class _SimuladorEScreenEState extends State<SimuladorEScreenE> {
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

  String selectedOpcionFinanciacion = '';
  List<Map<String, dynamic>> _opcionFinanciacionList = [];

  Map<String, dynamic>? _formData;

  @override
  void initState() {
    super.initState();
    _loadOpcFinanciacion();
    _documentoController.text = globalDocumento!;

    fetchData(globalDocumento!).then((dataList) {
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList[0];
        print(data);
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

  Future<void> _loadOpcFinanciacion() async {
    try {
      print('Código del estudiante (globalDocumento): $globalDocumento');
      List<Map<String, dynamic>> opcFincData = await getOpcFinanciacion(
          globalDocumento!, _vinculacionController.text, _cicloController.text);

      setState(() {
        _opcionFinanciacionList = opcFincData;

        if (_opcionFinanciacionList.isNotEmpty) {
          selectedOpcionFinanciacion = _opcionFinanciacionList[0]['id'];
        } else {
          selectedOpcionFinanciacion = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionFinanciacionList = [];
        selectedOpcionFinanciacion = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de financiación: $e');
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

  Widget _buildDropdownFieldWithMap(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionFinanciacionList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Text(map['text']),
        );
      }).toList(),
      value: selectedOpcionFinanciacion,
      validator: (value) {
        if (opciones.isEmpty || value == null || value.isEmpty) {
          return 'Por favor, seleccione $label';
        }
        return null;
      },
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedOpcionFinanciacion = value;
          });
        }
      },
    );
  }

  Widget _buildDropdownFieldWithString(String label, List<String> opciones) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simulador Financiero'),
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
                  'Documento', 'Ingrese el documento', _nationalIdController),
              SizedBox(height: 16),
              _buildTextField('Vinculación', 'Vinculación del estudiante',
                  _vinculacionController),
              SizedBox(height: 16),
              _buildTextField('Nombre(s)', 'Ingrese el nombre del estudiante',
                  _nombreController),
              SizedBox(height: 16),
              _buildTextField('Apellidos', 'Ingrese el apellido del estudiante',
                  _apellidoController),
              SizedBox(height: 16),
              _buildTextField(
                  'Teléfono', 'Ingrese el teléfono', _telefonoController),
              SizedBox(height: 16),
              _buildTextField('Correo institucional', 'Ingrese el correo',
                  _correoController),
              SizedBox(height: 30),
              _buildSectionTitle('Nivel Académico'),
              _buildTextField(
                  'Nivél académico',
                  'Ingrese nivél académico al que pertenece',
                  _nivelAcademicoController),
              SizedBox(height: 16),
              _buildTextField(
                  'Programa académico',
                  'Ingrese el programa académico al que pertenece',
                  _programaAcademicoController),
              SizedBox(height: 16),
              _buildTextField('Valor matricula', 'Valor matricula',
                  _valorMatriculaController),
              SizedBox(height: 16),
              _buildDropdownFieldWithMap(
                'Opción de financiación',
                _opcionFinanciacionList
                    .map((map) => map['text'].toString())
                    .toList(),
                selectedOpcionFinanciacion,
              ),
              SizedBox(height: 16),
              _buildDropdownFieldWithString(
                'Fecha de pago',
                ['5 DÍAS HÁBILES', '20 DÍAS HÁBILES'],
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.orange),
                        ));
                      },
                    );

                    try {
                      String programaAcademicoID =
                          _programaAcademicoIDController.text;

                      final response = await http.post(
                        Uri.parse(
                          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/SimuladorFinanciero/ValorCuotaInicial.php',
                        ),
                        body: {
                          'PROGRAMA_ACADEMICO': programaAcademicoID,
                          'OPC_FINANCIACION': selectedOpcionFinanciacion,
                        },
                      );

                      Navigator.pop(context);

                      if (response.statusCode == 200) {
                        List<Map<String, dynamic>> dataList =
                            List<Map<String, dynamic>>.from(
                                json.decode(response.body).map((x) => x));

                        if (dataList.isNotEmpty) {
                          // ignore: unused_local_variable
                          Map<String, dynamic> data = dataList[0];

                          print('Respuesta del servidor: ${response.body}');

                          print(
                              'Opciones de Financiación: $_opcionFinanciacionList');
                          print(
                              'Estado del formulario: ${_formKey.currentState}');
                          print(
                              'Programa Académico ID: ${_programaAcademicoIDController.text}');
                          print(
                              'Opción de Financiación: $selectedOpcionFinanciacion');

                          if (programaAcademicoID.isNotEmpty &&
                              selectedOpcionFinanciacion.isNotEmpty) {
                            print(
                                'Programa ID antes de la navegación: $programaAcademicoID');
                            print(
                                'Opc financiación antes de la navegación: $selectedOpcionFinanciacion');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SimuladorE2ScreenE(
                                  programaAcademicoID: programaAcademicoID,
                                  selectedOpcionFinanciacion:
                                      selectedOpcionFinanciacion,
                                ),
                              ),
                            );
                          }
                        } else {
                          print(
                              'Error en el formato de la respuesta del servidor: $dataList');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Error en el formato de la respuesta del servidor',
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        print(
                            'Error en la solicitud al servidor: ${response.statusCode}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error en la solicitud al servidor'),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (error) {
                      print('Error: $error');
                    }
                  }
                },
                child: Text(
                  'Continuar',
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

Future<List<Map<String, dynamic>>> getOpcFinanciacion(
    String nationalId, String vinculacion, String ciclo) async {
  final response = await http.post(
    Uri.parse(
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/SimuladorFinanciero/OpcionFinanciacion.php'),
    body: {
      'NATIONAL_ID': nationalId,
      'VINCULACION': vinculacion,
      'CICLO': ciclo
    },
  );

  if (response.statusCode == 200) {
    print(
        'Cuerpo de la respuesta (Opciones de financiación): ${response.body}');

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
