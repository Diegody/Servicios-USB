import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/screens/docente/detalleGD.dart';
import 'package:servicios/screens/docente/sesionGD.dart';

class SesionGVScreenD extends StatefulWidget {
  final String idGrupo;

  SesionGVScreenD({required this.idGrupo});

  @override
  _SesionGVScreenDState createState() => _SesionGVScreenDState();
}

class _SesionGVScreenDState extends State<SesionGVScreenD> {
  TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _sessionDetails = [];
  List<Map<String, dynamic>> _originalSessionDetails = [];
  bool _isLoading = true;
  bool _mostrarFormulario = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterData(_searchController.text);
    });
    fetchSessionDetails();
  }

  void _filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _sessionDetails =
            List<Map<String, dynamic>>.from(_originalSessionDetails);
      } else {
        _sessionDetails = _originalSessionDetails
            .where((item) => item.values.any((value) =>
                value.toString().toLowerCase().contains(query.toLowerCase())))
            .toList();
      }
    });
  }

  void _navigateToDetalleScreen(
      String sesion, String groupID, String curso, String tematica) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetalleTDScreenD(
            sesion: sesion, groupID: groupID, curso: curso, tematica: tematica),
      ),
    );
  }

  Widget _buildSessionList() {
    return _sessionDetails.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'No hay ninguna sesión disponible. Cree una.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SesionGScreenD(
                          idGrupo: widget.idGrupo,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Crear sesión de tutoría grupal',
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
        : SingleChildScrollView(
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
                rows: _sessionDetails
                    .map(
                      (session) => DataRow(
                        cells: [
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.info),
                              onPressed: () {
                                _navigateToDetalleScreen(
                                  session['NUMEROSESION'].toString(),
                                  session['GRUPO'].toString(),
                                  session['NOMBREDELCURSO'].toString(),
                                  session['TEMATICA'].toString(),
                                );
                              },
                            ),
                          ),
                          DataCell(Text(session['NUMEROSESION'].toString())),
                          DataCell(
                              Text(session['PERIODOACADEMICO'].toString())),
                          DataCell(Text(session['TIPOTUTORIA'].toString())),
                          DataCell(Text(session['FACULTAD'].toString())),
                          DataCell(Text(session['PROGRAMA'].toString())),
                          DataCell(Text(session['NOMBREDELCURSO'].toString())),
                          DataCell(
                              Text(session['PROFESORRESPONSABLE'].toString())),
                          DataCell(Text(session['TEMATICA'].toString())),
                          DataCell(Text(session['MODALIDAD'].toString())),
                          DataCell(Text(session['METODOLOGIA'].toString())),
                          DataCell(Text(session['LUGAR'].toString())),
                          DataCell(
                              Text(session['DOCUMENTOPROFESOR'].toString())),
                          DataCell(Text(session['GRUPO'].toString())),
                          DataCell(Text(session['FECHATUTORIA'].toString())),
                        ],
                      ),
                    )
                    .toList(),
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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                _buildSessionList(),
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

      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        print("Status code: ${response.statusCode}");
        print('Tipo de respuesta: ${jsonData.runtimeType}');

        if (jsonData is List) {
          setState(() {
            _originalSessionDetails = List<Map<String, dynamic>>.from(jsonData
                .map((item) => Map<String, dynamic>.from(item))
                .toList());
            _sessionDetails =
                List<Map<String, dynamic>>.from(_originalSessionDetails);
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
