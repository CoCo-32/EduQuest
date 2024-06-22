import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadQuizPage extends StatefulWidget {
  @override
  _UploadQuizPageState createState() => _UploadQuizPageState();
}

class _UploadQuizPageState extends State<UploadQuizPage> {
  final _formKey = GlobalKey<FormState>();
  String? _quizTitle;
  List<Map<String, dynamic>> _questions = [];

  void _addQuestion() {
    setState(() {
      _questions.add({
        'question': '',
        'options': ['', '', '', ''],
        'correctOption': 0,
      });
    });
  }

  void _updateQuestion(int index, String question) {
    setState(() {
      _questions[index]['question'] = question;
    });
  }

  void _updateOption(int questionIndex, int optionIndex, String option) {
    setState(() {
      _questions[questionIndex]['options'][optionIndex] = option;
    });
  }

  void _updateCorrectOption(int questionIndex, int correctOption) {
    setState(() {
      _questions[questionIndex]['correctOption'] = correctOption;
    });
  }

  Future<void> _submitQuiz() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance.collection('quizzes').add({
        'title': _quizTitle,
        'questions': _questions,
        'timestamp': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Quiz Uploaded Successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Quiz')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Quiz Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quiz title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quizTitle = value;
                },
              ),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(labelText: 'Question ${index + 1}'),
                          onChanged: (value) => _updateQuestion(index, value),
                        ),
                        ...List.generate(4, (optionIndex) {
                          return TextFormField(
                            decoration: InputDecoration(labelText: 'Option ${optionIndex + 1}'),
                            onChanged: (value) => _updateOption(index, optionIndex, value),
                          );
                        }),
                        DropdownButton<int>(
                          value: _questions[index]['correctOption'],
                          items: List.generate(4, (optionIndex) {
                            return DropdownMenuItem<int>(
                              value: optionIndex,
                              child: Text('Correct Option ${optionIndex + 1}'),
                            );
                          }),
                          onChanged: (value) => _updateCorrectOption(index, value!),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submitQuiz,
                child: Text('Upload Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
