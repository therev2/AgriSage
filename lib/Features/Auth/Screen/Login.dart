import 'package:agrisage/ColorPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SignUp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formSignInKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _validateAndLogin() async {
    if (_formSignInKey.currentState!.validate()) {
      // Proceed with login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Processing login...'),
          backgroundColor: Color(0xFF4A6572),
        ),
      );
      await loginUserEmail();
    }
  }

  bool _rememberMe = false;

  Future<void> loginUserEmail() async {
    try {
      final userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Colors.green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: ColorPage.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Logo and header section
            Container(
              height: screenHeight * 0.3,
              width: screenWidth,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [ColorPage.primaryColor, Color(0xFF4A6572)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      // Add this ClipRRect
                      borderRadius: BorderRadius.only(
                    // With these borderRadius settings
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )),
                  Image.asset(
                    'lib/assets/AgriSage.png',
                    width: screenWidth,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 30.0, 24.0, 24.0),
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome text
                      const Center(
                        child: Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: ColorPage.textColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Email field
                      const Text(
                        "Email",
                        style: TextStyle(
                          color: ColorPage.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: ColorPage.textColor,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: ColorPage.primaryColor,
                          ),
                          filled: true,
                          fillColor: ColorPage.inputFillColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorPage.textColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      // Password field
                      const Text(
                        "Password",
                        style: TextStyle(
                          color: ColorPage.textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        style: const TextStyle(
                          color: ColorPage.textColor,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: ColorPage.primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey.shade600,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: ColorPage.inputFillColor,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: ColorPage.textColor,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                        ),
                      ),

                      const SizedBox(height: 16.0),
                      // Row(
                      //   children: [
                      //     Checkbox(
                      //       value: _rememberMe,
                      //       activeColor: ColorPage.accentColor,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _rememberMe = value ?? false;
                      //         });
                      //       },
                      //     ),
                      //     const Text(
                      //       "Remember me",
                      //       style: TextStyle(
                      //         color: ColorPage.textColor,
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      // const Spacer(),
                      // TextButton(
                      //   onPressed: () {
                      //     // Handle forgot password
                      //   },
                      //   style: TextButton.styleFrom(
                      //     padding: EdgeInsets.zero,
                      //     minimumSize: const Size(0, 30),
                      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      //   ),
                      //   child: const Text(
                      //     'Forgot Password?',
                      //     style: TextStyle(
                      //       color: ColorPage.accentColor,
                      //       fontWeight: FontWeight.w500,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      //   ],
                      // ),

                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _validateAndLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPage.lightYellowGold1,
                            foregroundColor: ColorPage.textColor,
                            elevation: 2,
                            shadowColor: ColorPage.accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Or sign in with",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _socialLoginButton(
                                  icon: Icons.g_mobiledata_rounded,
                                  color: Colors.red.shade400,
                                ),
                                // const SizedBox(width: 20),
                                // _socialLoginButton(
                                //   icon: Icons.facebook,
                                //   color: Colors.blue.shade700,
                                // ),
                                // const SizedBox(width: 20),
                                // _socialLoginButton(
                                //   icon: Icons.apple,
                                //   color: Colors.black87,
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30.0),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (e) => const SignUp()));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: ColorPage.accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialLoginButton({required IconData icon, required Color color}) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }
}
