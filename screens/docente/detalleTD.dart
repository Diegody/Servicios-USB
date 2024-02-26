import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';
import 'package:servicios/screens/docente/crearDD.dart';

class DetalleTDScreenD extends StatefulWidget {
  final String ciclo;
  final String documento;
  final String sesion;
  final String nombreCurso;
  final String fechaTutoria;
  final String curso;

  const DetalleTDScreenD({
    required this.ciclo,
    required this.documento,
    required this.sesion,
    required this.nombreCurso,
    required this.fechaTutoria,
    required this.curso,
  });

  @override
  _DetalleTDScreenDState createState() => _DetalleTDScreenDState();
}

class _DetalleTDScreenDState extends State<DetalleTDScreenD> {
  final TextEditingController? _nombreCursoController = TextEditingController();
  final TextEditingController? _nombreEstudianteController =
      TextEditingController();
  final TextEditingController? _codigoEstudianteController =
      TextEditingController();
  final TextEditingController? _fechaTutoriaController =
      TextEditingController();
  final TextEditingController? _cursoController = TextEditingController();

  List<Map<String, dynamic>> _sessionDetails = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _datosEstudiante(widget.documento);
    fetchSessionDetails(widget.ciclo, widget.documento, widget.sesion);
    _nombreCursoController!.text = widget.nombreCurso;
    _nombreEstudianteController!.text = '';
    _codigoEstudianteController!.text = '';
    _fechaTutoriaController!.text = widget.fechaTutoria;
    _cursoController!.text = widget.curso;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detallado'),
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
              ? Container(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Sesión ${widget.sesion} del curso de ${_nombreCursoController!.text}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Nombre del estudiante ${_nombreEstudianteController!.text}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No hay ningún detalle para esta sesión. Cree un detalle ahora.',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CrearDDScreenD(
                                  ciclo: widget.ciclo,
                                  documento: widget.documento,
                                  sesion: widget.sesion,
                                  nombre: _nombreEstudianteController.text,
                                  codigoEstudiante:
                                      _codigoEstudianteController!.text,
                                  fechaTutoria: _fechaTutoriaController!.text,
                                  curso: _cursoController!.text,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Crear detalle',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sesión ${_sessionDetails[0]['SESION']} del curso de ${_sessionDetails[0]['CURSO']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Nombre del estudiante ${_sessionDetails[0]['NOMBREESTUDIANTE']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Buscar',
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
                              builder: (context) => CrearDDScreenD(
                                ciclo: widget.ciclo,
                                documento: widget.documento,
                                sesion: _sessionDetails[0]['SESION'],
                                nombre: _sessionDetails[0]['NOMBREESTUDIANTE'],
                                codigoEstudiante: _sessionDetails[0]['CODIGO'],
                                fechaTutoria: _fechaTutoriaController!.text,
                                curso: _cursoController!.text,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Crear detalle',
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
                              DataColumn(label: Text('NOMBRES COMPLETOS')),
                              DataColumn(label: Text('DOCUMENTO')),
                              DataColumn(label: Text('CÓDIGO')),
                              DataColumn(label: Text('ACTIVIDAD REALIZADA')),
                              DataColumn(label: Text('ACUERDOS Y COMPROMISOS')),
                              DataColumn(label: Text('INICIO TUTORÍA')),
                              DataColumn(label: Text('FIN TUTORÍA')),
                              DataColumn(label: Text('ASISTENCIA')),
                              DataColumn(label: Text('CALIFICACIÓN HECHA')),
                            ],
                            rows: _searchResults()
                                .map(
                                  (session) => DataRow(
                                    cells: [
                                      DataCell(Text(session['NOMBREESTUDIANTE']
                                          .toString())),
                                      DataCell(Text(
                                          session['DOCUMENTO'].toString())),
                                      DataCell(
                                          Text(session['CODIGO'].toString())),
                                      DataCell(Text(
                                          session['ACTIVIDADREALIZADA']
                                              .toString())),
                                      DataCell(Text(
                                          session['ACUERDOSYCOMPROMISOS']
                                              .toString())),
                                      DataCell(Text(session['INICIO_TUTORIA']
                                          .toString())),
                                      DataCell(Text(
                                          session['FINAL_TUTORIA'].toString())),
                                      DataCell(Text(
                                          session['ASISTENCIA'].toString())),
                                      DataCell(Text(
                                          session['CALIFICACIONESTUDIANTE']
                                              .toString())),
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
    );
  }

  Future<void> fetchSessionDetails(
      String ciclo, String documento, String sesion) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/DetalleTutoria.php'),
      body: {
        'CICLO': ciclo,
        'DOC_EST': documento,
        'SESION': sesion,
        'DOC_DOC': globalCodigoDocente,
      },
    );

    if (response.statusCode == 200) {
      dynamic jsonData = json.decode(response.body);
      if (jsonData is List) {
        setState(() {
          _sessionDetails = List<Map<String, dynamic>>.from(
              jsonData.map((item) => Map<String, dynamic>.from(item)).toList());
          _isLoading = false;
        });
        print('Datos de la sesión en DetalleTD: $_sessionDetails');
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load session details');
    }
  }

  Future<void> _datosEstudiante(String documento) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/ObtenerDatosEstudiante.php'),
        body: {'DOC_EST': documento},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List &&
            data.isNotEmpty &&
            data[0]['NOMBRE'] != null &&
            data[0]['CODIGOESTUDIANTIL'] != null) {
          String nombreEstudiante = data[0]['NOMBRE'].toString();
          String codigoEstudiante = data[0]['CODIGOESTUDIANTIL'].toString();
          _nombreEstudianteController!.text = nombreEstudiante;
          _codigoEstudianteController!.text = codigoEstudiante;
        } else {
          print('No hay estudiante.');
        }
      } else {
        throw Exception('Failed to load next session number');
      }
    } catch (error) {
      print(error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
