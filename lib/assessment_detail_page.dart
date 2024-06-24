import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class AssessmentDetailPage extends StatefulWidget {
  final String title;
  final String pdfURL;
  final Function? onSubmitted; // Callback function to notify parent

  AssessmentDetailPage({required this.title, required this.pdfURL, this.onSubmitted});

  @override
  _AssessmentDetailPageState createState() => _AssessmentDetailPageState();
}

class _AssessmentDetailPageState extends State<AssessmentDetailPage> {
  String name = '';
  String submissionUrl = '';
  bool isSubmitted = false;

  void submitSubmission(BuildContext context, String name, String submissionUrl) {
    FirebaseFirestore.instance.collection('submissions').add({
      'name': name,
      'submissionURL': submissionUrl,
      'time': FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission successful'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isSubmitted = true; // Update state to indicate submission is successful
      });
      // Notify parent widget (AssessmentListPage) that submission is complete
      if (widget.onSubmitted != null) {
        widget.onSubmitted!();
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  Future<void> _launchPDFURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch PDF: $url'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assessment Detail'),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('PDF URL:'),
              ElevatedButton(
                onPressed: () {
                  _launchPDFURL(widget.pdfURL);
                },
                child: Text('View PDF'),
              ),
              SizedBox(height: 20),
              Text('Submit Your Work:'),
              TextField(
                onChanged: (value) {
                  name = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  submissionUrl = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your submission URL',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (name.isNotEmpty && submissionUrl.isNotEmpty) {
                    submitSubmission(context, name, submissionUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter name and submission URL'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Text('Submit'),
              ),
              SizedBox(height: 10),
              if (isSubmitted)
                Text(
                  'Submitted',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
