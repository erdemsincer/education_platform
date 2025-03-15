import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_platform/screens/Resource/all_resources_screen.dart';
import 'package:education_platform/screens/auth/login_screen.dart';
import 'package:education_platform/screens/profile/profile_screen.dart';
import 'package:education_platform/screens/Discussions/discussions_screen.dart';
import 'package:education_platform/screens/message/message_screen.dart';
import '../Category/all_categories_screen.dart';
import '../Instructors/ınstructors_list_screen.dart';
import 'categories_widget.dart';  // Import the CategoriesScreen
import 'banner_widget.dart';  // Import the banner widget

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
      profileImage = prefs.getString("profileImage") ?? "https://via.placeholder.com/150"; // Default profile image
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
        title: Text("Hoşgeldin, $userName!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
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
                    overflow: TextOverflow.ellipsis, // Prevent long roles from overflowing
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text("Profil", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Colors.blueAccent),
              title: Text("Tartışmalar", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DiscussionsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.book, color: Colors.blueAccent),
              title: Text("Kaynaklar", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllResourcesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.message, color: Colors.blueAccent),
              title: Text("Bize Ulaş", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.blueAccent),
              title: Text("Eğitimciler", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InstructorsListScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.school, color: Colors.blueAccent),
              title: Text("Kaynak Kategorileri", style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllCategoriesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.blueAccent),
              title: Text("Ayarlar", style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.blueAccent),
              title: Text("Çıkış Yap", style: TextStyle(fontSize: 18)),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: ListView(  // ListView kullanıyoruz
        children: [
          // Banner widget'ı burada ekliyoruz
          BannerWidget(),

          // Kategoriler widget'ı burada ekliyoruz
          CategoriesWidget(),
        ],
      ),
    );
  }
}
