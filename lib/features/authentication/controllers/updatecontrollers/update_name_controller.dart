import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:law_app/data/user/user_repository.dart';
import 'package:law_app/features/authentication/controllers/user_controller.dart';
import 'package:law_app/screens/main/profile.dart';
import 'package:law_app/utils/constants/image_strings.dart';
import 'package:law_app/utils/popups/full_screen_loader.dart';
import 'package:law_app/utils/popups/loaders.dart';

import '../../../../reusable_widgets/reusable_widgets.dart';

class UpdateNameController extends GetxController{
  static UpdateNameController get instance => Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async{
    firstName.text = userController.user.value.firstName;
    lastName.text = userController.user.value.lastName;
  }

  Future<void> updateUserName() async{
    try{
      TFullScreenLoader.openLoadingDialog('We are updating your info..', TImages.docerAnimation);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stoploading();
        return;
      }

      if (!updateUserNameFormKey.currentState!.validate()) {
        TFullScreenLoader.stoploading();
        return;
      }

      Map<String, dynamic> name = {'FirstName': firstName.text.trim(), 'LastName': lastName.text.trim()};
      await userRepository.updateSingleField(name);

      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      TFullScreenLoader.stoploading();

      TLoaders.successSnackBar(title: 'Congratulations!', message: 'Your Name has been updated');

      Get.off(()=> const ProfileScreen());

    }catch (e){
      TFullScreenLoader.stoploading();
      TLoaders.errorSnackBar(title: 'oh no!!!!', message: e.toString());
    }
  }
}