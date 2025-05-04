import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';
import 'resources_by_category_screen.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  late Future<List<Map<String, dynamic>>> _categories;

  @override
  void initState() {
    super.initState();
    _categories = ApiService().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '📚 Tüm Kategoriler',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _categories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  "❌ Hata: ${snapshot.error}",
                  style: const TextStyle(fontSize: 16, color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  "⚠️ Hiç kategori bulunamadı.",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              );
            } else {
              var categories = snapshot.data!;
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(categories[index]);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _onCategoryTap(category['id'], category['name']),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.category_rounded, size: 40, color: Colors.indigo),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Kategoriye ait kaynakları görmek için tıklayın.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.indigo),
            ],
          ),
        ),
      ),
    );
  }

  void _onCategoryTap(int categoryId, String categoryName) {
    ApiService().getResourcesByCategory(categoryId).then((resources) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResourcesByCategoryScreen(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        ),
      );
    });
  }
}
