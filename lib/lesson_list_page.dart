import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LessonListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lessons'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('lessons').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot lesson = snapshot.data!.docs[index];
              return ListTile(
                title: Text(lesson['title']),
                subtitle: Text(lesson['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonDetailPage(url: lesson['fileUrl']),
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

class LessonDetailPage extends StatelessWidget {
  final String url;

  LessonDetailPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Detail'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('PDF URL: $url'),
            ElevatedButton(
              onPressed: () {
                // Implement PDF viewer here
              },
              child: Text('View PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
