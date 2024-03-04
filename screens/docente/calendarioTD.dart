import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class Tutoria {
  final String fechaTutoria;
  final String nombresEstudiante;
  final String nombreCurso;
  final String profesorResponsable;
  final String tematica;
  final String modalidad;
  final String lugar;
  final String metodologia;

  Tutoria({
    required this.fechaTutoria,
    required this.nombresEstudiante,
    required this.nombreCurso,
    required this.profesorResponsable,
    required this.tematica,
    required this.modalidad,
    required this.lugar,
    required this.metodologia,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalendarioTD(),
    );
  }
}

class CalendarioTD extends StatefulWidget {
  @override
  _CalendarioScreenDState createState() => _CalendarioScreenDState();
}

class _CalendarioScreenDState extends State<CalendarioTD> {
  dynamic _data;
  late List<Tutoria> _filteredTutorias;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTutorias();
    _filteredTutorias = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendario de Tutorías'),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  _filterTutorias(query);
                },
                decoration: InputDecoration(
                  hintText: 'Buscar tutorías por valor',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredTutorias.isNotEmpty
                ? _buildTutoriasList()
                : Center(
                    child: Text(
                      'No hay tutorías con esa información',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _filterTutorias(String query) {
    if (_data is List<dynamic>) {
      final filteredTutorias = _data
          .where((tutoria) =>
              (tutoria['FECHATUTORIA'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['NOMBRES'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['NOMBREDELCURSO'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['PROFESORRESPONSABLE'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['TEMATICA'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['MODALIDAD'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['LUGAR'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              (tutoria['METODOLOGIA'] ?? '')
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();

      setState(() {
        _filteredTutorias = List<Tutoria>.from(
          filteredTutorias.map(
            (tutoria) => Tutoria(
              fechaTutoria: tutoria['FECHATUTORIA'],
              nombresEstudiante: tutoria['NOMBRES'],
              nombreCurso: tutoria['NOMBREDELCURSO'],
              profesorResponsable: tutoria['PROFESORRESPONSABLE'],
              tematica: tutoria['TEMATICA'],
              modalidad: tutoria['MODALIDAD'],
              lugar: tutoria['LUGAR'],
              metodologia: tutoria['METODOLOGIA'],
            ),
          ),
        );
      });
    }
  }

  Widget _buildTutoriasList() {
    if (_data == null) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
        ),
      );
    }

    if (_data is Map<String, dynamic> && _data!['error'] != null) {
      return Center(child: Text('Error: ${_data!['error']}'));
    }

    return ListView.builder(
      itemCount: _filteredTutorias.length,
      itemBuilder: (context, index) {
        final tutoria = _filteredTutorias[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: _getColorForMetodologia(tutoria.metodologia),
                width: 3.0,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fecha: ${_formatFecha(tutoria.fechaTutoria)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Estudiante: ${tutoria.nombresEstudiante}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Curso: ${tutoria.nombreCurso}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Profesor: ${tutoria.profesorResponsable}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Temática: ${tutoria.tematica}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Modalidad: ${tutoria.modalidad}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Lugar: ${tutoria.lugar}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Metodología: ${tutoria.metodologia}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatFecha(String fecha) {
    return fecha;
  }

  Color _getColorForMetodologia(String metodologia) {
    return metodologia == 'Individual' ? Colors.orange : Colors.green;
  }

  Future<void> _fetchTutorias() async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/MostrarGrupoCalendario.php'),
        body: {'DOC_DOC': globalCodigoDocente},
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print('Respuesta del servidor: $responseData');

        if (responseData is List<dynamic>) {
          setState(() {
            _data = responseData;
            _filteredTutorias = (_data as List<dynamic>)
                .map((tutoria) {
                  try {
                    return Tutoria(
                      fechaTutoria: tutoria['FECHATUTORIA'],
                      nombresEstudiante: tutoria['NOMBRE'],
                      nombreCurso: tutoria['NOMBREDELCURSO'],
                      profesorResponsable: tutoria['PROFESOR'],
                      tematica: tutoria['TEMATICA'],
                      modalidad: tutoria['MODALIDAD'],
                      lugar: tutoria['LUGAR'],
                      metodologia: tutoria['METODOLOGIA'],
                    );
                  } catch (e) {
                    print('Error al mapear tutoria: $e');
                    return null;
                  }
                })
                .whereType<Tutoria>()
                .toList();
          });
        } else {
          print('Error: Respuesta no válida');
        }
      } else {
        print('Error en la solicitud HTTP: ${response.statusCode}');
      }
    } catch (error) {
      print('Error en la solicitud HTTP: $error');
    }
  }
}
