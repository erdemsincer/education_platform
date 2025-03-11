import 'package:flutter/material.dart';
import '/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';  // SharedPreferences import'u

class DiscussionDetailScreen extends StatefulWidget {
  final int discussionId;

  DiscussionDetailScreen({required this.discussionId});

  @override
  _DiscussionDetailScreenState createState() => _DiscussionDetailScreenState();
}

class _DiscussionDetailScreenState extends State<DiscussionDetailScreen> {
  late Future<Map<String, dynamic>?> _discussionDetail;
  TextEditingController _replyController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _discussionDetail = ApiService().getDiscussionDetail(widget.discussionId);
  }

  // Yorum gönderme
  Future<void> _postReply() async {
    String message = _replyController.text.trim();
    if (message.isEmpty) {
      return;  // Yorum boş ise gönderme
    }

    setState(() {
      _isSubmitting = true;  // Yorum gönderme işlemi başladı
    });

    try {
      // Kullanıcı ID'sini SharedPreferences'ten alıyoruz
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString("userId");

      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kullanıcı ID bulunamadı. Lütfen giriş yapın.')),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      bool success = await ApiService().postReply(widget.discussionId, message);

      setState(() {
        _isSubmitting = false;  // Yorum gönderme işlemi tamamlandı
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yorum başarıyla gönderildi!')),
        );
        _replyController.clear();  // Yorum gönderildikten sonra formu temizle
        setState(() {
          _discussionDetail = ApiService().getDiscussionDetail(widget.discussionId);  // Yanıtları yeniden yükle
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yorum gönderilemedi. Lütfen tekrar deneyin.')),
        );
      }
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bir hata oluştu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tartışma Detayı')),
      body: FutureBuilder<Map<String, dynamic>?>(  // API'den veri çekiyoruz
        future: _discussionDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Tartışma bulunamadı.'));
          } else {
            var discussion = snapshot.data!;
            String title = discussion['title'] ?? 'Başlık Yok';
            String content = discussion['content'] ?? 'İçerik Yok';
            String userFullName = discussion['userFullName'] ?? 'Yazar Bilgisi Yok';
            List<dynamic> replies = discussion['replies'] ?? [];

            return SingleChildScrollView(  // Kaydırılabilir yapıyoruz
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tartışma başlığı ve yazarı
                  Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Yazan: $userFullName', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                  SizedBox(height: 10),
                  Text(content, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 20),
                  Text('Yanıtlar:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(), // Listeyi kaydırma dışı bırakıyoruz
                    itemCount: replies.length,
                    itemBuilder: (context, index) {
                      var reply = replies[index];
                      String message = reply['message'] ?? 'Mesaj Yok';
                      String replyUserFullName = reply['userFullName'] ?? 'Bilgi Yok';
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: ListTile(
                          title: Text(replyUserFullName, style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(message),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Yorum yapma formu
                  TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      labelText: 'Yanıtınızı yazın...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _postReply,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSubmitting
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('Yorumu Gönder', style: TextStyle(fontSize: 16)),
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
