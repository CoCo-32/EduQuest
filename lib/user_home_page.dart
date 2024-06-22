import 'package:flutter/material.dart';
import 'assessment_list_page.dart';
import 'quiz_list_page.dart';
import 'lesson_list_page.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EduQuest - User Homepage'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssessmentListPage()),
                );
              },
              child: Text('View Assessments'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuizListPage()),
                );
              },
              child: Text('View Quizzes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LessonListPage()),
                );
              },
              child: Text('View Lessons'),
            ),
          ],
        ),
      ),
    );
  }
}
