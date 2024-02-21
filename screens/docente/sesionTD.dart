import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';
import 'package:servicios/screens/docente/crearTD.dart';
import 'package:servicios/screens/docente/detalleTD.dart';

class SesionTDScreenD extends StatefulWidget {
  final String ciclo;
  final String documento;

  const SesionTDScreenD({
    required this.ciclo,
    required this.documento,
  });

  @override
  _SesionTDScreenDState createState() => _SesionTDScreenDState();
}

class _SesionTDScreenDState extends State<SesionTDScreenD> {
  List<Map<String, dynamic>> _sessionDetails = [];
  bool _isLoading = true;
  String _searchText = '';
  bool _mostrarFormulario = false;

  TextEditingController _cicloController = TextEditingController();
  final TextEditingController _tipoTutoriaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSessionDetails(widget.ciclo, widget.documento);
    _cicloController.text = widget.ciclo;
  }

  Future<void> fetchSessionDetails(String ciclo, String documento) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/EstudianteConTutoria.php'),
      body: {
        'CICLO': ciclo,
        'DOC_EST': documento,
        'DOC_DOC': globalCodigoDocente
      },
    );

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      if (jsonData is List) {
        setState(() {
          _sessionDetails = List<Map<String, dynamic>>.from(
              jsonData.map((item) => Map<String, dynamic>.from(item)).toList());
          _isLoading = false;

          if (_sessionDetails.isNotEmpty) {
            _tipoTutoriaController.text =
                _sessionDetails[0]['TIPOTUTORIA'].toString();
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
      print('Respuesta: ${response.body}');
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load session details');
    }
  }

  void _navigateToDetalleScreen(
      String sesion, String nombreCurso, String fechaTutoria, String curso) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetalleTDScreenD(
          ciclo: widget.ciclo,
          documento: widget.documento,
          sesion: sesion,
          nombreCurso: nombreCurso,
          fechaTutoria: fechaTutoria,
          curso: curso,
        ),
      ),
    );
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
        title: Text('Detalles de la Sesión'),
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
                              builder: (context) => CrearTDScreenD(
                                ciclo: widget.ciclo,
                                documento: widget.documento,
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
                              builder: (context) => CrearTDScreenD(
                                ciclo: widget.ciclo,
                                documento: widget.documento,
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
                              DataColumn(label: Text('FECHA TUTORIA')),
                              DataColumn(label: Text('LUGAR')),
                              DataColumn(label: Text('DOCUMENTO')),
                            ],
                            rows: _searchResults()
                                .map(
                                  (session) => DataRow(
                                    cells: [
                                      DataCell(
                                        IconButton(
                                          icon: Icon(Icons.info),
                                          onPressed: () {
                                            _navigateToDetalleScreen(
                                              session['NUMEROSESION']
                                                  .toString(),
                                              session['NOMBREDELCURSO']
                                                  .toString(),
                                              session['FECHATUTORIA']
                                                  .toString(),
                                              session['NOMBREDELCURSO']
                                                  .toString(),
                                            );
                                          },
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
                                      DataCell(Text(
                                          session['FECHATUTORIA'].toString())),
                                      DataCell(
                                          Text(session['LUGAR'].toString())),
                                      DataCell(Text(
                                          session['DOCUMENTO'].toString())),
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
                // Ocultar el formulario cuando se presiona el botón de cerrar
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
}
