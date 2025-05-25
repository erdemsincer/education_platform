import 'package:flutter/material.dart';
import '/services/api_service.dart';

class CreateDiscussionScreen extends StatefulWidget {
  @override
  _CreateDiscussionScreenState createState() => _CreateDiscussionScreenState();
}

class _CreateDiscussionScreenState extends State<CreateDiscussionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  final ApiService _apiService = ApiService();

  Future<void> _createDiscussion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final success = await _apiService.createDiscussion(
      _titleController.text.trim(),
      _contentController.text.trim(),
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Tartışma başarıyla oluşturuldu!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Tartışma oluşturulamadı. Lütfen tekrar deneyin.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🗨️ Yeni Tartışma Oluştur"),
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title field
              TextFormField(
                controller: _titleController,
                validator: (value) =>
                value == null || value.isEmpty ? "Lütfen bir başlık girin" : null,
                decoration: _inputDecoration("Tartışma Başlığı"),
              ),
              const SizedBox(height: 20),

              // Content field
              TextFormField(
                controller: _contentController,
                validator: (value) =>
                value == null || value.isEmpty ? "Lütfen içerik girin" : null,
                maxLines: 6,
                decoration: _inputDecoration("Tartışma İçeriği"),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.send),
                  label: _isSubmitting
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text("Tartışmayı Oluştur"),
                  onPressed: _isSubmitting ? null : _createDiscussion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.indigo),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
