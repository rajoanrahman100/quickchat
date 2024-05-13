import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_chat/riverpod/auth_provider.dart';

class SignUpScreen extends ConsumerWidget {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authNotifier = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Name",
              ),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                hintText: "Password",
              ),
            ),
            ElevatedButton(onPressed: (){
              authNotifier.signUpUserWithFirebase(emailController.text, passwordController.text, nameController.text);
            }, child: Text("Sign UP"))
          ]
        ),
      ),
    );
  }
}
