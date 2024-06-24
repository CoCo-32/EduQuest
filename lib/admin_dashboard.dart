import 'package:flutter/material.dart';
import 'upload_lesson_page.dart'; // Import the UploadLessonPage
import 'upload_assessment_page.dart'; // Import the UploadAssessmentPage
import 'upload_quiz_page.dart'; // Import the UploadQuizPage
import 'role_selection_page.dart'; // Import the RoleSelectionPage

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, Admin!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to upload lesson page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadLessonPage()),
                );
              },
              child: Text('Manage Lessons'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to upload assessment page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadAssessmentPage()),
                );
              },
              child: Text('Manage Assessments'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to upload quiz page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadQuizPage()),
                );
              },
              child: Text('Manage Quizzes'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Log out and navigate to role selection page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => RoleSelectionPage()),
                      (Route<dynamic> route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}