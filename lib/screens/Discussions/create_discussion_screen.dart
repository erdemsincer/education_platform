import 'package:flutter/material.dart';
import '/services/api_service.dart';

class CreateDiscussionScreen extends StatefulWidget {
  @override
  _CreateDiscussionScreenState createState() => _CreateDiscussionScreenState();
}

class _CreateDiscussionScreenState extends State<CreateDiscussionScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  // Instance of ApiService
  final ApiService _apiService = ApiService();

  // Handle form submission
  Future<void> _createDiscussion() async {
    setState(() {
      _isSubmitting = true;
    });

    bool success = await _apiService.createDiscussion(
      _titleController.text,
      _contentController.text,
    );

    setState(() {
      _isSubmitting = false;
    });

    if (success) {
      // Discussion created successfully, navigate back or show a success message
      Navigator.pop(context);  // Go back to the previous screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tartışma başarıyla oluşturuldu!")),
      );
    } else {
      // Error in creating discussion, show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tartışma oluşturulurken bir hata oluştu.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Tartışma Oluştur"),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Başlık",
                hintText: "Tartışma başlığını girin...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),

            // Content input
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: "İçerik",
                hintText: "Tartışma içeriğini girin...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
              ),
              maxLines: 5,
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 30),

            // Submit Button
            _isSubmitting
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _createDiscussion,
              child: Text("Tartışma Oluştur", style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
