import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';

class InstructorDetailScreen extends StatefulWidget {
  final int instructorId;

  InstructorDetailScreen({required this.instructorId});

  @override
  _InstructorDetailScreenState createState() => _InstructorDetailScreenState();
}

class _InstructorDetailScreenState extends State<InstructorDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  late Future<Map<String, dynamic>> _instructorDetail;

  @override
  void initState() {
    super.initState();
    _instructorDetail = ApiService().getInstructorDetails(widget.instructorId); // Fetch instructor details
  }

  Future<void> _submitReview() async {
    bool success = await ApiService().postReview(
      widget.instructorId,
      _commentController.text,
      _rating,
    );

    if (success) {
      // Refresh the instructor details after the review is posted
      setState(() {
        _instructorDetail = ApiService().getInstructorDetails(widget.instructorId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yorum başarılı bir şekilde gönderildi')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Yorum gönderme başarısız')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Eğitimci Detayları"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _instructorDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("Eğitimci bulunamadı"));
          } else {
            var instructor = snapshot.data!;
            var reviews = instructor['reviews'];

            return SingleChildScrollView( // Wrap everything in a SingleChildScrollView for scrolling
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Instructor details
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(instructor['profileImage']),
                  ),
                  SizedBox(height: 10),
                  Text(
                    instructor['fullName'],
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Departman: ${instructor['department']}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Başlık: ${instructor['title']}",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Biyografi: ${instructor['biography']}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),

                  // Average Rating (Rounded to nearest integer)
                  Text(
                    "Ortalama Puan: ${instructor['averageRating'].toStringAsFixed(0)}",  // Removed decimal part
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  // Reviews section
                  Text(
                    "Yorumlar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  if (reviews.isEmpty)
                    Text('Henüz yorum yapılmadı.')
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review = reviews[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(review['userName'], style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text(review['comment']),
                                SizedBox(height: 5),
                                Row(
                                  children: List.generate(5, (starIndex) {
                                    return Icon(
                                      starIndex < review['rating']
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.yellow,
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 20),

                  // Add a new review section
                  Text(
                    "Yorum Yap",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          _rating > index ? Icons.star : Icons.star_border,
                          color: Colors.yellow,
                        ),
                        onPressed: () {
                          setState(() {
                            _rating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: "Yorumunuzu buraya yazın",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitReview,
                    child: Text("Yorumu Gönder"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
