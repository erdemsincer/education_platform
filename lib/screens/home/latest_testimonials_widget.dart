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
    _testimonials = ApiService().getTestimonials();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[50],
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
          const SizedBox(height: 20),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _testimonials,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.indigo));
              } else if (snapshot.hasError) {
                return Center(child: Text("❌ Hata: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("🫥 Henüz referans bulunamadı."));
              } else {
                final testimonials = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: testimonials.length > 4 ? 4 : testimonials.length,
                  padding: const EdgeInsets.only(top: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return _buildTestimonialCard(testimonials[index]);
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

    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: avatar,
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 12),
            Text(
              testimonial['name'],
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              testimonial['title'],
              style: const TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "\"${testimonial['comment']}\"",
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black87),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                testimonial['star'],
                    (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
