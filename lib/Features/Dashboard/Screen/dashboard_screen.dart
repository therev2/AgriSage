import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Auth/Screen/Login.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _signOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to the Dashboard!'),
            TextButton(
                onPressed: () => _signOut(context),
                child: const Text("Logout")
            )
          ],
        ),
      ),
    );
  }
}