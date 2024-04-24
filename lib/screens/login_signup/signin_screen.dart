import 'package:flutter/material.dart';
import 'package:law_app/reusable_widgets/styles/spacing_styles.dart';
import 'package:law_app/utils/constants/sizes.dart';
import 'package:law_app/utils/constants/text_strings.dart';
import 'package:law_app/utils/helpers/helper_functions.dart';
import '../../reusable_widgets/reusable_widgets.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: TSpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [

                TLoginHeader(),

                TLoginForm(),

                TFormDivider(dividerText: TTexts.orSignInWith),

                SizedBox(
                  height: TSizes.spaceBetweenSections,
                ),
                TGoogleLogin(),
              ],
            )),
      ),
    );
  }
}


