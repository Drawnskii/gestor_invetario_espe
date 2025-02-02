import 'package:flutter/material.dart';
import '../../models/goods_list/goods.dart';

class GoodDetail extends StatelessWidget {
  final Goods good;

  GoodDetail({required this.good});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Bien'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ícono grande relacionado con bienes o inventario
            Icon(
              Icons.inventory,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            // Descripción del bien como título principal
            Text(
              good.description,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            // Nombre del encargado en un tamaño más pequeño
            Text(
              'Encargado: ${good.keeper.firstName} ${good.keeper.lastName}',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            // Tarjeta con los detalles del bien
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Fila con el código del bien
                    _buildDetailRow(Icons.code, 'Código', good.code),
                    SizedBox(height: 8),
                    // Fila con la ubicación del bien
                    _buildDetailRow(Icons.location_on, 'Ubicación', '${good.location.name} (${good.location.locationType})'),
                    SizedBox(height: 8),
                    // Fila con el tipo de bien
                    _buildDetailRow(Icons.category, 'Tipo', good.type.name),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para construir una fila de detalle con ícono
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}