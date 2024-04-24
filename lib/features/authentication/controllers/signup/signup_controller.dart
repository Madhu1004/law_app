import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:law_app/data/repositories/authentication_repository.dart';
import 'package:law_app/data/user/user_repository.dart';
import 'package:law_app/screens/login_signup/verify_email.dart';
import 'package:law_app/utils/constants/image_strings.dart';
import 'package:law_app/utils/popups/loaders.dart';

import '../../../../reusable_widgets/reusable_widgets.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../models/user_model.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final email = TextEditingController();
  final privacyPolicy = true.obs;
  final hidePassword = true.obs;
  final lastName = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final firstName = TextEditingController();
  final phoneNumber = TextEditingController();
  final gender = TextEditingController();
  final dateOfBirth = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  Future<void> signup() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'We are processing your information...', TImages.onBoardingImage1);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stoploading();
        return;
      }

      if (!signupFormKey.currentState!.validate()) {
        TFullScreenLoader.stoploading();
        return;
      }

      TFullScreenLoader.stoploading();

      if (!privacyPolicy.value) {

        TLoaders.warningSnackBar(
            title: 'Accept the Privacy Policy',
            message:
                'In order to create your account, you must have to read and accept the Privacy Policy & Terms of use ');
        return;
      }

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '',
          dateOfBirth: dateOfBirth.text.trim(),
          gender: gender.text.trim(),

          // gender: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      TFullScreenLoader.stoploading();

      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! verify email to continue.');

      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stoploading();
      TLoaders.errorSnackBar(title: 'OH NO!!', message: e.toString());
    }
  }
}
