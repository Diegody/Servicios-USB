import 'package:flutter/material.dart';
import 'package:servicios/screens/estudiante/icetexE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE.dart';
import 'creditoE2.dart';
import 'horarioE.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CreditoEScreenE(),
    );
  }
}

class CreditoEScreenE extends StatefulWidget {
  @override
  _CreditoEScreenEState createState() => _CreditoEScreenEState();
}

class OpcionesSeleccionadasC {
  String nivelAcademico;
  String programaAcademico;
  String ciclo;

  OpcionesSeleccionadasC(
      {required this.nivelAcademico,
      required this.programaAcademico,
      required this.ciclo});
}

class _CreditoEScreenEState extends State<CreditoEScreenE> {
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

  String selectedOpcionLevel = '';
  String selectedOpcionPrograma = '';
  String selectedOpcionCiclo = '';
  List<Map<String, dynamic>> _opcionNivelAcademicoList = [];
  List<Map<String, dynamic>> _opcionProgramaAcademicoList = [];
  List<Map<String, dynamic>> _opcionCicloList = [];

  Future<List<Map<String, dynamic>>>? loadDataFuture;

  Map<String, dynamic>? _formData;

  @override
  void initState() {
    super.initState();
    _loadOpcNivelAcademico();
    _loadOpcProgramaAcademico();
    _loadOpcCiclo();
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

  Future<void> _loadOpcNivelAcademico() async {
    try {
      List<Map<String, dynamic>> opcLevelData = await getOpcLevel();

      setState(() {
        _opcionNivelAcademicoList = opcLevelData;

        if (_opcionNivelAcademicoList.isNotEmpty) {
          selectedOpcionLevel = _opcionNivelAcademicoList[0]['id'];
          print('Opción seleccionada el el DropDown: $selectedOpcionLevel');
        } else {
          selectedOpcionLevel = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionNivelAcademicoList = [];
        selectedOpcionLevel = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de financiación: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _loadOpcProgramaAcademico() async {
    try {
      List<Map<String, dynamic>> opcProgramaData =
          await getOpcPrograma(selectedOpcionLevel);

      setState(() {
        _opcionProgramaAcademicoList = opcProgramaData;

        if (_opcionProgramaAcademicoList.isNotEmpty) {
          selectedOpcionPrograma = _opcionProgramaAcademicoList[0]['id'];
        } else {
          selectedOpcionPrograma = 'Sin opciones disponibles';
        }
      });

      return opcProgramaData;
    } catch (e) {
      setState(() {
        _opcionProgramaAcademicoList = [];
        selectedOpcionPrograma = 'Error al cargar opciones';
      });
      print('Error al cargar opciones de financiación: $e');
      return [];
    }
  }

  Future<void> _loadOpcCiclo() async {
    try {
      List<Map<String, dynamic>> opcCicloData = await getOpcCiclo();

      setState(() {
        _opcionCicloList = opcCicloData;

        if (_opcionCicloList.isNotEmpty) {
          selectedOpcionCiclo = _opcionCicloList[0]['id'];
          print('Opción seleccionada el el DropDown: $selectedOpcionCiclo');
        } else {
          selectedOpcionCiclo = 'Sin opciones disponibles';
        }
      });
    } catch (e) {
      setState(() {
        _opcionCicloList = [];
        selectedOpcionCiclo = 'Error al cargar opciones';
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

  Widget _buildDropdownFieldWithLvlA(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionNivelAcademicoList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Text(map['text']),
        );
      }).toList(),
      value: selectedOpcionLevel.isNotEmpty ? selectedOpcionLevel : null,
      onChanged: (String? value) async {
        if (value != null) {
          setState(() {
            selectedOpcionLevel = value;
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

  Widget _buildDropdownFieldWithProgA(
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
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedOpcionPrograma = value;
          });
        }
      },
    );
  }

  Widget _buildDropdownFieldWithCiclo(
      String label, List<String> opciones, String identifier) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      items: _opcionCicloList.map((map) {
        return DropdownMenuItem<String>(
          value: map['id'],
          child: Text(map['text']),
        );
      }).toList(),
      value: selectedOpcionCiclo,
      validator: (value) {
        if (opciones.isEmpty || value == null || value.isEmpty) {
          return 'Por favor, seleccione $label';
        }
        return null;
      },
      onChanged: (String? value) {
        if (value != null) {
          setState(() {
            selectedOpcionCiclo = value;
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
        title: Text('Credito Directo USB'),
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
              _buildDropdownFieldWithCiclo(
                'Ciclo',
                _opcionCicloList.map((map) => map['text'].toString()).toList(),
                selectedOpcionCiclo,
              ),
              SizedBox(height: 16),
              _buildTextField(
                  'Documento', 'Ingrese el documento', _nationalIdController),
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
              SizedBox(height: 16),
              _buildDropdownFieldWithLvlA(
                'Nivel académico',
                _opcionCicloList.map((map) => map['text'].toString()).toList(),
                selectedOpcionLevel,
              ),
              SizedBox(height: 16),
              _buildDropdownFieldWithProgA(
                'Programa académico',
                _opcionProgramaAcademicoList
                    .map((map) => map['text'].toString())
                    .toList(),
                selectedOpcionPrograma,
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
                          ),
                        );
                      },
                    );
                    OpcionesSeleccionadasC opcionesSeleccionadasC =
                        OpcionesSeleccionadasC(
                      nivelAcademico: selectedOpcionLevel,
                      programaAcademico: selectedOpcionPrograma,
                      ciclo: selectedOpcionCiclo,
                    );

                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreditoE2ScreenE(
                          opcionesSeleccionadasC: opcionesSeleccionadasC,
                        ),
                      ),
                    );
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

  Future<List<Map<String, dynamic>>> getOpcLevel() async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/CreditoDirectoUSB/OpcionNivelAcademico.php'),
    );

    if (response.statusCode == 200) {
      print(
          'Cuerpo de la respuesta (Opciones de nivel academico): ${response.body}');

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

  Future<List<Map<String, dynamic>>> getOpcPrograma(String programa) async {
    final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/CreditoDirectoUSB/OpcionProgramaAcademico.php'),
        body: {'PROG_ACADEMICO': programa});

    if (response.statusCode == 200) {
      print(
          'Cuerpo de la respuesta (Opciones de programa academico): ${response.body}');

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

  Future<List<Map<String, dynamic>>> getOpcCiclo() async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/CreditoDirectoUSB/CicloAcademico.php'),
    );

    if (response.statusCode == 200) {
      print('Cuerpo de la respuesta (Opciones de ciclo): ${response.body}');

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
