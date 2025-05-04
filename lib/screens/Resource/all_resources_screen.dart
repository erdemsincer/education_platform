import 'package:education_platform/screens/Resource/resource_detail_sreen.dart';
import 'package:flutter/material.dart';
import '/services/api_service.dart';

class AllResourcesScreen extends StatefulWidget {
  @override
  _AllResourcesScreenState createState() => _AllResourcesScreenState();
}

class _AllResourcesScreenState extends State<AllResourcesScreen> {
  late Future<List<dynamic>> _resources;

  @override
  void initState() {
    super.initState();
    _loadResources();  // Load all resources initial
  }

  // Method to load all resources
  Future<void> _loadResources() async {
    setState(() {
      _resources = ApiService().getAllResources();  // Fetch all resources from the API
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm Kaynaklar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 28),
            onPressed: _loadResources,  // Refresh resources
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _resources,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}', style: TextStyle(fontSize: 18, color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Hiç kaynak bulunamadı.', style: TextStyle(fontSize: 18, color: Colors.black87)));
          } else {
            List<dynamic> resources = snapshot.data!;
            return ListView.builder(
              itemCount: resources.length,
              itemBuilder: (context, index) {
                var resource = resources[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.3),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(20),
                    title: Text(
                      resource['title'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          'Yazan: ${resource['userName']}',
                          style: TextStyle(fontSize: 15, color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Kategori: ${resource['categoryName']}',
                          style: TextStyle(fontSize: 13, color: Colors.black54),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to ResourceDetailScreen and pass the resource ID
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResourceDetailScreen(resourceId: resource['id']),
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
