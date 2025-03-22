import 'package:agrisage/Features/Auth/Screen/Login.dart';
import 'package:agrisage/Features/Dashboard/Screen/dashboard_screen.dart';
import 'package:agrisage/Features/Map/Screen/map_screen.dart';
import 'package:agrisage/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AgriSage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            if (snapshot.hasData) {
              //return const LoginScreen();
              //return const MapScreen();
              return const DashboardScreen();
            }
            //return const LoginScreen();
            //return const MapScreen();
            return const DashboardScreen();
          }),
    );
  }
}
