import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:law_app/reusable_widgets/reusable_widgets.dart';

import '../../utils/constants/sizes.dart';
import 'full_form_screen.dart';

class ApplicationsSubmitted extends StatefulWidget {
  const ApplicationsSubmitted({super.key});

  @override
  _ApplicationsSubmittedState createState() => _ApplicationsSubmittedState();
}

class _ApplicationsSubmittedState extends State<ApplicationsSubmitted> {
  late Stream<QuerySnapshot> applications;

  @override
  void initState() {
    super.initState();
    // Initialize the stream to listen for changes in the Firestore collection
    applications = _getApplicationsStream();
  }

  Stream<QuerySnapshot> _getApplicationsStream() {
    // Get the current user's email
    String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    // Query Firestore to get forms submitted by the current user
    return FirebaseFirestore.instance
        .collection('applications')
        .where('Email', isEqualTo: currentUserEmail)
        .snapshots();
  }

  void _viewForm(DocumentSnapshot formSnapshot) {
    // Navigate to the form details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullFormDetailsScreen(form: formSnapshot),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Submitted Forms',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineMedium
                          ?.apply(color: Colors.white),
                    ),
                    showBackArrow: true,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBetweenSections,
                  ),
                ],
              ),
            ),
            // Your header container
            // StreamBuilder to listen to changes in the Firestore collection
            StreamBuilder<QuerySnapshot>(
              stream: applications,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final List<DocumentSnapshot> forms = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: forms.length,
                  itemBuilder: (context, index) {
                    final form = forms[index];
                    return ListTile(
                      title: Text(form['Category']),
                      subtitle:
                      Text('Submitted by: ${form['Email'].toString()}'),
                      onTap: () {
                        _viewForm(form);
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

showWithdrawalConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).popUntil((route) => route.isFirst); // Remove all popups
      });
      return const AlertDialog(
        title: Text('Withdrawal Confirmation'),
        content: Text('Your application was withdrawn.'),
      );
    },
  );
}


