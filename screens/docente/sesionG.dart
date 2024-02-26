import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/screens/docente/sesionGD.dart';

class SesionGVScreenD extends StatefulWidget {
  final String idGrupo;

  SesionGVScreenD({required this.idGrupo});

  @override
  _SesionGVScreenDState createState() => _SesionGVScreenDState();
}

class _SesionGVScreenDState extends State<SesionGVScreenD> {
  List<Map<String, dynamic>> _sessionDetails = [];
  bool _isLoading = true;
  String _searchText = '';
  bool _mostrarFormulario = false;

  @override
  void initState() {
    super.initState();
    fetchSessionDetails();
  }

  List<Map<String, dynamic>> _searchResults() {
    if (_searchText.isEmpty) {
      return _sessionDetails;
    } else {
      return _sessionDetails.where((session) {
        return session.values.any((value) =>
            value.toString().toLowerCase().contains(_searchText.toLowerCase()));
      }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver Sesiones Grupo'),
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            )
          : _sessionDetails.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay ninguna sesión para el estudiante',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SesionGScreenD(
                                idGrupo: '',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Crear sesión de tutoría',
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
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Buscar tutorías',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchText = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SesionGScreenD(
                                idGrupo: '',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Crear sesión de tutoría',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSectionTitle('Tutorías disponibles'),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            dataTableTheme: DataTableThemeData(
                              headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.orange,
                              ),
                            ),
                          ),
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('DETALLE')),
                              DataColumn(label: Text('SESION')),
                              DataColumn(label: Text('PERIODO ACADEMICO')),
                              DataColumn(label: Text('TIPO TUTORIA')),
                              DataColumn(label: Text('FACULTAD')),
                              DataColumn(label: Text('PROGRAMA')),
                              DataColumn(label: Text('NOMBRE CURSO')),
                              DataColumn(label: Text('PROFESOR RESPONSABLE')),
                              DataColumn(label: Text('TEMATICA')),
                              DataColumn(label: Text('MODALIDAD')),
                              DataColumn(label: Text('METODOLOGIA')),
                              DataColumn(label: Text('LUGAR')),
                              DataColumn(label: Text('DOCUMENTO')),
                              DataColumn(label: Text('GRUPO')),
                              DataColumn(label: Text('FECHA TUTORIA')),
                            ],
                            rows: _searchResults()
                                .map(
                                  (session) => DataRow(
                                    cells: [
                                      DataCell(
                                        IconButton(
                                          icon: Icon(Icons.info),
                                          onPressed: () {},
                                        ),
                                      ),
                                      DataCell(Text(
                                          session['NUMEROSESION'].toString())),
                                      DataCell(Text(session['PERIODOACADEMICO']
                                          .toString())),
                                      DataCell(Text(
                                          session['TIPOTUTORIA'].toString())),
                                      DataCell(
                                          Text(session['FACULTAD'].toString())),
                                      DataCell(
                                          Text(session['PROGRAMA'].toString())),
                                      DataCell(Text(session['NOMBREDELCURSO']
                                          .toString())),
                                      DataCell(Text(
                                          session['PROFESORRESPONSABLE']
                                              .toString())),
                                      DataCell(
                                          Text(session['TEMATICA'].toString())),
                                      DataCell(Text(
                                          session['MODALIDAD'].toString())),
                                      DataCell(Text(
                                          session['METODOLOGIA'].toString())),
                                      DataCell(
                                          Text(session['LUGAR'].toString())),
                                      DataCell(Text(session['DOCUMENTOPROFESOR']
                                          .toString())),
                                      DataCell(
                                          Text(session['GRUPO'].toString())),
                                      DataCell(Text(
                                          session['FECHATUTORIA'].toString())),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      floatingActionButton: _mostrarFormulario
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _mostrarFormulario = false;
                });
              },
              child: Icon(Icons.close),
              backgroundColor: Colors.red,
            )
          : null,
    );
  }

  Future<void> fetchSessionDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/VerSesionGrupal.php'),
        body: {
          'ID_GRUPO': widget.idGrupo,
        },
      );

      print("Dato enviado ${widget.idGrupo}");

      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        print("Status code: ${response.statusCode}");
        print('Tipo de respuesta: ${jsonData.runtimeType}');

        if (jsonData is List) {
          setState(() {
            _sessionDetails = List<Map<String, dynamic>>.from(jsonData
                .map((item) => Map<String, dynamic>.from(item))
                .toList());
            _isLoading = false;
            print('Detalles de la sesión: $_sessionDetails');
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          print('Respuesta inesperada del servidor: ${response.body}');
        }
        print('Respuesta del servidor: ${response.body}');
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Error en la solicitud al servidor: ${response.statusCode}');
        throw Exception('Failed to load session details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Excepción: $e');
      throw Exception('Failed to load session details');
    }
  }
}
