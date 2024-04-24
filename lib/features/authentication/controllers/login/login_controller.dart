import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:law_app/features/authentication/controllers/user_controller.dart';
import 'package:law_app/utils/constants/image_strings.dart';
import 'package:law_app/utils/popups/full_screen_loader.dart';
import '../../../../data/repositories/authentication_repository.dart';
import '../../../../reusable_widgets/reusable_widgets.dart';
import '../../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final localStorage = GetStorage();
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  @override
  void onInit() {
    super.onInit();
    final rememberMeEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final rememberMePassword = localStorage.read('REMEMBER_ME_PASSWORD');
    if (rememberMeEmail != null) {
      email.text = rememberMeEmail;
    }
    if (rememberMePassword != null) {
      password.text = rememberMePassword;
    }
  }
  Future<void> emailAndPasswordSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog('Logging you in', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stoploading();
        return;
      }

      if (!loginFormKey.currentState!.validate()) {
        TFullScreenLoader.stoploading();
        return;
      }

      // Null check for email and password
      final emailValue = email.text.trim();
      final passwordValue = password.text.trim();
      if (emailValue == null || passwordValue == null) {
        TFullScreenLoader.stoploading();
        TLoaders.errorSnackBar(title: 'OH NO!!', message: 'Email or password is null');
        return;
      }

      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', emailValue);
        localStorage.write('REMEMBER_ME_PASSWORD', passwordValue);
      }

      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(emailValue, passwordValue);

      TFullScreenLoader.stoploading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      TFullScreenLoader.stoploading();
      TLoaders.errorSnackBar(title: 'OH NO!!', message: e.toString());
    }

  }

  Future<void> googleSignIn() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Logging you in..', TImages.emailVerification);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stoploading();
        return;
      }

      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      // userController.saveUserRecord(userCredentials);

      TFullScreenLoader.stoploading();

      AuthenticationRepository.instance.screenRedirect();


    } catch (e) {
      TFullScreenLoader.stoploading();
      TLoaders.errorSnackBar(title: 'Oh No!!', message: e.toString());
    }
  }
}
