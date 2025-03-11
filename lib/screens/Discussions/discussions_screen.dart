import 'package:flutter/material.dart';
import '/services/api_service.dart';
import '/screens/discussions/discussion_detail_screen.dart'; // DiscussionDetailScreen'i dahil et

class DiscussionsScreen extends StatefulWidget {
  @override
  _DiscussionsScreenState createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  late Future<List<dynamic>> _discussions;

  @override
  void initState() {
    super.initState();
    _discussions = ApiService().getDiscussions();  // Tartışmaları API'den alıyoruz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tartışmalar')),
      body: FutureBuilder<List<dynamic>>(
        future: _discussions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Yükleniyor göstergesi
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç tartışma bulunamadı.'));
          } else {
            List<dynamic> discussions = snapshot.data!;
            return ListView.builder(
              itemCount: discussions.length,
              itemBuilder: (context, index) {
                var discussion = discussions[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(discussion['title']),
                    subtitle: Text(
                      'Yazan: ${discussion['userFullName']} - ${discussion['createdAt']}',
                    ),
                    trailing: Text('Cevap: ${discussion['replyCount']}'),
                    onTap: () {
                      // Tartışma detayına yönlendir
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiscussionDetailScreen(
                            discussionId: discussion['id'], // Tartışma ID'sini geçiyoruz
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
