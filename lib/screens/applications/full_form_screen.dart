import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:law_app/utils/constants/sizes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'application_submitted.dart';

class FullFormDetailsScreen extends StatefulWidget {
  final DocumentSnapshot form;

  const FullFormDetailsScreen({Key? key, required this.form}) : super(key: key);

  @override
  _FullFormDetailsScreenState createState() => _FullFormDetailsScreenState();
}

class _FullFormDetailsScreenState extends State<FullFormDetailsScreen> {
  late List<String> _filePaths; // Define _filePaths variable here

  @override
  void initState() {
    super.initState();
    // Initialize _filePaths with the document URLs if they exist, otherwise set it to an empty list
    _filePaths = (widget.form.data() as Map<String, dynamic>).containsKey('DocumentUrls')
        ? (widget.form['DocumentUrls'] as String).split(';')
        : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Form Details',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              title: const Text(
                'Category:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.form['Category']),
            ),
            ListTile(
              title: const Text(
                'Name:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.form['Name']),
            ),
            ListTile(
              title: const Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.form['Email']),
            ),
            ListTile(
              title: const Text(
                'Issue:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(widget.form['Issue']),
            ),
            ..._filePaths.asMap().entries.map((entry) {
              final index = entry.key;
              final filePath = entry.value;
              return ListTile(
                title: Text(
                  'Document ${index + 1}:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: filePath.isNotEmpty
                    ? filePath.endsWith('.pdf')
                    ? SizedBox(
                  height: 300,
                  child: PDFView(
                    filePath: filePath,
                  ),
                )
                    : Row(
                  children: [
                    Expanded(
                      child: Text(
                        'View Document ${index + 1}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        _launchURL(filePath);
                      },
                      child: const Text('--------> Click to view'),
                    ),
                  ],
                )
                    : const Text('No document available'),
              );
            }),

            ListTile(
              title: const Text(
                'Submitted on:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(_formatDate(widget.form['Timestamp'])),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // Handle edit action here
              editForm(context, widget.form.reference);
            },
            tooltip: 'Edit',
            child: const Icon(Icons.edit),
          ),
          const SizedBox(width: 16), // Adjust spacing between buttons
          FloatingActionButton(
            onPressed: () {
              // Handle withdrawal action here
              withdrawForm(context, widget.form.reference);
            },
            tooltip: 'Withdraw',
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = '${dateTime.day}-${dateTime.month}-${dateTime.year}';
    return formattedDate;
  }

  void withdrawForm(BuildContext context, DocumentReference formRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('The process is Irreversible!!'),
          content: const Text('Are you sure you want to withdraw your form?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                showIrreversibleConfirmation(context, formRef);
              },
              child: const SizedBox(
                width: 120,
                height: 15,
                child: Center(child: Text('Yes')),
              ),
            ),
          ],
        );
      },
    );
  }

  void showIrreversibleConfirmation(
      BuildContext context, DocumentReference formRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Withdraw Confirmation'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                formRef.delete().then((_) {
                  showWithdrawalConfirmation(context);
                });
                // Additional action if needed after withdrawal
              },
              child: const SizedBox(
                width: 120,
                height: 15,
                child: Center(child: Text('Withdraw')),
              ),
            ),
          ],
        );
      },
    );
  }

  void editForm(BuildContext context, DocumentReference formRef) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditFormScreen(formRef: formRef),
      ),
    );
  }
}

class EditFormScreen extends StatefulWidget {
  final DocumentReference formRef;

  const EditFormScreen({Key? key, required this.formRef}) : super(key: key);

  @override
  _EditFormScreenState createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  late String dropdownValue;
  String? _filePath;

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
    dropdownValue = items.first; // Initialize with the first item
    fetchFormDetails();
  }

  void fetchFormDetails() {
    widget.formRef.get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          nameController.text = data['Name'];
          emailController.text = data['Email'];
          issueController.text = data['Issue'];
          dropdownValue = data['Category'];
          // Assuming 'DocumentUrl' is the key for the document path
          _filePath = data['DocumentUrl'];
        });
      }
    });
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> updateForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Update form details in Firestore
      await widget.formRef.update({
        'Name': nameController.text,
        'Email': emailController.text,
        'Issue': issueController.text,
        'Category': dropdownValue,
        'DocumentUrls': _filePath , // Update document URLs
      });

      // Navigate back to the form details screen
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Changes Saved'),
            content: const Text('Your changes have been saved successfully.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      // Show confirmation message or perform additional actions if needed
    } catch (e) {
      // Handle error
      if (kDebugMode) {
        print('Error updating form: $e');
      }
    }
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Edit Form',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: TSizes.spaceBtwItems),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: issueController,
                decoration: const InputDecoration(labelText: 'Issue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the issue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                        }
                      },
                      items: items
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: _selectFile,
                  child: Text(
                    _filePath == null
                        ? 'Select Document'
                        : 'Document Selected',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_filePath != null)
                Text(
                  'Selected Document: $_filePath',
                  style: const TextStyle(color: Colors.purple),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateForm,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    issueController.dispose();
    super.dispose();
  }
}

