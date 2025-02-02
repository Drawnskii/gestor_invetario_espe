import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/user_login.dart';
import '../../utils/secure_storage.dart';

class LoginService {
  final String apiUrl = "http://192.168.100.11:8000/api/token/";

  Future<bool> login(String username, String password) async {
    try {
      UserLogin user = UserLogin(username: username, password: password);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );

      print("Código de estado: ${response.statusCode}");
      print("Respuesta del servidor: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey("access") && data["access"] != null) {
          await SecureStorage.saveToken(data["access"]);
          await SecureStorage.saveRefreshToken(data["refresh"]); // Guardar refresh
          return true;
        } else {
          print("No se recibió un token de acceso válido.");
          return false;
        }
      } else {
        print("Error en login: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error en login: $e");
      return false;
    }
  }

  Future<bool> refreshToken() async {
    try {
      String? refreshToken = await SecureStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await http.post(
        Uri.parse("http://192.168.100.11:8000/api/token/refresh/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("access") && data["access"] != null) {
          await SecureStorage.saveToken(data["access"]);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error al refrescar el token: $e");
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await SecureStorage.getToken();

    if (token == null) {
      return false;
    }

    // Aquí podrías verificar si el token ha expirado
    // pero lo mejor es intentar usarlo y si falla, refrescarlo

    bool refreshed = await refreshToken();
    return refreshed;
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();
  }
}
