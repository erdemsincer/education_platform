import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'create_discussion_screen.dart';
import 'discussion_user_screen.dart'; // "My Discussions" screen
import 'discussion_detail_screen.dart';  // Add the import for the discussion detail screen

class DiscussionsScreen extends StatefulWidget {
  @override
  _DiscussionsScreenState createState() => _DiscussionsScreenState();
}

class _DiscussionsScreenState extends State<DiscussionsScreen> {
  late Future<List<dynamic>> _discussions;

  @override
  void initState() {
    super.initState();
    _loadDiscussions();  // Load discussions initially
  }

  // Method to load the discussions
  Future<void> _loadDiscussions() async {
    setState(() {
      _discussions = ApiService().getDiscussions();  // Fetch discussions from the API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],  // Background color to add contrast
      appBar: AppBar(
        title: Text(
          'Tartışmalar',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DiscussionUserScreen(),  // Navigate to "My Discussions"
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _discussions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}', style: TextStyle(fontSize: 18, color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç tartışma bulunamadı.', style: TextStyle(fontSize: 18, color: Colors.black87)));
          } else {
            List<dynamic> discussions = snapshot.data!;
            return ListView.builder(
              itemCount: discussions.length,
              itemBuilder: (context, index) {
                var discussion = discussions[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(
                      discussion['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yazan: ${discussion['userFullName']}',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tarih: ${discussion['createdAt']}',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                    trailing: Chip(
                      label: Text('Cevap: ${discussion['replyCount']}'),
                      backgroundColor: Colors.green[300],
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Navigate to the DiscussionDetailScreen and pass the discussion ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiscussionDetailScreen(discussionId: discussion['id']),  // Pass the discussion ID
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
      // Floating action button for creating a new discussion
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Create Discussion screen
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateDiscussionScreen(),
            ),
          );
          // Reload discussions after returning from Create Discussion screen
          _loadDiscussions();
        },
        child: Icon(Icons.add, size: 30),
        backgroundColor: Colors.blueAccent,
        elevation: 6,
      ),
    );
  }
}
