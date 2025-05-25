import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';  // JWT Decode için

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "http://10.0.2.2:7028/api",  // API base URL'si
    connectTimeout: Duration(seconds: 60),
    receiveTimeout: Duration(seconds: 60),
  ));

  // Token'ı SharedPreferences'te sakla
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("authToken", token);
  }

  // Kullanıcı ID'sini SharedPreferences'e kaydetme
  Future<void> _saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", userId);  // Kullanıcı ID'sini kaydediyoruz

    // Debug: Kaydedilen userId'yi kontrol et
    print("Saved User ID: $userId");
  }

  // Giriş işlemi
  Future<String?> login(String email, String password) async {
    try {
      var response = await _dio.post(
        "/Auth/Login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 && response.data.containsKey("token")) {
        String token = response.data["token"];

        // Token'ı decode ediyoruz ve userId'yi alıyoruz
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";  // "nameidentifier" claim'ini alıyoruz

        // Debug: Kullanıcı ID'sini kontrol et
        print("User ID from Login: $userId");

        // Token ve userId'yi kaydediyoruz
        await _saveToken(token);
        await _saveUserId(userId);  // Kullanıcı ID'sini kaydediyoruz

        // Debug: Kaydedilen bilgileri kontrol et
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? savedUserId = prefs.getString("userId");
        print("Saved User ID from SharedPreferences: $savedUserId");

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


  // Kullanıcı kaydı işlemi
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

  // Kullanıcı profilini al
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

  // Tartışmaları al
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

  // Tartışma detaylarını al
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

  // Yorum gönderme (DiscussionReply API)
  Future<bool> postReply(int discussionId, String message) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      // Debug: Token'ı kontrol et
      print("Token from SharedPreferences: $token");

      if (token == null) {
        print("User not logged in.");
        return false;
      }

      // Token'ı decode ediyoruz ve userId'yi alıyoruz
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";  // "nameidentifier" claim'ini alıyoruz

      // Debug: Kullanıcı ID'sini kontrol et
      print("User ID from Token: $userId");

      if (userId.isEmpty) {
        print("User ID is empty.");
        return false;
      }

      // Gönderilecek veriyi yazdırıyoruz
      print("Posting reply with:");
      print("discussionId: $discussionId, message: $message, userId: $userId");

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
  Future<List<dynamic>> getMyDiscussions() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) {
        print("User not logged in.");
        return [];
      }

      // JWT token'ı decode ediyoruz ve userId'yi alıyoruz
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";

      // Debug: userId'yi kontrol et
      print("Decoded User ID: $userId");

      var response = await _dio.get(
        "/Discussion/User/$userId",  // Kullanıcıya ait tartışmaları almak için API endpoint'i
        options: Options(
          headers: {
            "Authorization": "Bearer $token",  // Bearer token ile
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;  // Tartışmalar başarılı bir şekilde alındı
      } else {
        print("Error: ${response.statusMessage}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  Future<bool> createDiscussion(String title, String content) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) {
        print("User not logged in.");
        return false;
      }

      // JWT token'ı decode ediyoruz ve userId'yi alıyoruz
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";

      // Debug: userId'yi kontrol et
      print("Decoded User ID: $userId");

      // API request to create the discussion
      var response = await _dio.post(
        "/Discussion",  // API endpoint
        data: {
          "title": title,
          "content": content,
          "userId": int.parse(userId),  // userId'yi int olarak gönderiyoruz
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",  // Bearer token ile
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Discussion created successfully.");
        return true;  // Başarılı
      } else {
        print("Error: ${response.statusMessage}");
        return false;  // Hata durumunda
      }
    } catch (e) {
      print("Error: $e");
      return false;  // Error handling
    }
  }
  Future<List<dynamic>> getAllResources() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) {
        print("User not logged in.");
        return [];
      }

      // JWT token'ı decode ediyoruz ve userId'yi alıyoruz
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";

      var response = await _dio.get(
        "/Resource/GetResourceDetails",  // API endpoint to get all resources
        options: Options(
          headers: {
            "Authorization": "Bearer $token",  // Bearer token ile
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;  // Return the list of all resources if success
      } else {
        print("Error: ${response.statusMessage}");
        return [];  // Return empty list if failed
      }
    } catch (e) {
      print("Error: $e");
      return [];  // Return empty list on error
    }
  }  Future<Map<String, dynamic>> getResourceDetails(int resourceId) async {
    try {
      var response = await _dio.get('/Resource/GetResourceById/$resourceId');
      if (response.statusCode == 200) {
        return response.data;  // Return the resource details
      } else {
        throw Exception('Failed to load resource details');
      }
    } catch (e) {
      throw Exception('Error fetching resource: $e');
    }
  }
  Future<bool> sendMessage(String name, String email, String subject, String content) async {
    try {
      var response = await _dio.post(
        '/Message',  // Mesaj API'sinin endpoint'i
        data: {
          "name": name,
          "email": email,
          "subject": subject,
          "content": content,
        },
      );

      if (response.statusCode == 200) {
        return true;  // Mesaj başarıyla gönderildi
      } else {
        print("Error: ${response.statusMessage}");
        return false;  // Hata durumu
      }
    } catch (e) {
      print("Error sending message: $e");
      return false;  // Hata durumu
    }
  }
  Future<List<dynamic>> getInstructors() async {
    try {
      var response = await _dio.get("/Instructor");  // Öğretmenlerin listesi
      if (response.statusCode == 200) {
        return response.data;  // Öğretmenlerin listesi döndürülüyor
      } else {
        print("Error: ${response.statusMessage}");
        return [];
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }

  // Bir öğretmenin detaylarını almak için servis
  Future<Map<String, dynamic>> getInstructorDetails(int instructorId) async {
    try {
      var response = await _dio.get('/Instructor/details/$instructorId');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load instructor details');
      }
    } catch (e) {
      throw Exception('Error fetching instructor details: $e');
    }
  }
  Future<bool> postReview(int instructorId, String comment, int rating) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) {
        throw Exception('User not logged in');
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userId = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";

      var response = await _dio.post(
        '/Review',
        data: {
          'instructorId': instructorId,
          'userId': userId,
          'rating': rating,
          'comment': comment,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to post review');
      }
    } catch (e) {
      print('Error posting review: $e');
      return false;
    }
  }
  Future<Map<String, dynamic>?> getBanner() async {
    try {
      var response = await _dio.get("/Banner/1");  // API endpoint, tek bir banner alıyoruz
      if (response.statusCode == 200) {
        return response.data;  // Tek bir banner döndürüyoruz
      } else {
        throw Exception('Failed to load banner');
      }
    } catch (e) {
      print("Error fetching banner: $e");
      return null;  // Hata durumunda null döndürüyoruz
    }
  }
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      var response = await _dio.get("/Category");  // API'den kategori verilerini alıyoruz
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return [];  // Hata durumunda boş liste döndürüyoruz
    }
  }
  Future<List<Map<String, dynamic>>> getResourcesByCategory(int categoryId) async {
    try {
      var response = await _dio.get("/Resource/GetByCategory/$categoryId");  // Kategoriye ait kaynakları al
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load resources');
      }
    } catch (e) {
      print("Error fetching resources: $e");
      return [];  // Hata durumunda boş liste döndürüyoruz
    }
  }Future<List<Map<String, dynamic>>> getLatestResources() async {
    try {
      var response = await _dio.get("/Resource/GetLatestResources");  // API endpoint
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load latest resources');
      }
    } catch (e) {
      print("Error fetching latest resources: $e");
      return [];  // Hata durumunda boş liste döndür
    }
    }
  Future<List<Map<String, dynamic>>> getLastFourInstructors() async {
    try {
      var response = await _dio.get("/Instructor/last-four");  // API endpoint
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception('Failed to load last four instructors');
      }
    } catch (e) {
      print("Error fetching last four instructors: $e");
      return [];
    }
  }
  // Hakkımızda bilgisini getir
  Future<Map<String, dynamic>?> getAbout() async {
    try {
      var response = await _dio.get("/About"); // API endpoint
      if (response.statusCode == 200) {
        return response.data; // Hakkında bilgilerini döndür
      } else {
        throw Exception('Failed to load about data');
      }
    } catch (e) {
      print("Error fetching about data: $e");
      return null; // Hata durumunda null döndür
    }
  }
  // Tüm referansları (testimonials) getir
  Future<List<Map<String, dynamic>>> getTestimonials() async {
    try {
      var response = await _dio.get("/Testimonial"); // API endpoint
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data); // Liste olarak dön
      } else {
        throw Exception('Failed to load testimonials');
      }
    } catch (e) {
      print("Error fetching testimonials: $e");
      return [];
    }
  }
  Future<String?> getCareerAdvice() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) {
        print("Token bulunamadı.");
        return null;
      }

      // 🧠 userId'yi token içinden alıyoruz
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userIdStr = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";

      if (userIdStr.isEmpty) {
        print("Token içinde userId yok.");
        return null;
      }

      int userId = int.parse(userIdStr); // 🔥 Hata burda olmayacak çünkü boşluk kontrolü yapıldı

      final response = await _dio.post(
        "/chatbot/career-advice",
        data: {
          "userId": userId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        print("Career response: ${response.data}");
        return response.data.toString();
      } else {
        print("API yanıt durumu: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Career advice error: $e");
      return null;
    }
  }
  Future<List<Map<String, dynamic>>> getCareerTestQuestions() async {
    try {
      final response = await _dio.get("/career-test/questions");
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        throw Exception("Failed to fetch career test questions");
      }
    } catch (e) {
      print("Career Test Error: $e");
      return [];
    }
  }
  Future<String?> submitCareerTestAnswers(Map<int, String> answers) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("authToken");

      if (token == null) return null;

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String userIdStr = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ?? "";

      int userId = int.parse(userIdStr);

      // 🔧 int key'li map json'a çevrilemeyeceği için string key'e dönüştürüyoruz:
      final stringKeyedAnswers = answers.map((key, value) => MapEntry(key.toString(), value));

      final jsonBody = jsonEncode({
        "userId": userId,
        "answers": stringKeyedAnswers
      });

      final response = await Dio().post(
        "http://10.0.2.2:7028/api/career-test/submit-answers",
        data: jsonBody,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
        ),
      );

      if (response.statusCode == 200) {
        return json.encode(response.data); // AI cevabı dönüyor
      } else {
        print("Cevap gönderilemedi: ${response.statusMessage}");
        return null;
      }
    } catch (e) {
      print("Submit career test error: $e");
      return null;
    }
  }
  Future<List<Map<String, dynamic>>> getContactInfo() async {
    try {
      final response = await _dio.get("/Contact");
      if (response.statusCode == 200 && response.data != null) {
        print("Contact response: ${response.data}"); // DEBUG
        return List<Map<String, dynamic>>.from(response.data);
      } else {
        print("Contact API başarısız: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Contact API hatası: $e");
      return [];
    }
  }






















  // Çıkış yap
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("authToken");
    await prefs.remove("userId");  // Kullanıcı ID'sini de temizliyoruz
    print("User logged out successfully.");
  }
}
