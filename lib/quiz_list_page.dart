import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot quiz = snapshot.data!.docs[index];
              return ListTile(
                title: Text(quiz['title']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizDetailPage(quiz: quiz),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class QuizDetailPage extends StatelessWidget {
  final DocumentSnapshot quiz;

  QuizDetailPage({required this.quiz});

  @override
  Widget build(BuildContext context) {
    List<dynamic> questions = quiz['questions'];

    return Scaffold(
      appBar: AppBar(
        title: Text(quiz['title']),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          var question = questions[index];
          return ListTile(
            title: Text(question['question']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(4, (optionIndex) {
                return Text('${optionIndex + 1}. ${question['options'][optionIndex]}');
              }),
            ),
          );
        },
      ),
    );
  }
}
