import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:law_app/reusable_widgets/reusable_widgets.dart';
import 'package:law_app/utils/constants/image_strings.dart';
import 'package:law_app/utils/constants/sizes.dart';
import 'package:law_app/utils/constants/text_strings.dart';
import 'package:law_app/utils/validators/validations.dart';
import '../../features/authentication/controllers/updatecontrollers/update_name_controller.dart';
import '../../features/authentication/controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TAppBar(
                showBackArrow: true,
                title: Text('Profile'),
              ),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image =
                          networkImage.isNotEmpty ? networkImage : TImages.user;

                      return controller.imageUploading.value
                          ? const TShimmerEffect(
                              width: 80, height: 80, radius: 80)
                          : TCircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage.isNotEmpty,
                            );
                    }),
                    TextButton(
                      onPressed: () => controller.uploadUserProfilePicture(),
                      child: const Text('change Profile Pic'),
                    ),
                  ],
                ),
              ),


              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const ChangeName()), icon: Iconsax.arrow_right_34),
              TProfileMenu(
                title: 'Username',
                value: controller.user.value.username,
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: controller.user.value.username));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Username copied'),
                      duration:
                          Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );
                },
                icon: Iconsax.copy,
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              TProfileMenu(
                  title: 'User ID',
                  value: controller.user.value.id,
                  icon: Iconsax.copy,
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: controller.user.value.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('User ID copied'),
                        duration:
                            Duration(seconds: 2), // Adjust duration as needed
                      ),
                    );
                  }),
              TProfileMenu(
                title: 'E-mail',
                value: controller.user.value.email,
                icon: Iconsax.eye,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('E-mail ID'),
                        content: Text(controller.user.value.email),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              TProfileMenu(
                  title: 'Phone No.',
                  value: controller.user.value.phoneNumber,
                  onPressed: () {}, icon: Iconsax.user3),


              TProfileMenu(title: 'Gender', value: controller.user.value.gender, onPressed: () {}, icon: Iconsax.user3),
              TProfileMenu(
                  title: 'Date of Birth',
                  value: controller.user.value.dateOfBirth,
                  onPressed: () {}, icon: Iconsax.user3),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
                  child: const Text('Delete Account',
                      style: TextStyle(color: Colors.red)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Change Name',
            style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Set mainAxisSize to min
            children: [
              Text(
                'Use original name for easy verification',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBetweenSections),
              Form(
                key: controller.updateUserNameFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.firstName,
                      validator: (value) =>
                          TValidator.validateEmptyText('First Name', value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: TTexts.firstName,
                          prefixIcon: Icon(Iconsax.user)),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.lastName,
                      validator: (value) =>
                          TValidator.validateEmptyText('Last Name', value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: TTexts.lastName,
                          prefixIcon: Icon(Iconsax.user)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBetweenSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => controller.updateUserName(),
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: TSizes.defaultSpace),
              // Add some bottom padding
            ],
          ),
        ),
      ),
    );
  }
}


