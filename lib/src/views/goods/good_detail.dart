import 'package:flutter/material.dart';
import '../../models/goods_list/goods.dart';
import '../../services/goods_service.dart'; // Importa el servicio de bienes
import 'edit_good_form.dart'; // Importa la vista de edición

import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class GoodDetail extends StatelessWidget {
  final Goods good;
  final GoodsService _goodsService = GoodsService(); // Instancia del servicio

  GoodDetail({super.key, required this.good});

  Future<void> _deleteGood(BuildContext context) async {
    try {
      await _goodsService.deleteGood(good.code);
      // Mostrar un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bien eliminado exitosamente')),
      );
      // Navegar de regreso a la pantalla anterior
      Navigator.pop(context);
    } catch (e) {
      // Mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el bien: $e')),
      );
    }
  }

  void _navigateToEditGood(BuildContext context) {
    // Navegar a la vista de edición con el bien actual
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditGoodForm(good: good),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context); // Acceder a autenticación

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Bien'),
        actions: [
          // Botón de editar en la AppBar
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _navigateToEditGood(context),
          ),
        ],
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
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (authProvider.isAuthenticated) {
                  _showDeleteConfirmationDialog(context); // Aquí el context es el del widget GoodDetail
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Inicia sesión para eliminar el bien')),
                  );
                }
              }, // Mostrar diálogo de confirmación
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20), // Padding más grande
              ),
              icon: Icon(Icons.delete, color: Colors.red, size: 28), // Ícono más grande
              label: Text(
                'Eliminar',
                style: TextStyle(fontSize: 18), // Texto más grande
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para mostrar el cuadro de diálogo de confirmación
  void _showDeleteConfirmationDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar este elemento?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                _deleteGood(parentContext); // Utilizar el contexto padre para eliminar
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
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