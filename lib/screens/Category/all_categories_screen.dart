import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';
import 'resources_by_category_screen.dart';  // Kaynaklar sayfası için import

class AllCategoriesScreen extends StatefulWidget {
  @override
  _AllCategoriesScreenState createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  late Future<List<Map<String, dynamic>>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = ApiService().getCategories();  // API'den tüm kategorileri al
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tüm Kategoriler', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());  // Yükleniyor göstergesi
            } else if (snapshot.hasError) {
              return Center(child: Text("Hata: ${snapshot.error}", style: TextStyle(fontSize: 18, color: Colors.red)));  // Hata mesajı
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Hiç kategori bulunamadı.", style: TextStyle(fontSize: 18, color: Colors.black87)));  // Kategoriler yoksa mesaj
            } else {
              var categories = snapshot.data;

              return ListView.builder(
                itemCount: categories!.length,
                itemBuilder: (context, index) {
                  var category = categories[index];
                  return _buildCategoryCard(category);
                },
              );
            }
          },
        ),
      ),
    );
  }

  // Kategorileri şık bir şekilde göstermek için kullanılan fonksiyon
  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),  // Yuvarlatılmış köşeler
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        onTap: () {
          // Kategoriye tıklandığında kaynakları alacak sayfaya yönlendiriyoruz
          _onCategoryTap(category['id'], category['name']);
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Kategorinin ikonu
              Icon(Icons.category, size: 50, color: Colors.blueAccent),
              SizedBox(width: 16),
              // Kategorinin başlık kısmı
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Kategoriye ait kaynakları görmek için tıklayın.',
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

  // Kategoriye tıklandığında kaynakları alacak sayfaya yönlendiren fonksiyon
  void _onCategoryTap(int categoryId, String categoryName) {
    // getResourcesByCategory fonksiyonunu çağırarak kaynakları alıyoruz
    ApiService().getResourcesByCategory(categoryId).then((resources) {
      // Kaynaklar sayfasına yönlendirme
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResourcesByCategoryScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          ),  // Kaynaklar sayfasına yönlendiriyoruz
        ),
      );
    });
  }
}
