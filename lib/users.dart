// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:goodgame/authenticate.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _onSignInPressed() async {
    final email = emailController.text;
    final password = passwordController.text;
    final user = await authService.signInUser(email, password);
    if (user != null) {
      // Navigate to next screen or show success message
    } else {
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... other widget components
      body: Column(
        children: [
          TextField(
            controller: emailController, /* other properties */
          ),
          TextField(
            controller: passwordController, /* other properties */
          ),
          ElevatedButton(onPressed: _onSignInPressed, child: Text("Sign In")),
        ],
      ),
    );
  }
}
