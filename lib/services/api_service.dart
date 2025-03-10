import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://localhost:7028/api", // API adresini güncelle
    connectTimeout: Duration(seconds: 10), // Bağlantı süresi sınırı
    receiveTimeout: Duration(seconds: 10),
  ));

  // Kullanıcı giriş yaparsa token'ı kaydet
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", token);
  }

  // Kullanıcı giriş yap
  Future<String?> login(String email, String password) async {
    try {
      var response = await _dio.post(
        "/Auth/Login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data.containsKey("token")) {
        String token = response.data["token"];
        await _saveToken(token);
        return token; // Token döndürüyoruz
      } else {
        print("Login Failed: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Kullanıcı kayıt ol
  Future<bool> register(String fullName, String email, String password) async {
    try {
      var response = await _dio.post(
        "/Auth/Register",
        data: {"fullName": fullName, "email": email, "password": password},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Register Failed: ${response.statusMessage}");
        return false;
      }
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  // Kullanıcı profilini getir
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

      if (response.statusCode == 200) {
        return response.data;
      } else {
        print("User Profile Fetch Failed: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("User Profile Error: $e");
      return null;
    }
  }

  // Çıkış yap
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("authToken");
    print("User logged out successfully.");
  }
}
