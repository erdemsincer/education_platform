import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Genel yazı tipi
      ),
      home: FutureBuilder<String>(
        future: _getInitialRoute(), // Get initial route asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else if (snapshot.hasData) {
            return MaterialApp(
              initialRoute: snapshot.data,
              routes: {
                "/login": (context) => LoginScreen(),
                "/register": (context) => RegisterScreen(),
                "/home": (context) => HomeScreen(), // Ana ekran eklendi
              },
            );
          } else {
            return Scaffold(body: Center(child: Text('No route available')));
          }
        },
      ),
    );
  }

  // Uygulama başlarken giriş yapmış kullanıcıyı kontrol et
  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    // Eğer userId varsa, doğrudan HomeScreen'e yönlendir
    if (userId != null && userId.isNotEmpty) {
      return '/home'; // Kullanıcı giriş yapmışsa home ekranına yönlendir
    } else {
      return '/login'; // Kullanıcı giriş yapmamışsa login ekranına yönlendir
    }
  }
}
