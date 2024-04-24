import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:law_app/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:law_app/utils/constants/text_strings.dart';
import '../../reusable_widgets/reusable_widgets.dart';
import '../../utils/constants/image_strings.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // horizontal swipes for the pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePgeIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          //Skip button
          const OnBoardingSkip(),

          //   Smooth page
          const OnBoardingDotNavigation(),

          // circular button
          const OnBoardingNextButton()
        ],
      ),
    );
  }
}
