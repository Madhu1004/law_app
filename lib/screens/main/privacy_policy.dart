import 'package:flutter/material.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../../utils/constants/sizes.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample privacy policy text
    List<String> privacyPolicyText = [
      'We collect and store information you provide to us',
      'We use cookies to enhance user experience',
      'We do not share your personal information with third parties',
      'You can opt-out of data collection at any time',
      'You can delete your account anytime.',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      'Privacy & Policy',
                      style: Theme.of(context).textTheme.headlineMedium?.apply(color: Colors.white),
                    ),
                    showBackArrow: true,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBetweenSections,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: MediaQuery.of(context).size.width, // Match device width
                decoration: BoxDecoration(
                  color: Colors.deepPurple[200], // Light purple background color
                  border: Border.all(color: Colors.black), // Border color
                  borderRadius: BorderRadius.circular(10.0), // Border radius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (String policy in privacyPolicyText)
                      ListTile(
                        leading: const Icon(Icons.circle, size: TSizes.sm,),
                        title: Text(policy),
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
