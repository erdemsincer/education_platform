import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';
import '../Category/resources_by_category_screen.dart';  // Kaynaklar sayfası için import
import '../Category/all_categories_screen.dart';  // Tüm Kategoriler sayfası için import

class CategoriesWidget extends StatefulWidget {
  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late Future<List<Map<String, dynamic>>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = ApiService().getCategories();  // API'den kategorileri al
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50], // Arka plan rengini ekliyoruz
      padding: EdgeInsets.all(16), // İçeriği biraz yukarıdan başlatıyoruz
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık kısmı
          Text(
            "Kaynak Kategorileri",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 16),  // Başlık ile içerik arasında boşluk

          // FutureBuilder ile kategorileri çekiyoruz
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _categories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());  // Yükleniyor göstergesi
              } else if (snapshot.hasError) {
                return Center(child: Text("Hata: ${snapshot.error}"));  // Hata mesajı
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("Kategoriler bulunamadı"));  // Kategoriler yoksa mesaj
              } else {
                var categories = snapshot.data;

                // Sadece 4 kategori gösterecek şekilde sınırlıyoruz
                var limitedCategories = categories!.take(4).toList();

                return GridView.builder(
                  shrinkWrap: true,  // GridView'i sınırlı boyutta gösteriyoruz
                  physics: NeverScrollableScrollPhysics(),  // Scroll yapmayı engelliyoruz
                  padding: EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,  // Her satırda 2 öğe gösterilecektir
                    crossAxisSpacing: 10,  // Satırlar arasındaki boşluk
                    mainAxisSpacing: 10,   // Sütunlar arasındaki boşluk
                    childAspectRatio: 1,   // Kategori kartlarının boyut oranı
                  ),
                  itemCount: limitedCategories.length,
                  itemBuilder: (context, index) {
                    var category = limitedCategories[index];
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Kategoriye tıklandığında kaynakları alacak sayfaya yönlendiriyoruz
                          _onCategoryTap(category['id'], category['name']);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.category, size: 40, color: Colors.blueAccent),
                              SizedBox(height: 10),
                              Text(
                                category['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 5),
                              category['resources'] == null
                                  ? Text('No resources available')
                                  : Text('Resources: ${category['resources']}'),
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

          // Tüm kategoriler butonu
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Tüm kategoriler sayfasına gitmek için burada yönlendirme ekliyoruz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(),  // Tüm kategoriler sayfasına yönlendiriyoruz
                  ),
                );
              },
              child: Text("Tüm Kategoriler"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,  // Buton rengi
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
