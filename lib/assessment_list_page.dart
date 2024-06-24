import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assessment_detail_page.dart'; // Import the updated AssessmentDetailPage

class AssessmentListPage extends StatefulWidget {
  @override
  _AssessmentListPageState createState() => _AssessmentListPageState();
}

class _AssessmentListPageState extends State<AssessmentListPage> {
  Map<String, bool> submissionStatus = {}; // Map to track submission status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessments'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('assessments').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No assessments available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot assessment = snapshot.data!.docs[index];
              String assessmentId = assessment.id;

              return FutureBuilder(
                future: _getSubmission(assessmentId), // Fetch submission data
                builder: (context, AsyncSnapshot<DocumentSnapshot> submissionSnapshot) {
                  if (submissionSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(assessment['title']),
                      subtitle: Text(assessment['description']),
                      trailing: CircularProgressIndicator(),
                    );
                  }

                  bool isSubmitted = submissionSnapshot.hasData && submissionSnapshot.data!.exists;
                  submissionStatus[assessmentId] = isSubmitted; // Track submission status

                  return ListTile(
                    title: Text(assessment['title']),
                    subtitle: Text(assessment['description']),
                    trailing: isSubmitted ? Text('Submitted') : null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AssessmentDetailPage(
                            title: assessment['title'],
                            pdfURL: assessment['pdfURL'],
                            onSubmitted: () {
                              // Handle submission update if needed
                              // This callback is triggered when submission is complete
                              setState(() {
                                submissionStatus[assessmentId] = true;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<DocumentSnapshot> _getSubmission(String assessmentId) async {
    try {
      return await FirebaseFirestore.instance.collection('submissions').doc(assessmentId).get();
    } catch (e) {
      print('Error fetching submission: $e');
      return Future.error(e);
    }
  }
}
