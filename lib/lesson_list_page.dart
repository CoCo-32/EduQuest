import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lesson_detail_page.dart'; // Import the LessonDetailPage

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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No lessons available'));
          }
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
                        url: lesson['slidesURL'], // Fetch slidesURL instead of fileUrl
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
