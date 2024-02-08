import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrupalTutoriaScreen extends StatefulWidget {
  @override
  _GrupalTutoriaScreenState createState() => _GrupalTutoriaScreenState();
}

class _GrupalTutoriaScreenState extends State<GrupalTutoriaScreen> {
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/ListaEstudiantes.php'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutoría Grupal'),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(label: Text('Columna 1')),
            DataColumn(label: Text('Columna 2')),
            // Agrega más DataColumn según la cantidad de columnas en tus datos
          ],
          rows: _data.map((rowData) {
            return DataRow(
              cells: <DataCell>[
                DataCell(Text(rowData['campo1'])),
                DataCell(Text(rowData['campo2'])),
                // Agrega más DataCell según la cantidad de columnas en tus datos
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
