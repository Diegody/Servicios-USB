import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE.dart';
import 'horarioE.dart';
import 'icetexE.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SimuladorE2ScreenE(
        programaAcademicoID: '',
        selectedOpcionFinanciacion: '',
      ),
    );
  }
}

class SimuladorE2ScreenE extends StatefulWidget {
  final String programaAcademicoID;
  final String selectedOpcionFinanciacion;

  SimuladorE2ScreenE({
    required this.programaAcademicoID,
    required this.selectedOpcionFinanciacion,
  });

  @override
  _SimuladorE2ScreenEState createState() => _SimuladorE2ScreenEState();
}

class _SimuladorE2ScreenEState extends State<SimuladorE2ScreenE> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _cuotaInicialController = TextEditingController();
  final TextEditingController _financiacionController = TextEditingController();
  final TextEditingController _porcentajeCIController = TextEditingController();
  final TextEditingController _numeroCuotasController = TextEditingController();
  final TextEditingController _interesCteController = TextEditingController();
  final TextEditingController _interesMraController = TextEditingController();

  double _sumaCapital = 0;
  double _sumaInteresCorriente = 0;
  double _sumaValorCuota = 0;

  Map<String, dynamic>? _formData;
  List<Map<String, dynamic>> _amortizacionData = [];

  @override
  void initState() {
    super.initState();

    getValores(widget.programaAcademicoID, widget.selectedOpcionFinanciacion)
        .then((dataList) {
      if (dataList.isNotEmpty) {
        final Map<String, dynamic> data = dataList[0];
        print(data);
        setState(() {
          _formData = data;
          _cuotaInicialController.text = _formData?['CUOTA_INICIAL'] ?? '';
          _financiacionController.text = _formData?['OPCFIN_DESCR'] ?? '';
          _porcentajeCIController.text =
              _formData?['OPCFIN_CUOTA_INICIAL'] ?? '';
          _numeroCuotasController.text = _formData?['NUM_CUOTAS'] ?? '';
          _interesCteController.text =
              _formData?['TASA_InteresCORRIENTE'] ?? '';
          _interesMraController.text = _formData?['OPCFIN_TASA_INTMOR'] ?? '';
        });
        _calcularSumas();
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    }).catchError((error) {
      print('Error al cargar datos (Autocompletado): $error');
    });

    getValoresAmortizacion(
            widget.programaAcademicoID, widget.selectedOpcionFinanciacion)
        .then((dataList) {
      if (dataList.isNotEmpty) {
        setState(() {
          _amortizacionData = List<Map<String, dynamic>>.from(dataList);
        });
        _calcularSumas();
      } else {
        throw Exception('Respuesta inesperada del servidor');
      }
    }).catchError((error) {
      print('Error al cargar datos de amortización: $error');
    });
  }

  void _calcularSumas() {
    if (_amortizacionData.isNotEmpty) {
      double sumaCapital = 0;
      double sumaInteresCorriente = 0;
      double sumaValorCuota = 0;

      _amortizacionData.forEach((cuota) {
        sumaCapital +=
            double.parse(cuota['Capital'].replaceAll(',', '').substring(1));
        sumaInteresCorriente += double.parse(
            cuota['Interes_Corrient'].replaceAll(',', '').substring(1));
        sumaValorCuota +=
            double.parse(cuota['Valor_Cuota'].replaceAll(',', '').substring(1));
      });

      setState(() {
        _sumaCapital = sumaCapital;
        _sumaInteresCorriente = sumaInteresCorriente;
        _sumaValorCuota = sumaValorCuota;
      });
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

  Widget _buildAmortizationItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTotalItem(String label, double value) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            ' \$${NumberFormat.decimalPattern().format(value)}',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Datos de la Simulación'),
              _buildTextField('Financiación', 'Financiación seleccionada',
                  _financiacionController),
              SizedBox(height: 16),
              _buildTextField('Cuota Inicial', 'Valor cuota inicial',
                  _cuotaInicialController),
              SizedBox(height: 16),
              _buildSectionTitle('Resumen Financiación'),
              DataTable(
                columns: [
                  DataColumn(
                    label: Text(
                      'Atributo',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Valor',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Porcentaje Inicial')),
                    DataCell(Text(_porcentajeCIController.text)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Cuota Inicial')),
                    DataCell(Text(_cuotaInicialController.text)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Número Cuotas')),
                    DataCell(Text(_numeroCuotasController.text)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Interes Corriente')),
                    DataCell(Text(_interesCteController.text)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Interes Mora')),
                    DataCell(Text(_interesMraController.text)),
                  ]),
                ],
              ),
              SizedBox(height: 16),
              _buildSectionTitle('Amortización del Crédito Periodo Mensual'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _amortizacionData.length,
                itemBuilder: (context, index) {
                  final cuota = _amortizacionData[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cuota Nº ${cuota['Num_Cuotas']}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildAmortizationItem('Capital', cuota['Capital']),
                          _buildAmortizationItem(
                              'Días Crédito', cuota['Dias_Credito']),
                          _buildAmortizationItem(
                              'Interés Corriente', cuota['Interes_Corrient']),
                          _buildAmortizationItem(
                              'Valor Cuota', cuota['Valor_Cuota']),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                children: [
                  _buildTotalItem('Capital Total', _sumaCapital),
                  _buildTotalItem(
                      'Interés Corriente Total', _sumaInteresCorriente),
                  _buildTotalItem('Valor Cuota Total', _sumaValorCuota),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Para realizar algún tramite, solicitud o tener mayor información, por favor '
                'dirigase a la Unidad de Credito y Cartera, ubicada en el Edificio Diego Barroso oficina 103.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getValores(
      String programa, String opcFinc) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/SimuladorFinanciero/ValorCuotaInicial.php'),
      body: {'PROGRAMA_ACADEMICO': programa, 'OPC_FINANCIACION': opcFinc},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataList = json.decode(response.body);

      if (dataList.isNotEmpty && dataList[0] is Map<String, dynamic>) {
        return dataList.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'El servidor no devolvió datos válidos para el usuario con el programa "$programa" y opción de financiación "$opcFinc"');
      }
    } else {
      throw Exception('Error al cargar datos: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getValoresAmortizacion(
      String programa, String opcFinc) async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/SimuladorFinanciero/ConsultaAmortizacion.php'),
      body: {'PROGRAMA_ACADEMICO': programa, 'OPC_FINANCIACION': opcFinc},
    );

    if (response.statusCode == 200) {
      print('Datos de Amortización: ${response.body}');
      final List<dynamic> dataList = json.decode(response.body);

      if (dataList.isNotEmpty && dataList[0] is Map<String, dynamic>) {
        return dataList.cast<Map<String, dynamic>>();
      } else {
        throw Exception(
            'El servidor no devolvió datos válidos para el usuario con el programa "$programa" y opción de financiación "$opcFinc"');
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
                          builder: (context) => SimuladorE2ScreenE(
                                programaAcademicoID: '',
                                selectedOpcionFinanciacion: '',
                              )),
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
