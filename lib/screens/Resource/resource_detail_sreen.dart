import 'package:flutter/material.dart';
import '/services/api_service.dart';

class ResourceDetailScreen extends StatefulWidget {
  final int resourceId;

  ResourceDetailScreen({required this.resourceId});

  @override
  _ResourceDetailScreenState createState() => _ResourceDetailScreenState();
}

class _ResourceDetailScreenState extends State<ResourceDetailScreen> {
  late Future<Map<String, dynamic>> _resourceDetails;

  @override
  void initState() {
    super.initState();
    // Fetch resource details using the passed resourceId
    _resourceDetails = ApiService().getResourceDetails(widget.resourceId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaynak Detayları', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _resourceDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}', style: TextStyle(fontSize: 18, color: Colors.red)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Kaynak bulunamadı.', style: TextStyle(fontSize: 18, color: Colors.black87)));
          } else {
            var resource = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: ListView(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource['title'] ?? 'Başlık Yok',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Açıklama: ${resource['description'] ?? 'Açıklama yok'}',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kategori: ${resource['categoryName'] ?? 'Kategori yok'}',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Yazan: ${resource['userName'] ?? 'Yazar bilgisi yok'}',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dosya Linki:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${resource['fileUrl'] ?? 'Dosya linki yok'}',
                            style: TextStyle(fontSize: 14, color: Colors.blueAccent),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    margin: EdgeInsets.only(bottom: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Oluşturulma Tarihi:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${resource['createdAt'] ?? 'Tarih yok'}',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle the file URL, e.g., open in a browser or download
                      },
                      child: Text('Kaynağı İncele'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
