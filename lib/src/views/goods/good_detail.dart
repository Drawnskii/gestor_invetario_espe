import 'package:flutter/material.dart';
import '../../models/goods_list/goods.dart';

class GoodDetail extends StatelessWidget {
  final Goods good;  // Recibe el objeto Goods directamente

  GoodDetail({required this.good});  // Constructor que recibe el objeto Goods

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Bien'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Código: ${good.code}',  // Accede a los detalles del objeto `good`
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Descripción: ${good.description}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Responsable: ${good.keeper.firstName} ${good.keeper.lastName}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Ubicación: ${good.location.name} (${good.location.locationType})',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Tipo: ${good.type.name}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
