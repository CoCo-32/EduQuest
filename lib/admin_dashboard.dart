import 'package:flutter/material.dart';
import 'upload_lesson_page.dart'; // Import the UploadLessonPage

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
                // Navigate to manage assessments page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageAssessmentsPage()),
                );
              },
              child: Text('Manage Assessments'),
            ),
            // Add more buttons/options as needed for other admin functionalities
          ],
        ),
      ),
    );
  }
}

// Example of Manage Assessments Page
class ManageAssessmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Assessments'),
      ),
      body: Center(
        child: Text('Implement manage assessments UI here'),
      ),
    );
  }
}
