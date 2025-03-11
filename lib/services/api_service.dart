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
  Future<List<dynamic>> getDiscussions() async {
    try {
      var response = await _dio.get("/Discussion/GetAll");  // API endpoint'i
      if (response.statusCode == 200) {
        return response.data;  // API'den alınan tartışmaları döndür
      } else {
        print("Error: ${response.statusMessage}");
        return [];
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
  Future<Map<String, dynamic>?> getDiscussionDetail(int discussionId) async {
    try {
      var response = await _dio.get("/Discussion/GetDiscussionDetailWithReplies/$discussionId"); // API endpoint
      if (response.statusCode == 200) {
        return response.data;  // Tartışma detaylarını döndürüyoruz
      } else {
        print("Error: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("API Error: $e");
      return null;
    }
  }
  Future<bool> postReply(int discussionId, String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      // Kullanıcı ID'sini SharedPreferences'ten alıyoruz
      String? userId = prefs.getString("userId");

      if (token == null || userId == null) {
        print("User not logged in.");
        return false;
      }

      var response = await _dio.post(
        "/DiscussionReply",  // Yorum eklemek için API endpoint
        data: {
          "discussionId": discussionId,
          "message": message,
          "userId": userId,  // Kullanıcı ID'sini de ekliyoruz
        },
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200) {
        return true;  // Başarılı
      } else {
        print("Error Response: ${response.data}");
        print("Error Status Code: ${response.statusCode}");
        print("Error Message: ${response.statusMessage}");
        return false;  // Hata durumu
      }
    } catch (e) {
      print("Error posting reply: $e");
      return false;
    }
  }


  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("authToken");
    print("User logged out successfully.");
  }
}