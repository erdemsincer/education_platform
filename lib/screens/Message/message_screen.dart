import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_platform/services/api_service.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Mesajı gönderme işlemi
  Future<void> _sendMessage() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String subject = _subjectController.text;
    String content = _contentController.text;

    if (name.isNotEmpty && email.isNotEmpty && subject.isNotEmpty && content.isNotEmpty) {
      bool success = await ApiService().sendMessage(name, email, subject, content);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mesaj başarıyla gönderildi!'))
        );
        _clearFields(); // Formu temizle
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Mesaj gönderilemedi. Lütfen tekrar deneyin.'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lütfen tüm alanları doldurun.'))
      );
    }
  }

  // Formu temizle
  void _clearFields() {
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mesaj Gönder"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Adınız",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "E-posta adresiniz",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  hintText: "Konu",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Mesajınızı yazın...",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendMessage,
                child: Text("Gönder"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
