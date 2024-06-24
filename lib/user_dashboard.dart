import 'package:flutter/material.dart';
import 'assessment_list_page.dart'; // Import the assessment list page here
import 'lesson_list_page.dart'; // Import the lessons page here
import 'quiz_list_page.dart'; // Import the quizzes page here

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AssessmentListPage(), // Assessment list page
    LessonListPage(), // Lessons page
    QuizListPage(), // Quizzes page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  ButtonStyle _buttonStyle(int index) {
    return ElevatedButton.styleFrom(
      backgroundColor: _selectedIndex == index ? Colors.blue : Colors.white70,
      foregroundColor: _selectedIndex == index ? Colors.white : Colors.black,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EduQuest', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Center buttons horizontally
            children: <Widget>[
              ElevatedButton(
                style: _buttonStyle(0),
                onPressed: () => _onItemTapped(0),
                child: const Text('Assessments'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: _buttonStyle(1),
                onPressed: () => _onItemTapped(1),
                child: const Text('Lessons'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: _buttonStyle(2),
                onPressed: () => _onItemTapped(2),
                child: const Text('Quizzes'),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}