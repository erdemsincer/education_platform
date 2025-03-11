import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/auth/login_screen.dart';
import '/screens/profile/profile_screen.dart';  // Profil sayfasını dahil et
import '/screens/Discussions/discussions_screen.dart';  // Tartışmalar sayfasını dahil et

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
      profileImage = prefs.getString("profileImage") ?? "https://via.placeholder.com/150"; // Varsayılan profil resmi
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
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(profileImage),
                  ),
                  SizedBox(height: 10),
                  Text(userName, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(userEmail, style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 5),
                  Text(
                    "Roller: ${userRoles.join(", ")}",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis, // Uzun rollerin taşmasını engelliyoruz
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text("Profil"),
              onTap: () {
                // Profil sayfasına yönlendir
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.blueAccent),
              title: Text("Tartışmalar"),  // Tartışmalar menüsünü ekledik
              onTap: () {
                // Tartışmalar sayfasına yönlendir
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussionsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blueAccent),
              title: Text("Ayarlar"),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueAccent),
              title: Text("Çıkış Yap"),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ana sayfa içeriği, şimdilik örnek bir yazı
              Text(
                "Ana Sayfa İçeriği Buraya Gelecek",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Burada bir işlev ekleyebilirsiniz.
                },
                child: Text("Bir Şeyler Yapın"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50), backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
