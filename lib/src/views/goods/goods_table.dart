import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/goods_list.dart';

class GoodTable extends StatelessWidget {
  const GoodTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Bienes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Consumer<GoodsList>(
            builder: (context, goods, child) {
              return DataTable(
                columnSpacing: 20,
                columns: const [
                  DataColumn(label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nombre', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Encargado', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Marca', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: goods.goods.map((good) {
                  return DataRow(cells: [
                    DataCell(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(good.code ?? 'N/A'),
                    )),
                    DataCell(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(good.name ?? 'N/A'),
                    )),
                    DataCell(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(good.keeper?.toString() ?? 'N/A'),
                    )),
                    DataCell(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(good.brand ?? 'N/A'),
                    )),
                  ]);
                }).toList(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción para la descarga
          print('Descargando...');
        },
        backgroundColor: Colors.orange[600],
        child: const Icon(Icons.download),
      ),
    );
  }
}
