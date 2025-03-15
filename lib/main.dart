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
        fontFamily: 'Poppins', // General font
      ),
      home: FutureBuilder<String>(
        future: _getInitialRoute(),
        builder: (context, snapshot) {
          // While waiting for data, show a loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // If there's an error, show a message
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          }

          // If the data exists, route based on the data
          if (snapshot.hasData) {
            return MaterialApp(
              initialRoute: snapshot.data,
              routes: {
                "/login": (context) => LoginScreen(),
                "/register": (context) => RegisterScreen(),
                "/home": (context) => HomeScreen(), // Main screen added
              },
            );
          }

          // Default case if no route is available
          return Scaffold(body: Center(child: Text('No route available')));
        },
      ),
    );
  }

  // Check if the user is logged in or not
  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");

    // If userId exists and is not empty, route to home screen
    if (userId != null && userId.isNotEmpty) {
      return '/home'; // User is logged in
    } else {
      return '/login'; // User is not logged in, route to login screen
    }
  }
}
