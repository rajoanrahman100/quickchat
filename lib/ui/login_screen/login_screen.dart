import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:quick_chat/constants/app_assets.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/context_extention.dart';
import 'package:quick_chat/constants/text_styles.dart';
import 'package:quick_chat/helper/validation.dart';
import 'package:quick_chat/riverpod/auth_provider.dart';
import 'package:quick_chat/ui/home_screen/home_screen.dart';
import 'package:quick_chat/ui/sign_up_screen/signup_screen.dart';

class LoginScreen extends ConsumerWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          "Sign In",
          style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(children: [
              const Gap(60.0),
              Image.asset(
                AppAssets.chatImage,
                height: 70,
                width: 70,
              ),
              const Gap(60.0),
              Text(
                "Let's connect with friends",
                style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
              ),
              const Gap(20.0),
              TextFormField(
                style: bodyMedium14.copyWith(color: AppColors.kBSDark),
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Email",
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: Validations.validateEmail,
              ),
              const Gap(15.0),
              TextFormField(
                style: bodyMedium14.copyWith(color: AppColors.kBSDark),
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: "Password",
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                validator: Validations.validatePassword,
              ),
              const Gap(15.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    FocusScope.of(context).unfocus();
                    authNotifier.loginUserWithFirebase(emailController.text, passwordController.text).then((value) {
                      context.navigateToScreen(isReplaced: true, child: const HomeScreen());
                    });
                  }
                },
                child: authNotifier.isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,width: 20,child: CircularProgressIndicator(color: AppColors.white,strokeWidth: 2.0,)),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In',
                            style: bodySemiBold14.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
              ),
              const Gap(10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: bodyMedium14.copyWith(color: AppColors.kBSDark),
                  ),
                  TextButton(
                    onPressed: () {
                      context.navigateToScreen(child: SignUpScreen());
                    },
                    child: Text(
                      'SignUp',
                      style: bodyMedium14.copyWith(color: AppColors.kBSDark),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
