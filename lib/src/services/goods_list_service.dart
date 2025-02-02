import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goods_list/goods.dart';

class GoodsListService {
  final String baseUrl = "http://192.168.100.11:8000/api/goods/search/";

  /// Obtiene la lista de bienes con filtros opcionales.
  Future<List<Goods>> fetchGoods({
    int? keeperId,
    int? locationId,
    int? typeId,
    String? description,
    String? keeperFullName,  // Agregar este parámetro para el nombre completo
  }) async {
    try {
      // Construir la URL con parámetros de filtro de forma clara
      Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
        if (keeperId != null) 'keeper': keeperId.toString(),
        if (locationId != null) 'location': locationId.toString(),
        if (typeId != null) 'type': typeId.toString(),
        if (description != null && description.isNotEmpty) 'description__icontains': description, // Filtrado insensible a mayúsculas
        if (keeperFullName != null && keeperFullName.isNotEmpty) 'keeper_full_name': keeperFullName, // Nuevo parámetro para nombre completo
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decodificar y asegurarse de que la respuesta es una lista válida
        List<dynamic> jsonData = json.decode(response.body);

        // Verificar si jsonData está vacío o no
        if (jsonData.isEmpty) {
          return [];
        }

        // Mapear la lista de JSON a objetos Goods
        return jsonData.map((item) => Goods.fromJson(item)).toList();
      } else {
        // Lanzar una excepción con detalles del error
        throw Exception("Error al obtener los datos: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Manejo de errores, que también captura errores de conexión y parsing
      throw Exception("Error de conexión o en el formato de respuesta: $e");
    }
  }
}
