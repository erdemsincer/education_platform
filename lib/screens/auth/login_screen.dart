import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '/screens/home/home_screen.dart';
import '/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  ApiService apiService = ApiService();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    // **API'den token al**
    String? token = await apiService.login(emailController.text, passwordController.text);

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token); // **Token decode et**
      String fullName = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"] ?? "Kullanıcı";
      String email = decodedToken["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"] ?? "";
      String profileImage = decodedToken["ProfileImage"] ??
          "https://via.placeholder.com/150"; // Eğer profil resmi yoksa varsayılan resim

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token); // **Token'ı kaydet**
      await prefs.setString("userName", fullName); // **Kullanıcı adını kaydet**
      await prefs.setString("userEmail", email);
      await prefs.setString("profileImage", profileImage);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      setState(() {
        _errorMessage = "❌ Giriş başarısız! E-posta veya şifre yanlış.";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "🚀 Giriş Yap",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  SizedBox(height: 20),
                  _buildTextField(emailController, "E-posta", Icons.email),
                  SizedBox(height: 15),
                  _buildTextField(passwordController, "Şifre", Icons.lock, isPassword: true),
                  SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                    child: _loading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Giriş Yap",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(
                      "Hesabınız yok mu? Kayıt olun",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) return "$label alanı boş bırakılamaz!";
        return null;
      },
    );
  }
}
