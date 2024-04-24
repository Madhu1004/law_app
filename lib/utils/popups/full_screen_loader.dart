import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:law_app/utils/constants/colors.dart';
import 'package:law_app/utils/helpers/helper_functions.dart';

import '../../reusable_widgets/reusable_widgets.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: THelperFunctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20), // Adjust as needed
              TAnimationLoaderWidget(text: text, animation: animation),
              const SizedBox(height: 20), // Adjust as needed
            ],
          ),
        ),
      ),
    );
  }

  static void stoploading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
