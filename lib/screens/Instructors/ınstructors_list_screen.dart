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
    _instructors = ApiService().getInstructors(); // Öğretmenler listesini alıyoruz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eğitimciler"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _instructors,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Yükleniyor göstergesi
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));  // Hata mesajı
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Öğretmen Bulunamadı'));  // Eğer öğretmen yoksa
          } else {
            List<dynamic> instructors = snapshot.data!;
            return ListView.builder(
              itemCount: instructors.length,
              itemBuilder: (context, index) {
                var instructor = instructors[index];
                return ListTile(
                  title: Text(instructor['fullName']),
                  subtitle: Text(instructor['department']),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(instructor['profileImage']),
                  ),
                  onTap: () {
                    // Öğretmene tıklandığında detayları göster
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InstructorDetailScreen(
                          instructorId: instructor['id'],  // Öğretmen ID'sini gönderiyoruz
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
