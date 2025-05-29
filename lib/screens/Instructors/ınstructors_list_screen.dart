import 'package:education_platform/screens/Instructors/%C4%B1nstructor_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';

class InstructorsListScreen extends StatefulWidget {
  @override
  _InstructorsListScreenState createState() => _InstructorsListScreenState();
}

class _InstructorsListScreenState extends State<InstructorsListScreen> {
  late Future<List<dynamic>> _instructors;

  @override
  void initState() {
    super.initState();
    _instructors = ApiService().getInstructors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eğitimciler"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: _instructors,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.deepPurple));
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  '❌ Bir hata oluştu:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  '🫥 Hiç eğitimci bulunamadı.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              );
            } else {
              List<dynamic> instructors = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: instructors.length,
                itemBuilder: (context, index) {
                  var instructor = instructors[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: instructor['profileImage'] != null
                            ? NetworkImage(instructor['profileImage'])
                            : const AssetImage('assets/images/avatar_placeholder.png') as ImageProvider,
                        backgroundColor: Colors.grey[300],
                      ),
                      title: Text(
                        instructor['fullName'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                      ),
                      subtitle: Text(
                        instructor['department'],
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.deepPurple),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InstructorDetailScreen(instructorId: instructor['id']),
                          ),
                        );
                      },
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
