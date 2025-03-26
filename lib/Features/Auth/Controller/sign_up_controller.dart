import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Dashboard/Screen/dashboard_screen.dart';
import '../../Map/Screen/map_screen.dart';

class SignUpController {
  final BuildContext context;

  SignUpController({required this.context});

  Future<void> createUserEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // You might want to store the user's name in your database as well.
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signup successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MapScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Signup failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
