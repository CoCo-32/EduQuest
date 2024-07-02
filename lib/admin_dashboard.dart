import 'package:flutter/material.dart';
import 'upload_lesson_page.dart';
import 'upload_assessment_page.dart';
import 'upload_quiz_page.dart';
import 'role_selection_page.dart';
import 'check_assessment_submission_page.dart';
import 'check_quiz_submission_page.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        centerTitle: true,
        backgroundColor: Color(0xFFFFFDD0),
      ),
      backgroundColor: Color(0xFFFFFDD0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Welcome, Admin!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: 400,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to upload lesson page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadLessonPage()),
                    );
                  },
                  child: Text('Manage Lessons'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to upload assessment page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UploadAssessmentPage()),
                    );
                  },
                  child: Text('Manage Assessments'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to upload quiz page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UploadQuizPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 24),
                  ),
                  child: Text('Manage Quizzes'),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to view assessment submissions
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckAssessmentSubmissionPage()),
                    );
                  },
                  child: Text('View Assessment Submissions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 80,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to view quiz submissions
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CheckQuizSubmissionPage()),
                    );
                  },
                  child: Text('View Quiz Submissions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              SizedBox(height: 70),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Log out and navigate to role selection page
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoleSelectionPage()),
                          (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
