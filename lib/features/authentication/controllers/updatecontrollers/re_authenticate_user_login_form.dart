import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:law_app/features/authentication/controllers/user_controller.dart';
import 'package:law_app/utils/constants/sizes.dart';
import 'package:law_app/utils/constants/text_strings.dart';
import 'package:law_app/utils/validators/validations.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Re-Authenticate User')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.verifyEmail,
                  validator: TValidator.validateEmail,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.user_edit),
                      labelText: TTexts.email),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),

            Obx(
                      () => TextFormField(
                      obscureText: controller.hidePassword.value,
                      controller: controller.verifyPassword,
                      validator: (value) =>
                          TValidator.validateEmptyText('Password', value),
                      decoration: InputDecoration(
                          labelText: TTexts.password,
                          prefixIcon: const Icon(Iconsax.password_check),
                          suffixIcon: IconButton(
                              onPressed: () => controller.hidePassword.value =
                                  !controller.hidePassword.value,
                              icon: const Icon(Iconsax.eye_slash),
                          )
                      ),
                    ),
                ),
            const SizedBox(height: TSizes.spaceBetweenSections),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: ()=> controller.reAuthenticateEmailAndPasswordUser(), child: const Text('Verify')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}