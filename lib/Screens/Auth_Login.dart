// ignore_for_file: file_names, non_constant_identifier_names, depend_on_referenced_packages, use_build_context_synchronously, duplicate_ignore

import 'package:Academy_Management/Center_Academy%20Screens/Academy_Dashboard.dart';
import 'package:Academy_Management/main.dart';
import '../Client Screens/Student_Dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> Sign_out() async {
  await Supabase.instance.client.auth.signOut();
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String Login_state = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  bool _isLoading = false;

  ///sign in method
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      if (kDebugMode) {
        print_developer(email);
      }
      final String password = _passwordController.text;
      if (kDebugMode) {
        print_developer(password);
      }
      if (email.isEmpty || password.isEmpty) {
        setState(() {
          Login_state = "Please enter a valid Email and password";
        });
      }
      AuthResponse credential =
          await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        setState(() {
          Login_state = "User logged in: ${credential.user!.email}";
        });
        if (kDebugMode) {
          print_developer('User logged in: ${credential.user!.email}');
        }
        // Login successful
      } else if (credential.user == null) {
        setState(() {
          Login_state = "Login failed";
        });
        if (kDebugMode) {
          print_developer('Login failed');
        }
      }
      Navigator.pop(context);
      if (supabase.auth.currentUser!.userMetadata!.containsValue("Student")) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Student_Dashboard()),
        // );
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTopPop,
            child: Student_Dashboard(
              ID: supabase.auth.currentUser!.userMetadata!["ID"],
            ),
            childCurrent: widget,
          ),
        );
      } else if (supabase.auth.currentUser!.email!.contains("academy")) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Student_Dashboard()),
        // );
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTopPop,
            child: const Academy_Dashboard(),
            childCurrent: widget,
          ),
        );
      }
    } catch (e) {
      if (e == 'user-not-found') {
        setState(() {
          Login_state = "No user found for that email.";
        });
        if (kDebugMode) {
          print_developer('No user found for that email.');
        }
      } else if (e == 'wrong-password') {
        setState(() {
          Login_state = "Wrong password provided for that user.";
        });
        if (kDebugMode) {
          print_developer('Wrong password provided for that user.');
        }
      } else {
        setState(() {
          Login_state = "Login failed";
        });
        if (kDebugMode) {
          print_developer('Wrong password provided for that user.$e');
        }
      }
    }
  }

  void openWhatsApp({required String phoneNumber}) async {
    final url = 'https://wa.me/$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage('assets/bg.png'),
            //   fit: BoxFit.cover,
            // ),
            ),
        // color: const Color.fromARGB(255, 2, 35, 83),
        alignment: Alignment.center,
        child: Stack(children: [
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     width: 75, // Adjust the width as needed
          //     height: 75, // Adjust the height as needed
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(
          //             15), // Half of the width/height to make it fully round
          //         bottomRight: Radius.circular(15),
          //       ),
          //     ),
          //   ),
          // ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Image.asset(
          //     'assets/AUC Logo.png',
          //     width: 75, // Set the width of the image
          //     height: 75, // Set the height of the image
          //   ),
          // ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 102, 0),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 60,
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 47, 255),
                      fontSize: 20,
                    ),
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 53, 90),
                        fontSize: 16,
                      ),
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      fillColor: const Color.fromARGB(60, 147, 147, 147),
                      filled: true,
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 53, 90)),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 47, 255),
                            fontSize: 20),
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 53, 90),
                            fontSize: 16,
                          ),
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          fillColor: const Color.fromARGB(60, 147, 147, 147),
                          filled: true,
                          labelStyle: const TextStyle(
                              color: Color.fromARGB(255, 0, 53, 90)),
                          alignLabelWithHint: true,
                        ),
                        obscureText: _isObscure,
                      ),
                      Positioned(
                        right: 0, // Position the icon at the right edge
                        child: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 200.0, // Initial width of the button
                    end: _isLoading
                        ? 40.0
                        : 200.0, // Shrink to fit CircularProgressIndicator with padding
                  ),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, width, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width, 40),
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        disabledBackgroundColor:
                            const Color.fromARGB(255, 255, 102, 0),
                        backgroundColor: const Color.fromARGB(255, 255, 102, 0),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await _signInWithEmailAndPassword();
                              setState(() {
                                _isLoading = false;
                              });
                            },
                      child: _isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(
                                  8.0), // Padding around the CircularProgressIndicator
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            )
                          : const Text(
                              'Sign in',
                              softWrap: false,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(150, 40),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 147, 147, 147),
                        width: 2), // Border color and width
                  ),
                  onPressed: () {
                    openWhatsApp(phoneNumber: '+201000000000');
                  },
                  child: const Text(
                    'Contact Us',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(Login_state)],
                ),
                // const SizedBox(height: 20),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
