import 'package:flutter/material.dart';
import '../../models/good.dart';  // Asegúrate de importar el modelo 'Good'

class GoodDetail extends StatelessWidget {
  const GoodDetail({super.key, required this.good});

  final Good good;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(good.name ?? 'Detalle del Producto'),  // Muestra el nombre o un título predeterminado
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Muestra el código del producto
            Text(
              'Código: ${good.code ?? 'No disponible'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Muestra el nombre del producto
            Text(
              'Nombre: ${good.name ?? 'No disponible'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Muestra el nombre del guardián del producto
            Text(
              'Guardián: ${good.keeper?.toString() ?? 'No disponible'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),

            // Muestra la marca del producto
            Text(
              'Marca: ${good.brand ?? 'No disponible'}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
