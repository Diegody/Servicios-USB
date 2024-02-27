import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicios/globals.dart';
import 'package:servicios/screens/docente/crearGD.dart';
import 'package:servicios/screens/docente/sesionG.dart';
import 'package:servicios/screens/docente/sesionGD.dart';

class GrupalTutoriaScreen extends StatefulWidget {
  @override
  _GrupalTutoriaScreenState createState() => _GrupalTutoriaScreenState();
}

class _GrupalTutoriaScreenState extends State<GrupalTutoriaScreen> {
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _filteredData = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _filterData(String query) {
    setState(() {
      _filteredData = _data
          .where((item) =>
              item.values.any((value) => value.toString().contains(query)))
          .toList();
    });
  }

  void _navigateToDetailsPage(String id_grupo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SesionGScreenD(idGrupo: id_grupo),
      ),
    );
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
      body: _filteredData.isNotEmpty
          ? Column(
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CrearGrupoTutoriaScreen(),
                      ),
                    );
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
                SizedBox(height: 20),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CrearGrupoTutoriaScreen(),
                                ),
                              );
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
                          SizedBox(height: 20),
                        ],
                      )
                    : Expanded(
                        child: ListView(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(
                                dataTableTheme: DataTableThemeData(
                                  headingRowColor:
                                      MaterialStateColor.resolveWith(
                                    (states) => Colors.orange,
                                  ),
                                  dataRowColor: MaterialStateColor.resolveWith(
                                    (states) => const Color.fromARGB(
                                        255, 255, 255, 255),
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
                                  DataColumn(label: Text('AÑADIR ESTUDIANTES')),
                                  DataColumn(label: Text('INFO GRUPO')),
                                  DataColumn(label: Text('ELIMINAR')),
                                ],
                                source: DynamicDataSource(
                                  _filteredData,
                                  _navigateToDetailsPage,
                                  _removeRow,
                                  context,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No hay grupos creados actualmente',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CrearGrupoTutoriaScreen(),
                        ),
                      );
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
              ),
            ),
    );
  }

  void _removeRow(int index) {
    final rowData = _filteredData[index];
    final groupId = rowData['ID_GRUPO'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Eliminar grupo',
            style: TextStyle(
              color: Colors.orange,
            ),
          ),
          content: Text('¿Está seguro de eliminar este grupo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteRowOnServer(groupId);
                setState(() {
                  _filteredData.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Eliminar',
                style: TextStyle(
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        );
      },
    );
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

  Future<void> _deleteRowOnServer(String groupId) async {
    try {
      final response = await http.post(
        Uri.parse(
          'https://academia.usbbog.edu.co/centralizacion_servicios_ios/API/Tutorias/DocentesTutoria/EliminarGrupo.php',
        ),
        body: {
          'ID_GRUPO': groupId,
          'DOC_DOC': globalCodigoDocente,
        },
      );

      if (response.statusCode == 200) {
        print('Grupo eliminado exitosamente');
      } else {
        print(
          'Error al eliminar el grupo. Código de estado: ${response.statusCode}',
        );
      }

      print('Respuesta del servidor: ${response.body}');
    } catch (e) {
      print('Excepción al enviar la solicitud: $e');
    }
  }
}

class DynamicDataSource extends DataTableSource {
  final List<Map<String, dynamic>> data;
  final Function(String) onTap;
  final Function(int) onRemoveRow;
  final BuildContext context;

  int _selectedRowCount = 0;

  DynamicDataSource(this.data, this.onTap, this.onRemoveRow, this.context);

  void removeRow(int index) {
    if (index >= 0 && index < data.length) {
      onRemoveRow(index);
      notifyListeners();
    }
  }

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
            onTap(rowData['ID_GRUPO'].toString());
          },
        ),
      ),
      DataCell(
        IconButton(
          icon: Icon(Icons.remove_red_eye_sharp),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SesionGVScreenD(
                  idGrupo: rowData['ID_GRUPO'].toString(),
                ),
              ),
            );
          },
        ),
      ),
      DataCell(
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            removeRow(index);
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
