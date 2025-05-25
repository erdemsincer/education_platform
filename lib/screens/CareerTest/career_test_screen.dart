import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:education_platform/services/api_service.dart';

class CareerTestScreen extends StatefulWidget {
  const CareerTestScreen({super.key});

  @override
  State<CareerTestScreen> createState() => _CareerTestScreenState();
}

class _CareerTestScreenState extends State<CareerTestScreen> {
  List<dynamic> _questions = [];
  Map<int, String> _answers = {}; // questionId -> answer
  bool _isLoading = false;
  String? _advice;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    final response = await ApiService().getCareerTestQuestions();
    setState(() {
      _questions = response;
      _isLoading = false;
    });
  }

  Future<void> _submitTest() async {
    if (_answers.length != _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm soruları yanıtlayın.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await ApiService().submitCareerTestAnswers(_answers);



    String? extractedAdvice;
    if (result != null) {
      try {
        final decoded = json.decode(result);
        extractedAdvice = decoded['careerAdvice'] ?? "Tavsiye alınamadı.";
      } catch (e) {
        extractedAdvice = "AI cevabı çözümlenemedi.";
      }
    }

    setState(() {
      _advice = extractedAdvice;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🧠 Kariyer Testi"), backgroundColor: Colors.indigo),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _questions.isEmpty
          ? const Center(child: Text("Soru bulunamadı."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ..._questions.map((q) => _buildQuestionCard(q)).toList(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitTest,
              icon: const Icon(Icons.send),
              label: const Text("Testi Gönder"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (_advice != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  border: Border.all(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "🧠 Yapay Zeka Kariyer Önerisi",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(_advice ?? "", style: const TextStyle(fontSize: 15)),
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(dynamic q) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q["questionText"], style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...List<String>.from(q["options"]).map((option) {
              return RadioListTile<String>(
                value: option,
                groupValue: _answers[q["questionId"]],
                title: Text(option),
                onChanged: (val) {
                  setState(() {
                    _answers[q["questionId"]] = val!;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
