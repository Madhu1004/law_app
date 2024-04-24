import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';

class ApplicationForm extends StatefulWidget {
  const ApplicationForm({super.key});

  @override
  State<ApplicationForm> createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController issueController = TextEditingController();
  late String dropdownValue;

  List<String>? _filePaths;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> items = [
    'General Practice',
    'Business Lawyer',
    'Family Lawyer',
    'Real Estate',
    'Criminal Defense',
    'Personal Injury',
    'Workers’ Compensation',
    'Estate Planning',
  ];

  @override
  void initState() {
    super.initState();
    dropdownValue = items.first;
    _fetchUserEmail();
  }

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true, // Allow multiple files to be selected
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      List<String> filePaths = result.files.map((file) => file.path!).toList();
      setState(() {
        _filePaths = filePaths;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_filePaths == null || _filePaths!.isEmpty) {
      // Show error message if no file selected
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      List<String> fileUrls = [];

      for (String filePath in _filePaths!) {
        final String fileName = filePath.split('/').last;
        final Reference storageReference =
        FirebaseStorage.instance.ref().child('files/$fileName');
        final UploadTask uploadTask = storageReference.putFile(File(filePath));
        final TaskSnapshot taskSnapshot = await uploadTask;
        final String fileUrl = await taskSnapshot.ref.getDownloadURL();

        fileUrls.add(fileUrl);
      }

      // Combine file URLs into a single string separated by a delimiter
      String combinedUrls = fileUrls.join(';');

      await _firestore.collection('applications').add({
        'Name': userNameController.text,
        'Email': emailController.text,
        'Issue': issueController.text,
        'Category': dropdownValue,
        'DocumentUrls': combinedUrls, // Store concatenated URLs
        'Timestamp': Timestamp.now(),
      });

      userNameController.clear();
      emailController.clear();
      issueController.clear();
      dropdownValue = items.first;
      setState(() {
        _filePaths = null;
      });

      // Show success message
    } catch (e) {
      // Show error message
    }
  }

  Future<void> _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userSnapshot =
      await _firestore.collection('Users').doc(user.uid).get();

      if (userSnapshot.exists) {
        String userEmail = userSnapshot['Email'];
        emailController.text = userEmail;
      }
    }
  }

  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      _selectFiles();
    } else {
      // Handle permission denied
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: const Text('Service Form', style: TextStyle(fontSize: 24,
          color: Colors.white,),),
      backgroundColor: Colors.deepPurple,
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: userNameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: issueController,
                      decoration: const InputDecoration(
                        labelText: 'Issue',
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the issue';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownValue = newValue!;
                            });
                          },
                          items: items.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: _requestPermission,
                        child: Text(
                          _filePaths == null || _filePaths!.isEmpty
                              ? 'Select Document(s)'
                              : 'Documents Selected',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    if (_filePaths != null && _filePaths!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _filePaths!.map((filePath) {
                          return Text(
                            'Selected Document: $filePath',
                            style: const TextStyle(color: Colors.purple),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
