import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class DetalleTDScreenD extends StatefulWidget {
  final String ciclo;
  final String documento;
  final String sesion;

  const DetalleTDScreenD({
    required this.ciclo,
    required this.documento,
    required this.sesion,
  });

  @override
  _DetalleTDScreenDState createState() => _DetalleTDScreenDState();
}

class _DetalleTDScreenDState extends State<DetalleTDScreenD> {
  List<Map<String, dynamic>> _sessionDetails = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchSessionDetails(widget.ciclo, widget.documento, widget.sesion);
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
              child: CircularProgressIndicator(),
            )
          : _sessionDetails.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No hay ningún detalle para el estudiante',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Lógica para crear sesión de tutoría
                        },
                        child: Text(
                          'Crear detalle',
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
                )
              : Column(
                  children: [
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
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para crear sesión de tutoría
                      },
                      child: Text(
                        'Crear detalle',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
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
}
