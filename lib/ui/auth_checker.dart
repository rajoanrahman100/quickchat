import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/riverpod/auth_provider.dart';

import 'package:quick_chat/ui/home_screen.dart';
import 'package:quick_chat/ui/login_screen.dart';
import 'package:quick_chat/ui/splash_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);

    return _authState.when(
        data: (user) {
          if (user != null) return const HomeScreen();
          return const LoginScreen();
        },
        loading: () => const SplashScreen(),
        error: (e, trace) => const LoginScreen());
  }
}
