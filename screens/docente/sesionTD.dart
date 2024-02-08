import 'package:flutter/material.dart';

class SesionTDScreenD extends StatelessWidget {
  final Map<String, dynamic> rowData;

  const SesionTDScreenD({required this.rowData});

  @override
  Widget build(BuildContext context) {
    final filteredData = Map<String, dynamic>.fromEntries(rowData.entries
        .where((entry) => !RegExp(r'^\d+$').hasMatch(entry.key)));

    print('Detalles para consultar tutorias: $filteredData');

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
      body: Center(
        child: Text('Detalles de la fila: $rowData'),
      ),
    );
  }
}
