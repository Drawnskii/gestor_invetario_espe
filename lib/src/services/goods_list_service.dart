import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/goods_list/goods_response.dart';

class GoodsListService {
  final String baseUrl = "http://192.168.100.11:8000/api/goods/search/";

  /// Obtiene la lista de bienes con filtros opcionales y paginación.
  Future<GoodsResponse> fetchGoods({
    int? keeperId,
    int? locationId,
    int? typeId,
    String? description,
    String? keeperFullName,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      // Construir la URL con parámetros de filtro y paginación de forma clara
      Uri uri = Uri.parse(baseUrl).replace(queryParameters: {
        if (keeperId != null) 'keeper': keeperId.toString(),
        if (locationId != null) 'location': locationId.toString(),
        if (typeId != null) 'type': typeId.toString(),
        if (description != null && description.isNotEmpty) 'description__icontains': description, // Filtrado insensible a mayúsculas
        if (keeperFullName != null && keeperFullName.isNotEmpty) 'keeper_full_name': keeperFullName, // Nuevo parámetro para nombre completo
        'page': page.toString(),                   // Paginación: número de página
        'page_size': pageSize.toString(),          // Paginación: número de elementos por página
      });

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        // Decodificar la respuesta en UTF-8 para asegurar la correcta interpretación de caracteres especiales
        String decodedResponse = utf8.decode(response.bodyBytes);

        // Ahora decodificamos el JSON correctamente
        Map<String, dynamic> jsonData = json.decode(decodedResponse);

        // Devolver la respuesta completa mapeada a GoodsResponse
        return GoodsResponse.fromJson(jsonData);
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
