import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_detail_page.dart';

class QuizListPage extends StatefulWidget {
  @override
  _QuizListPageState createState() => _QuizListPageState();
}

class _QuizListPageState extends State<QuizListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quizzes'),
        backgroundColor: Color(0xFFFFFDD0),
      ),
      backgroundColor: Color(0xFFFFFDD0),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('quizzes').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.separated(
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
                  ).then((_) {
                    // Refresh the list when returning from the QuizDetailPage
                    setState(() {});
                  });
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey,
                thickness: 1.0,
              );
            },
          );
        },
      ),
    );
  }
}
