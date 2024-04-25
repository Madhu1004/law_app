import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:law_app/reusable_widgets/reusable_widgets.dart';
import 'package:law_app/screens/main/privacy_policy.dart';
import 'package:law_app/screens/main/profile.dart';
import 'package:law_app/screens/login_signup/signin_screen.dart';
import 'package:law_app/utils/constants/sizes.dart';

import '../../features/authentication/controllers/user_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      drawer: buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text('Account',
                        style: Theme
                            .of(context)
                            .textTheme
                            .headlineMedium
                            ?.apply(color: Colors.white)),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  TUserProfileTile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(height: TSizes.spaceBetweenSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const TSectionHeading(
                      title: 'Account Settings', showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  TSettingsMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Account Privacy',
                    subTitle: 'Terms & Conditions',
                    onTap: () => Get.to(() => const PrivacyPolicy()),),
                  TSettingsMenuTile(
                    icon: Iconsax.edit,
                    title: 'Edit Profile',
                    subTitle: 'Update my profile details',
                    onTap: () => Get.to(() => const ProfileScreen()),),
                  TSettingsMenuTile(
                      icon: Iconsax.profile_delete,
                      title: 'Delete Account',
                      subTitle: 'No longer want to use my account...',
                      onTap: () => controller.deleteAccountWarningPopup(),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBetweenSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () {
                          Get.offAll(()=> const LoginScreen());
                        }, child: const Text('Logout')),
                  ),
                  const SizedBox(height: TSizes.spaceBetweenSections * 2.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
