import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:quick_chat/constants/app_assets.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/text_styles.dart';
import 'package:quick_chat/helper/validation.dart';
import 'package:quick_chat/riverpod/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          "Sign Up",
          style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              Image.asset(
                AppAssets.chatImage,
                height: 70,
                width: 70,
              ),
              const Gap(30.0),
              Text(
                "Let's create an account for you",
                style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
              ),
              const Gap(20.0),
              Container(
                height: 45,
                child: TextFormField(
                  style: bodyMedium14.copyWith(color: AppColors.kBSDark),
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: "Name",
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),

                    fillColor: AppColors.white,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                    errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: Validations.validatePhoneNumber,
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FocusScope.of(context).unfocus();
                      authNotifier.signUpUserWithFirebase(
                          emailController.text, passwordController.text, nameController.text);
                    }
                  },
                  child: const Text("Sign UP"))
            ]),
          ),
        ),
      ),
    );
  }
}
