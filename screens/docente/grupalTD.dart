import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';

class GrupalTutoriaScreen extends StatefulWidget {
  @override
  _GrupalTutoriaScreenState createState() => _GrupalTutoriaScreenState();
}

class _GrupalTutoriaScreenState extends State<GrupalTutoriaScreen> {
  // ignore: unused_field
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _filteredData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.post(
      Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/ListaGrupos.php'),
      body: {
        'DOC_DOC': globalCodigoDocente,
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(response.body));
        _filteredData = _data;
      });
    } else {}
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _data
          .where((item) =>
              item.values.any((value) => value.toString().contains(query)))
          .toList();
    });
  }

  void _navigateToDetailsPage(String ciclo, String documento) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => SesionTDScreenD(
    //       ciclo: ciclo,
    //       documento: documento,
    //     ),
    //   ),
    // );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterData,
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          _filteredData.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No hay grupos creados actualmente',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para crear grupo de tutoría
                      },
                      child: Text(
                        'Crear grupo de tutoría',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                    ),
                  ],
                )
              : Expanded(
                  child: ListView(
                    children: [
                      Theme(
                        data: Theme.of(context).copyWith(
                          dataTableTheme: DataTableThemeData(
                            headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.orange,
                            ),
                            dataRowColor: MaterialStateColor.resolveWith(
                              (states) =>
                                  const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        child: PaginatedDataTable(
                          header: Text(
                            'Grupos de tutorías actuales',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          rowsPerPage: 6,
                          columns: <DataColumn>[
                            DataColumn(label: Text('NOMBRE GRUPO')),
                            DataColumn(label: Text('VER MÁS')),
                            DataColumn(label: Text('ELIMINAR')),
                          ],
                          source: DynamicDataSource(
                            _filteredData,
                            _navigateToDetailsPage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}

class DynamicDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final Function(String, String) onTap;
  int _selectedRowCount = 0;

  DynamicDataSource(this.data, this.onTap);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final rowData = data[index];
    return DataRow(cells: <DataCell>[
      DataCell(Text(rowData['NOMBRE'].toString())),
      DataCell(
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            // onTap(rowData['CICLO'].toString(), rowData['DOCUMENTO'].toString());
          },
        ),
      ),
      DataCell(
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            // onTap(rowData['CICLO'].toString(), rowData['DOCUMENTO'].toString());
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => _selectedRowCount;
}
