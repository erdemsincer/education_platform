import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';

class ResourcesByCategoryScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  ResourcesByCategoryScreen({required this.categoryId, required this.categoryName});

  @override
  _ResourcesByCategoryScreenState createState() =>
      _ResourcesByCategoryScreenState();
}

class _ResourcesByCategoryScreenState extends State<ResourcesByCategoryScreen> {
  late Future<List<Map<String, dynamic>>> _resources;

  @override
  void initState() {
    super.initState();
    _resources = ApiService().getResourcesByCategory(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryName} Kaynakları"),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(  // Veri çekme işlemi
          future: _resources,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Hata: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Kaynak bulunamadı"));
            } else {
              var resources = snapshot.data!;

              return ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  var resource = resources[index];
                  return _buildResourceCard(resource);
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Kaynakları kartlar şeklinde şık bir şekilde göstermek için kullanılan fonksiyon
  Widget _buildResourceCard(Map<String, dynamic> resource) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),  // Yuvarlatılmış köşeler
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        onTap: () {
          // Kaynağa tıklandığında yapılacak işlem
          print("Resource tapped: ${resource['title']}");
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // İkon kısmı
              Icon(Icons.book, size: 50, color: Colors.blueAccent),
              SizedBox(width: 16),
              // Kaynağın başlık ve açıklama kısmı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      resource['description'] ?? 'Açıklama yok.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              // Sağ tarafta ok ikonu
              Icon(Icons.arrow_forward_ios, size: 20, color: Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
