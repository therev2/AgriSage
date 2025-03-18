import 'dart:async';

import 'package:agrisage/Features/Auth/Screen/Login.dart';
import 'package:flutter/material.dart';
import '../ColorPage.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {


  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 1),(){
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (e)=>LoginScreen())
      );
    });

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black26,
      body: Center(
        child: Text(
          "AgriSage",
          style: TextStyle(
            color: ColorPage.lightYellowGold1,
            fontWeight: FontWeight.w700,
            fontSize:55
          ),
        ),
      ),
    );
  }
}
