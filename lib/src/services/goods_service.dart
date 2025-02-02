import 'package:http/http.dart' as http;
import 'package:inventario/src/utils/secure_storage.dart';

class GoodsService {
  final String baseUrl = 'http://192.168.100.11:8000/api/goods';

  Future<void> deleteGood(String goodCode) async {
    String? accessToken = await SecureStorage.getToken();

    final url = Uri.parse('$baseUrl/$goodCode/delete/');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 204) {
      print('Good deleted successfully');
    } else {
      throw Exception('Failed to delete good: ${response.body}');
    }
  }
}