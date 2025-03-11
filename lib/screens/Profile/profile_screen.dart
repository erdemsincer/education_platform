import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = "Kullanıcı";
  String userEmail = "";
  String profileImage = "https://via.placeholder.com/150";
  List<String> userRoles = [];
  String userId = "";  // Adding userId to store and display

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "Kullanıcı";
      userEmail = prefs.getString("userEmail") ?? "";
      profileImage = prefs.getString("profileImage") ?? "https://via.placeholder.com/150";
      userRoles = prefs.getStringList("userRoles") ?? [];
      userId = prefs.getString("userId") ?? "";  // Load userId from SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profilim")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileImage),
              ),
            ),
            SizedBox(height: 20),
            Text(userName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(userEmail, style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 20),
            Divider(),
            _buildProfileItem(Icons.person, "Ad Soyad", userName),
            _buildProfileItem(Icons.email, "E-Posta", userEmail),
            _buildProfileItem(Icons.security, "Roller", userRoles.join(", ")),
            _buildProfileItem(Icons.account_circle, "Kullanıcı ID", userId),  // Display userId here
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }
}
