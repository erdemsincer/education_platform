import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';

class LatestTestimonialsWidget extends StatefulWidget {
  @override
  State<LatestTestimonialsWidget> createState() => _LatestTestimonialsWidgetState();
}

class _LatestTestimonialsWidgetState extends State<LatestTestimonialsWidget> {
  late Future<List<Map<String, dynamic>>> _testimonials;

  @override
  void initState() {
    super.initState();
    _testimonials = ApiService().getTestimonials(); // API'den tüm referansları al
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "🌟 Referanslarımız",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _testimonials,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Hata: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("Henüz referans bulunamadı."));
              } else {
                final testimonials = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: testimonials.length > 4 ? 4 : testimonials.length,
                  itemBuilder: (context, index) {
                    final testimonial = testimonials[index];
                    return _buildTestimonialCard(testimonial);
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(Map<String, dynamic> testimonial) {
    ImageProvider avatar;

    try {
      avatar = MemoryImage(base64Decode(testimonial['imageUrl'].split(',')[1]));
    } catch (_) {
      avatar = const NetworkImage("https://via.placeholder.com/150");
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(radius: 35, backgroundImage: avatar),
            const SizedBox(height: 10),
            Text(
              testimonial['name'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              testimonial['title'],
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "\"${testimonial['comment']}\"",
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                testimonial['star'],
                    (index) => const Icon(Icons.star, color: Colors.amber, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
