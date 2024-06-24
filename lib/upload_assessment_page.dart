import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadAssessmentPage extends StatefulWidget {
  @override
  _UploadAssessmentPageState createState() => _UploadAssessmentPageState();
}

class _UploadAssessmentPageState extends State<UploadAssessmentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _pdfURLController = TextEditingController();

  Stream<QuerySnapshot> _assessmentsStream = FirebaseFirestore.instance.collection('assessments').snapshots();

  // Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('assessments').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'pdfURL': _pdfURLController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Assessment added successfully'),
            duration: Duration(seconds: 3),
          ),
        );

        _titleController.clear();
        _descriptionController.clear();
        _pdfURLController.clear();
        setState(() {
          _assessmentsStream = FirebaseFirestore.instance.collection('assessments').snapshots();
        });

        Navigator.pop(context);
      }
    }

  // Function to remove an assessment
  void _removeAssessment(String docId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('assessments').doc(docId).delete();
      setState(() {
        _assessmentsStream = FirebaseFirestore.instance.collection('assessments').snapshots();
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
        title: Text('Upload Assessment'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _assessmentsStream = FirebaseFirestore.instance.collection('assessments').snapshots();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                controller: _pdfURLController,
                decoration: InputDecoration(labelText: 'PDF URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the PDF URL';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Assessment'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _assessmentsStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          DataColumn(label: Text('PDF URL')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          return DataRow(
                            cells: [
                              DataCell(Text(data['title'])),
                              DataCell(Text(data['description'])),
                              DataCell(
                                InkWell(
                                  onTap: () => _launchURL(data['pdfURL']),
                                  child: Text(
                                    data['pdfURL'] ,
                                    style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _removeAssessment(document.id),
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
      ),
    );
  }
}
