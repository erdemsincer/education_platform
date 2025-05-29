import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';
import '../Instructors/ınstructor_detail_screen.dart';
import '../Instructors/ınstructors_list_screen.dart';

class LatestInstructorsWidget extends StatefulWidget {
  @override
  State<LatestInstructorsWidget> createState() => _LatestInstructorsWidgetState();
}

class _LatestInstructorsWidgetState extends State<LatestInstructorsWidget> {
  late Future<List<Map<String, dynamic>>> _instructors;

  @override
  void initState() {
    super.initState();
    _instructors = ApiService().getLastFourInstructors();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "👨‍🏫 Son Eklenen Eğitmenler",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _instructors,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Colors.indigo));
              } else if (snapshot.hasError) {
                return Center(child: Text("❌ Hata: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("🫥 Eğitmen bulunamadı."));
              } else {
                final instructors = snapshot.data!;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: instructors.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    return _buildInstructorCard(instructors[index]);
                  },
                );
              }
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => InstructorsListScreen()));
              },
              icon: const Icon(Icons.people_alt_rounded),
              label: const Text("Tüm Eğitmenleri Gör"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructorCard(Map<String, dynamic> instructor) {
    final profileImage = instructor['profileImage'];
    late ImageProvider avatar;

    try {
      avatar = MemoryImage(const Base64Decoder().convert(profileImage.split(',')[1]));
    } catch (_) {
      avatar = const NetworkImage("https://via.placeholder.com/150");
    }

    return Material(
      elevation: 6,
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InstructorDetailScreen(instructorId: instructor['id']),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.indigo.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: avatar,
                backgroundColor: Colors.grey.shade200,
              ),
              const SizedBox(height: 12),
              Text(
                instructor['fullName'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                instructor['title'] ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                instructor['department'] ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
