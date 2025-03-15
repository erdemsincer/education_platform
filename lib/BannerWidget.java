import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:education_platform/services/api_service.dart';  // Ensure correct API import

class BannerWidget extends StatefulWidget {
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<List<Map<String, dynamic>>> _banners;

  @override
  void initState() {
    super.initState();
    _banners = ApiService().getBanners();  // Fetch the banners from the API
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _banners,
      builder: (context, snapshot) {
        // Loading indicator while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        // Error handling in case the API request fails
        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        }

        // If there is no data or empty response
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Banner bulunamadı"));
        }

        var banners = snapshot.data!;

        return CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            viewportFraction: 1.0,
          ),
          items: banners.map((banner) {
            // Ensure we handle the image URL properly, if the field is not available, fallback to a default image
            String imageUrl = banner['imageUrl'] ?? 'https://via.placeholder.com/150';

            return Builder(
              builder: (BuildContext context) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      banner['title'] ?? 'Başlık Yok',  // Handle case where title may be missing
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
