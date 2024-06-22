import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot assessment = snapshot.data!.docs[index];
              return ListTile(
                title: Text(assessment['title']),
                subtitle: Text(assessment['description']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssessmentDetailPage(url: assessment['fileUrl']),
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

class AssessmentDetailPage extends StatelessWidget {
  final String url;

  AssessmentDetailPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment Detail'),
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
