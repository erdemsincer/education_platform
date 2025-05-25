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
    _loadResources(); // İlk kaynakları getir
  }

  Future<void> _loadResources() async {
    setState(() {
      _resources = ApiService().getAllResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tüm Kaynaklar',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 8,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 26),
            onPressed: _loadResources,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3E5F5), Color(0xFFEDE7F6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: _resources,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '❌ Hata: ${snapshot.error}',
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  '🫥 Hiç kaynak bulunamadı.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              );
            } else {
              List<dynamic> resources = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  var resource = resources[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResourceDetailScreen(resourceId: resource['id']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (resource['imageUrl'] != null && resource['imageUrl'].toString().isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  resource['imageUrl'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[100],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.insert_drive_file, color: Colors.deepPurple, size: 36),
                              ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    resource['title'],
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '👤 ${resource['userName']}',
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '📂 Kategori: ${resource['categoryName']}',
                                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
