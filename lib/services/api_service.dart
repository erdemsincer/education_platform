import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:7028/api",
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
  ));



  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", token);
  }

  Future<String?> login(String email, String password) async {
    try {
      var response = await _dio.post(
        "/Auth/Login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data.containsKey("token")) {
        String token = response.data["token"];
        await _saveToken(token);
        return token;
      } else {
        print("Login Failed: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<bool> register(String fullName, String email, String password) async {
    try {
      var response = await _dio.post(
        "/Auth/Register",
        data: {"fullName": fullName, "email": email, "password": password},
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) {
        print("User Profile Error: Token bulunamadı.");
        return null;
      }

      var response = await _dio.get(
        "/User/Profile",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.statusCode == 200 ? response.data : null;
    } catch (e) {
      print("User Profile Error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("authToken");
    print("User logged out successfully.");
  }
}