import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';
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

  // Variables:
  final TextEditingController _numeroSesionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchSessionDetails(widget.ciclo, widget.documento);
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

  void _navigateToDetalleScreen(String sesion) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DetalleTDScreenD(
          ciclo: widget.ciclo,
          documento: widget.documento,
          sesion: sesion,
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

  void _showSesionForm() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Asignación de tutorías',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                // Campo para el número de sesión
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Número de sesión',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para el periodo académico
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Periodo académico',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para el tipo de tutoría
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tipo de tutoría',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para la facultad (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Facultad',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Facultad 1',
                      child: Text('Facultad 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Facultad 2',
                      child: Text('Facultad 2'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Facultad 3',
                      child: Text('Facultad 3'),
                    ),
                    // Agrega más elementos según sea necesario
                  ],
                  onChanged: (value) {
                    // Lógica para manejar la selección de la facultad
                  },
                ),
                SizedBox(height: 20),
                // Campo para el programa (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Programa',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Programa 1',
                      child: Text('Programa 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Programa 2',
                      child: Text('Programa 2'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Programa 3',
                      child: Text('Programa 3'),
                    ),
                    // Agrega más elementos según sea necesario
                  ],
                  onChanged: (value) {
                    // Lógica para manejar la selección del programa
                  },
                ),
                SizedBox(height: 20),
                // Campo para el nombre del curso (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Nombre del curso',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Curso 1',
                      child: Text('Curso 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Curso 2',
                      child: Text('Curso 2'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Curso 3',
                      child: Text('Curso 3'),
                    ),
                    // Agrega más elementos según sea necesario
                  ],
                  onChanged: (value) {
                    // Lógica para manejar la selección del curso
                  },
                ),
                SizedBox(height: 20),
                // Campo para el profesor responsable
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Profesor responsable',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para la temática
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Temática',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para la modalidad (dropdown)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Modalidad',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem<String>(
                      value: 'Modalidad 1',
                      child: Text('Modalidad 1'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Modalidad 2',
                      child: Text('Modalidad 2'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Modalidad 3',
                      child: Text('Modalidad 3'),
                    ),
                    // Agrega más elementos según sea necesario
                  ],
                  onChanged: (value) {
                    // Lógica para manejar la selección de la modalidad
                  },
                ),
                SizedBox(height: 20),
                // Campo para la metodología
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Metodología',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para la fecha de la tutoría (date picker)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Fecha de la tutoría',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () {
                    // Lógica para abrir el selector de fecha
                  },
                ),
                SizedBox(height: 20),
                // Campo para el lugar
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Lugar',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Campo para el documento
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Documento',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                // Botón para crear la tutoría
                ElevatedButton(
                  onPressed: () {
                    // Lógica para crear la tutoría
                  },
                  child: Text(
                    'Crear tutoría',
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
          ),
        );
      },
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
                          setState(() {
                            // Establece el estado para mostrar el formulario
                            _mostrarFormulario = true;
                          });
                        },
                        child: Text(
                          'Crear sesión de tutoría',
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
                          // Muestra el formulario modal para crear una nueva sesión de tutoría
                          _showSesionForm();
                        },
                        child: Text(
                          'Crear sesión de tutoría',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
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
                              DataColumn(label: Text('FECHATUTORIA')),
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
                                                    .toString());
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
