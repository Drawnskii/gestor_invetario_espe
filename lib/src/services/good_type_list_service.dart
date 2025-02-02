import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/good_type.dart';  // Asegúrate de importar tu modelo de GoodType

class GoodTypeService {
  final String baseUrl = "http://192.168.100.11:8000";  // Reemplaza con la URL de tu API

  // Método para obtener la lista de GoodTypes desde la API
  Future<List<GoodType>> fetchGoodTypes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/goods-types/'));  // Reemplaza '/good_types' con el endpoint correcto

      // Verificar si la solicitud fue exitosa (código de respuesta 200)
      if (response.statusCode == 200) {
        // Decodificar la respuesta en JSON y luego mapearla a una lista de objetos GoodType
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => GoodType.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar los datos de los tipos de bienes');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }
}
