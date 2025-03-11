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
      backgroundColor: Colors.grey[50],  // Sayfa arka plan rengini yumuşatıyoruz
      appBar: AppBar(
        title: Text('Tartışmalar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _discussions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Yükleniyor göstergesi
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}', style: TextStyle(fontSize: 18, color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç tartışma bulunamadı.', style: TextStyle(fontSize: 18)));
          } else {
            List<dynamic> discussions = snapshot.data!;
            return ListView.builder(
              itemCount: discussions.length,
              itemBuilder: (context, index) {
                var discussion = discussions[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      discussion['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yazan: ${discussion['userFullName']}',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tarih: ${discussion['createdAt']}',
                          style: TextStyle(fontSize: 12, color: Colors.black38),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text('Cevap: ${discussion['replyCount']}'),
                      backgroundColor: Colors.green[300],
                      labelStyle: TextStyle(color: Colors.white),
                    ),
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
