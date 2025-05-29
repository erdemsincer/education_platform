import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_platform/screens/Resource/all_resources_screen.dart';
import 'package:education_platform/screens/auth/login_screen.dart';
import 'package:education_platform/screens/profile/profile_screen.dart';
import 'package:education_platform/screens/Discussions/discussions_screen.dart';
import 'package:education_platform/screens/message/message_screen.dart';
import '../Category/all_categories_screen.dart';
import '../Instructors/ınstructors_list_screen.dart';
import '../contact/contact_info_widget.dart';
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "👋 Hoşgeldin, $userName!",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Çıkış Yap",
            onPressed: _logout,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            const BannerWidget(),
            const CategoriesWidget(),
            LatestResourcesWidget(),
            LatestInstructorsWidget(),
            LatestTestimonialsWidget(),
            const ContactInfoWidget(),
          ],
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.indigo),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(profileImage),
            ),
            accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(userEmail),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.person, "Profil", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
                }),
                _buildDrawerItem(Icons.chat_bubble_outline, "Tartışmalar", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => DiscussionsScreen()));
                }),
                _buildDrawerItem(Icons.book_outlined, "Kaynaklar", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllResourcesScreen()));
                }),
                _buildDrawerItem(Icons.school_outlined, "Eğitimciler", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => InstructorsListScreen()));
                }),
                _buildDrawerItem(Icons.category_outlined, "Kaynak Kategorileri", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllCategoriesScreen()));
                }),
                _buildDrawerItem(Icons.message_outlined, "Bize Ulaş", () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => MessageScreen()));
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Çıkış Yap", style: TextStyle(color: Colors.redAccent)),
            onTap: _logout,
          ),
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
