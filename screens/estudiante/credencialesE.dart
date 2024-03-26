import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:servicios/screens/estudiante/creditoE.dart';
import 'package:servicios/screens/estudiante/simuladorE.dart';
import 'package:servicios/screens/estudiante/tutoriaE.dart';
import '../../auth.dart';
import '../../globals.dart';
import '../login.dart';
import 'credencialesE2.dart';
import 'horarioE.dart';
import 'icetexE.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CredencialesEScreenE(),
    );
  }
}

class CredencialesEScreenE extends StatefulWidget {
  @override
  _CredencialesEScreenEState createState() => _CredencialesEScreenEState();
}

class _CredencialesEScreenEState extends State<CredencialesEScreenE> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _idController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  // MaskTextInputFormatter _dateMaskFormatter = MaskTextInputFormatter(
  //     mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    Locale myLocale = Localizations.localeOf(context);
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextStyle? style = theme.textTheme.subtitle1;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      locale: myLocale,
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
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restablecer Credenciales'),
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
              TextField(
                controller: _idController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Número de identificación',
                  hintText: 'Ingrese el documento',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16),
              DateTimeField(
                format: DateFormat('dd/MM/yyyy'),
                controller: _dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Fecha de nacimiento',
                  hintText: 'Seleccione la fecha',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                onShowPicker: (context, currentValue) async {
                  await _selectDate(context);
                  return selectedDate;
                },
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

                    try {
                      final response = await http.post(
                        Uri.parse(
                          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Credenciales/Validacion.php',
                        ),
                        body: {
                          'identificacion': _idController.text,
                          'fecha': _dateController.text,
                        },
                      );
                      Navigator.pop(context);
                      if (response.statusCode == 200) {
                        Map<String, dynamic> data = json.decode(response.body);

                        print('Respuesta del servidor: ${response.body}');

                        String usuarioAsis = data['USUARIO_ASIS']?.trim() ?? '';
                        String correoInstitucional =
                            data['CORREO_INSTITUCIONAL']?.trim() ?? '';

                        print('Usuario ASIS: $usuarioAsis');
                        print('Correo Institucional: $correoInstitucional');

                        if (usuarioAsis.isNotEmpty &&
                            correoInstitucional.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CredencialesE2ScreenE(
                                usuarioAsis: data['USUARIO_ASIS'],
                                correoInstitucional:
                                    data['CORREO_INSTITUCIONAL'],
                                correoPersonal: data['CORREO_PERSONAL'],
                                tipo: data['TIPO'],
                                documento: data['DOCUMENTO'],
                                emplid: data['CODIGO'],
                                fecha: data['FECHA_NACIMIENTO'],
                              ),
                            ),
                          );
                        } else {
                          print(
                              'Mostrar Snackbar: No se encontraron resultados');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'No se encontraron resultados para esta búsqueda.',
                              ),
                              duration: Duration(seconds: 5),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error en la solicitud'),
                            duration: Duration(seconds: 5),
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
