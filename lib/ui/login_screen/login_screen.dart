import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Text(
          "Quick Chat",
          style: bodyMedium16.copyWith(color: AppColors.kBSDark),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TextFormField(
              decoration: InputDecoration(
            hintText: "Email",
            labelText: "Email",
          )),
          Gap(20.0),
          TextFormField(
              decoration: InputDecoration(
            hintText: "Password",
            labelText: "Password",
          )),
        ]),
      ),
    );
  }
}
