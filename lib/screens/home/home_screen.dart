import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/auth/login_screen.dart';
import '/screens/profile/profile_screen.dart';  // Profil sayfasını dahil et

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "";
  String userEmail = "";
  String profileImage = "";
  List<String> userRoles = [];

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
      profileImage = prefs.getString("profileImage") ??
          "https://via.placeholder.com/150"; // Eğer profil resmi yoksa varsayılan bir resim
      userRoles = prefs.getStringList("userRoles") ?? [];
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hoşgeldin, $userName!"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(radius: 30, backgroundImage: NetworkImage(profileImage)),
                  SizedBox(height: 10),
                  Text(userName, style: TextStyle(color: Colors.white, fontSize: 18)),
                  Text(userEmail, style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 5),
                  Text("Roller: ${userRoles.join(", ")}", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profil"),
              onTap: () {
                // Profil sayfasına yönlendir
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(leading: Icon(Icons.settings), title: Text("Ayarlar"), onTap: () {}),
            ListTile(leading: Icon(Icons.logout), title: Text("Çıkış Yap"), onTap: _logout),
          ],
        ),
      ),
      body: Center(child: Text("Ana Sayfa İçeriği Buraya Gelecek")),
    );
  }
}
