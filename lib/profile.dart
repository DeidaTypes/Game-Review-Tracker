import 'package:flutter/material.dart';
import 'authenticate.dart'; // replace with the path to your auth_service.dart file
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService authService = AuthService();
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child:
            user == null ? const NotLoggedInWidget() : const LoggedInWidget(),
      ),
    );
  }
}

class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Welcome to the App!', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to your Sign In page
          },
          child: const Text('Sign In'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Navigate to your Sign Up page
          },
          child: Text('Sign Up'),
        ),
      ],
    );
  }
}

class LoggedInWidget extends StatelessWidget {
  const LoggedInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Welcome, user!',
            style:
                TextStyle(fontSize: 24)), // Display the user's information here
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Navigate to your Settings page
          },
          child: const Text('Settings'),
        ),
      ],
    );
  }
}
