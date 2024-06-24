import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadLessonPage extends StatefulWidget {
  @override
  _UploadLessonPageState createState() => _UploadLessonPageState();
}

class _UploadLessonPageState extends State<UploadLessonPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _slidesURLController = TextEditingController();

  Stream<QuerySnapshot> _lessonsStream =
      FirebaseFirestore.instance.collection('lessons').snapshots();

  // Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('lessons').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'slidesURL': _slidesURLController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lesson added successfully'),
          duration: Duration(seconds: 3),
        ),
      );

      _titleController.clear();
      _descriptionController.clear();
      _slidesURLController.clear();
      setState(() {
        _lessonsStream =
            FirebaseFirestore.instance.collection('lessons').snapshots();
      });

      Navigator.pop(context);
    }
  }

  // Function to remove a lesson
  void _removeLesson(String docId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('lessons').doc(docId).delete();
    setState(() {
      _lessonsStream =
          FirebaseFirestore.instance.collection('lessons').snapshots();
    });
  }

  // Function to launch URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Lesson'),
        backgroundColor: Color(0xFFFFFDD0),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _lessonsStream = FirebaseFirestore.instance
                    .collection('lessons')
                    .snapshots();
              });
            },
          ),
        ],
      ),
      backgroundColor: Color(0xFFFFFDD0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 800,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _slidesURLController,
                      decoration: InputDecoration(labelText: 'Slides URL'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the slides URL';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Add Lesson'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _lessonsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Title')),
                        DataColumn(label: Text('Description')),
                        DataColumn(label: Text('Slides URL')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        return DataRow(
                          cells: [
                            DataCell(Text(data['title'])),
                            DataCell(Text(data['description'])),
                            DataCell(
                              InkWell(
                                onTap: () => _launchURL(data['slidesURL']),
                                child: Text(
                                  data['slidesURL'],
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _removeLesson(document.id),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
