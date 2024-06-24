import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizDetailPage extends StatefulWidget {
  final DocumentSnapshot quiz;

  QuizDetailPage({required this.quiz});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage> {
  Map<int, int> selectedAnswers = {};
  String userName = '';

  void submitQuiz(BuildContext context) {
    int correctAnswers = 0;
    List<dynamic> questions = widget.quiz['questions'];

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['correctOption']) {
        correctAnswers++;
      }
    }

    int totalQuestions = questions.length;
    double scorePercentage = (correctAnswers / totalQuestions) * 100;

    FirebaseFirestore.instance.collection('quizsubmissions').add({
      'name': userName,
      'score': scorePercentage,
      'time': FieldValue.serverTimestamp(),
    }).then((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Result'),
            content: Text('You scored ${scorePercentage.toStringAsFixed(2)}%'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(); // Pop the current QuizDetailPage
                },
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> questions = widget.quiz['questions'];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz['title']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  var question = questions[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question['question'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      for (int optionIndex = 0; optionIndex < 4; optionIndex++)
                        RadioListTile(
                          title: Text(question['options'][optionIndex]),
                          value: optionIndex,
                          groupValue: selectedAnswers[index],
                          onChanged: (value) {
                            setState(() {
                              selectedAnswers[index] = value!;
                            });
                          },
                        ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
            ),
            TextField(
              onChanged: (value) {
                userName = value;
              },
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (userName.isNotEmpty) {
                  submitQuiz(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
