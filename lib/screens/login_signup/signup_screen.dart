import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:law_app/reusable_widgets/reusable_widgets.dart';
import 'package:law_app/utils/constants/text_strings.dart';

import '../../utils/constants/sizes.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // TextEditingController _emailTextController = TextEditingController();
  // TextEditingController _passwordController = TextEditingController();
  // TextEditingController _mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: TSizes.spaceBetweenSections,
              ),

              const TSignUpForm(),

              const SizedBox(
                height: TSizes.spaceBetweenSections,
              ),
              TFormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              const SizedBox(
                height: TSizes.spaceBetweenSections,
              ),
              const TGoogleLogin(),
            ],
          ),
        ),
      ),
    );
  }
}


