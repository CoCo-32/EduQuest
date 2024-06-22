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
                      builder: (context) => LessonDetailPage(
                        title: lesson['title'],
                        description: lesson['description'],
                        url: lesson['fileUrl'],
                      ),
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
  final String title;
  final String description;
  final String url;

  LessonDetailPage({required this.title, required this.description, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lesson Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement PDF viewer or open URL in browser
                // For demonstration, just show the URL
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('PDF URL'),
                    content: Text(url),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('View PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
