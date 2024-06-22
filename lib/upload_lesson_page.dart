import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadLessonPage extends StatefulWidget {
  @override
  _UploadLessonPageState createState() => _UploadLessonPageState();
}

class _UploadLessonPageState extends State<UploadLessonPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _slidesURLController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Stream<QuerySnapshot> _lessonsStream = FirebaseFirestore.instance.collection('lessons').snapshots();

  // Function to handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Add a new document with auto-generated ID
      await firestore.collection('lessons').add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'slidesURL': _slidesURLController.text,
        'createdAt': Timestamp.now(), // Store current timestamp
        'createdBy': _createdByController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lesson added successfully'),
          duration: Duration(seconds: 3),
        ),
      );

      // Clear text controllers after submission
      _titleController.clear();
      _descriptionController.clear();
      _slidesURLController.clear();
      _createdByController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _lessonsStream = FirebaseFirestore.instance.collection('lessons').snapshots(); // Update the stream
      });

      // Navigate back to Manage Lessons page
      Navigator.pop(context);
    }
  }

  // Function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Lesson'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _lessonsStream = FirebaseFirestore.instance.collection('lessons').snapshots(); // Refresh the stream
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
              TextFormField(
                controller: _createdByController,
                decoration: InputDecoration(labelText: 'Created By'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the creator\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Created At: ${_selectedDate.toLocal()}'.split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Lesson'),
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _lessonsStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        Timestamp createdAt = data['createdAt'];
                        DateTime createdAtDate = createdAt.toDate();
                        return ListTile(
                          title: Text(data['title']),
                          subtitle: Text(data['description']),
                          trailing: Text('Created by: ${data['createdBy']} on ${createdAtDate.toLocal()}'),
                        );
                      }).toList(),
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
