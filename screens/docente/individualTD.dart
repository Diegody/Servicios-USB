import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IndividualTutoriaScreen extends StatefulWidget {
  @override
  _IndividualTutoriaScreenState createState() =>
      _IndividualTutoriaScreenState();
}

class _IndividualTutoriaScreenState extends State<IndividualTutoriaScreen> {
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
        'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/ListaEstudiantes.php',
      ),
    );
    if (response.statusCode == 200) {
      setState(() {
        _data = List<Map<String, dynamic>>.from(json.decode(response.body));
        _filteredData = _data;
      });
    } else {
      print('Error al recuperar los datos: ${response.statusCode}');
    }
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _data
          .where((item) =>
              item.values.any((value) => value.toString().contains(query)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutoría Individual'),
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
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dataTableTheme: DataTableThemeData(
                      headingRowColor: MaterialStateColor.resolveWith(
                        (states) => Colors.orange,
                      ),
                      dataRowColor: MaterialStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                  child: PaginatedDataTable(
                    header: Text(
                      'Listado estudiantes tutorías',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    rowsPerPage: 15, // Número de filas por página
                    columns: <DataColumn>[
                      DataColumn(label: Text('CICLO')),
                      DataColumn(label: Text('DOCUMENTO')),
                      DataColumn(label: Text('CODIGO ESTUDIANTIL')),
                      DataColumn(label: Text('PRIMER NOMBRE')),
                      DataColumn(label: Text('SEGUNDO NOMBRE')),
                      DataColumn(label: Text('PRIMER APELLIDO')),
                      DataColumn(label: Text('SEGUNDO APELLIDO')),
                      DataColumn(label: Text('CORREO PERSONAL')),
                      DataColumn(label: Text('CORREO INSTITUCIONAL')),
                      DataColumn(label: Text('PROGRAMA')),
                      DataColumn(label: Text('VINCULACION')),
                      DataColumn(label: Text('FACULTAD')),
                    ],
                    source: DynamicDataSource(_filteredData),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DynamicDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  int _selectedRowCount = 0;

  DynamicDataSource(this.data);

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final rowData = data[index];
    return DataRow(cells: <DataCell>[
      DataCell(Text(rowData['CICLO'].toString())),
      DataCell(Text(rowData['DOCUMENTO'].toString())),
      DataCell(Text(rowData['CODIGOESTUDIANTIL'].toString())),
      DataCell(Text(rowData['PRIMERNOMBRE'].toString())),
      DataCell(Text(rowData['SEGUNDONOMBRE'].toString())),
      DataCell(Text(rowData['PRIMERAPELLIDO'].toString())),
      DataCell(Text(rowData['SEGUNDOAPELLIDO'].toString())),
      DataCell(Text(rowData['CORREOPERSONAL'].toString())),
      DataCell(Text(rowData['CORREOINSTITUCIONAL'].toString())),
      DataCell(Text(rowData['PROGRAMA'].toString())),
      DataCell(Text(rowData['VINCULACION'].toString())),
      DataCell(Text(rowData['FACULTAD'].toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => data.length;

  @override
  int get selectedRowCount => _selectedRowCount;
}
