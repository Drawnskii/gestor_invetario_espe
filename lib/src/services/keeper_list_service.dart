import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/keeper_name.dart';  // Asegúrate de importar tu modelo de KeeperName

class KeeperService {
  final String baseUrl = "http://192.168.100.11:8000";  // Reemplaza con la URL de tu API

  // Método para obtener la lista de Keepers desde la API
  Future<List<KeeperName>> fetchKeepers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/first-names/'));  // Reemplaza '/keepers' con el endpoint correcto

      // Verificar si la solicitud fue exitosa (código de respuesta 200)
      if (response.statusCode == 200) {
        // Decodificar la respuesta en JSON y luego mapearla a una lista de objetos KeeperName
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => KeeperName.fromJson(item)).toList();
      } else {
        throw Exception('Error al cargar los datos de los Keepers');
      }
    } catch (e) {
      throw Exception('Error al realizar la solicitud: $e');
    }
  }
}
