import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/constants/app_colors.dart';
import 'package:quick_chat/constants/context_extention.dart';
import 'package:quick_chat/constants/text_styles.dart';
import 'package:quick_chat/riverpod/auth_provider.dart';
import 'package:quick_chat/ui/login_screen/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: Text(
          "Quick Chat",
          style: bodySemiBold14.copyWith(color: AppColors.kBSDark),
        ),
        actions: [
          Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final authNotifier = ref.watch(authProvider);
            return IconButton(
              onPressed: () {
                authNotifier.logOutUser();
                context.navigateToScreen(isReplaced: true, child: LoginScreen());
              },
              icon: const Icon(Icons.logout),
            );
          })
        ],
      ),
    );
  }
}
