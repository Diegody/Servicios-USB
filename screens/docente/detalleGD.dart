import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:servicios/screens/docente/crearDD.dart';

class DetalleTDScreenD extends StatefulWidget {
  final String sesion;
  final String groupID;
  final String curso;
  final String tematica;

  const DetalleTDScreenD({
    required this.sesion,
    required this.groupID,
    required this.curso,
    required this.tematica,
  });

  @override
  _DetalleGDScreenDState createState() => _DetalleGDScreenDState();
}

class _DetalleGDScreenDState extends State<DetalleTDScreenD> {
  // final TextEditingController? _nombreCursoController = TextEditingController();
  final TextEditingController? _nombreEstudianteController =
      TextEditingController();
  final TextEditingController? _sesionController = TextEditingController();
  final TextEditingController? _IDgrupoController = TextEditingController();

  List<Map<String, dynamic>> _sessionDetails = [];
  bool _isLoading = true;
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    fetchSessionDetails(widget.sesion, widget.groupID);
    _nombreEstudianteController!.text = '';
    _sesionController!.text = widget.sesion;
    _IDgrupoController!.text = widget.groupID;
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
                          'Sesión ${widget.sesion} del curso de ${widget.curso}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Temática a tratar: ${widget.tematica}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No se encuentra ningun detallado creado actualmente. Cree un detalle ahora.',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
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
                              DataColumn(label: Text('INICIO TUTORÍA')),
                              DataColumn(label: Text('FIN TUTORÍA')),
                              DataColumn(label: Text('NOMBRE')),
                              DataColumn(label: Text('CÓDIGO')),
                              DataColumn(label: Text('DOCUMENTO')),
                              DataColumn(label: Text('ACTIVIDAD REALIZADA')),
                              DataColumn(label: Text('ACUERDOS Y COMPROMISOS')),
                              DataColumn(label: Text('ASISTENCIA')),
                              DataColumn(label: Text('ESTADO CALIFICACIÓN')),
                            ],
                            rows: _searchResults()
                                .map(
                                  (session) => DataRow(
                                    cells: [
                                      DataCell(Text(
                                          session['FECHAINICIO'].toString())),
                                      DataCell(Text(
                                          session['FECHAFINAL'].toString())),
                                      DataCell(Text(session['NOMBREESTUDIANTE']
                                          .toString())),
                                      DataCell(Text(session['CODIGOESTUDIANTIL']
                                          .toString())),
                                      DataCell(Text(
                                          session['DOCUMENTOESTUDIANTE']
                                              .toString())),
                                      DataCell(Text(
                                          session['ACTIVIDADREALIZADA']
                                              .toString())),
                                      DataCell(Text(
                                          session['ACUERDOSCOMPROMISOS']
                                              .toString())),
                                      DataCell(Text(
                                          session['ASISTENCIA'].toString())),
                                      DataCell(Text(
                                          session['ESTADOCALIFICACION']
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

  Future<void> fetchSessionDetails(String sesion, String groupID) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/DetalleTutoriaGrupal.php'),
      body: {
        'SESION': sesion,
        'ID_GRUPO': groupID,
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
        print('Datos de la sesión en DetalleGD: $_sessionDetails');
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
}
