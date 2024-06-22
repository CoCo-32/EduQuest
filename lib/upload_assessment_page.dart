import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class UploadAssessmentPage extends StatefulWidget {
  @override
  _UploadAssessmentPageState createState() => _UploadAssessmentPageState();
}

class _UploadAssessmentPageState extends State<UploadAssessmentPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  String? _title;
  String? _description;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _submitAssessment() async {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      _formKey.currentState!.save();
      try {
        // Upload PDF to Firebase Storage
        TaskSnapshot snapshot = await FirebaseStorage.instance
            .ref('assessments/${_selectedFile!.path.split('/').last}') // Use file name from path
            .putFile(_selectedFile!);

        // Get the download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();

        // Save details to Firestore
        await FirebaseFirestore.instance.collection('assessments').add({
          'title': _title,
          'description': _description,
          'fileUrl': downloadUrl,
          'timestamp': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Assessment Uploaded Successfully')));
      } on FirebaseException catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload assessment')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Assessment')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  _description = value;
                },
              ),
              ElevatedButton(
                onPressed: _pickFile,
                child: Text('Select PDF'),
              ),
              _selectedFile != null ? Text('Selected: ${_selectedFile!.path.split('/').last}') : Container(),
              ElevatedButton(
                onPressed: _submitAssessment,
                child: Text('Upload Assessment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
