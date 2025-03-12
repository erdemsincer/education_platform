import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/services/api_service.dart';

class DiscussionUserScreen extends StatefulWidget {
  @override
  _DiscussionUserScreenState createState() => _DiscussionUserScreenState();
}

class _DiscussionUserScreenState extends State<DiscussionUserScreen> {
  late Future<List<dynamic>> _discussions;
  bool _isLoading = false;

  // ApiService instance
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadDiscussions();
  }

  // Tartışmaların listeleneceği API çağrısı
  Future<void> _loadDiscussions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic> discussions = await _apiService.getMyDiscussions();
      setState(() {
        _discussions = Future.value(discussions); // Set the data to the future
      });
    } catch (e) {
      setState(() {
        _discussions = Future.value([]);
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tartışmalarım')),
      body: FutureBuilder<List<dynamic>>(
        future: _discussions,
        builder: (context, snapshot) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç tartışma bulunamadı.'));
          }

          List<dynamic> discussions = snapshot.data!;

          return ListView.builder(
            itemCount: discussions.length,
            itemBuilder: (context, index) {
              var discussion = discussions[index];
              String title = discussion['title'] ?? 'Başlık Yok';
              String content = discussion['content'] ?? 'İçerik Yok';
              String userFullName = discussion['userFullName'] ?? 'Yazar Bilgisi Yok';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: ListTile(
                  title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(content),
                  trailing: Text(userFullName),
                  // Removed the navigation logic
                ),
              );
            },
          );
        },
      ),
    );
  }
}
