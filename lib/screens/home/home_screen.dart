import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_platform/screens/Resource/all_resources_screen.dart';
import 'package:education_platform/screens/auth/login_screen.dart';
import 'package:education_platform/screens/profile/profile_screen.dart';
import 'package:education_platform/screens/Discussions/discussions_screen.dart';
import 'package:education_platform/screens/message/message_screen.dart';
import '../Category/all_categories_screen.dart';
import '../Instructors/ınstructors_list_screen.dart';
import 'about_widget.dart';
import 'categories_widget.dart';
import 'banner_widget.dart';
import 'latest_resources_widget.dart';
import 'latest_testimonials_widget.dart';
import 'latest_ınstructors_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("userName") ?? "Kullanıcı";
      userEmail = prefs.getString("userEmail") ?? "";
      profileImage = prefs.getString("profileImage") ?? "https://via.placeholder.com/150";
      userRoles = prefs.getStringList("userRoles") ?? [];
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Hoşgeldin, $userName!",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      drawer: _buildDrawer(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const BannerWidget(),
          const CategoriesWidget(),
          LatestResourcesWidget(),
          LatestInstructorsWidget(),
          LatestTestimonialsWidget(),
        ],
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(radius: 35, backgroundImage: NetworkImage(profileImage)),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, "Profil", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>  ProfileScreen()));
          }),
          _buildDrawerItem(Icons.chat, "Tartışmalar", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>  DiscussionsScreen()));
          }),
          _buildDrawerItem(Icons.book, "Kaynaklar", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>  AllResourcesScreen()));
          }),
          _buildDrawerItem(Icons.message, "Bize Ulaş", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>  MessageScreen()));
          }),
          _buildDrawerItem(Icons.school, "Eğitimciler", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>  InstructorsListScreen()));
          }),
          _buildDrawerItem(Icons.category, "Kaynak Kategorileri", () {
            Navigator.push(context, MaterialPageRoute(builder: (_) =>  AllCategoriesScreen()));
          }),
          _buildDrawerItem(Icons.logout, "Çıkış Yap", _logout),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.indigo),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
