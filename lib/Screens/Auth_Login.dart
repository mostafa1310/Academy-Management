// ignore_for_file: file_names, non_constant_identifier_names

import 'package:Academy_Management/Center_Academy%20Screens/Academy_Dashboard.dart';
import 'package:Academy_Management/main.dart';
import '../Client Screens/Student_Dashboard.dart';
import '../Teacher Screens/Teacher_Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _isLoading = false;

  void _signInAsRole(BuildContext context, String role) async {
    setState(() {
      _isLoading = true;
    });

    String email;
    int userId;

    switch (role) {
      case 'Student':
        email = 'student@example.com';
        userId = 1001;
        break;
      case 'Teacher':
        email = 'teacher@example.com';
        userId = 2001;
        break;
      case 'Academy Admin':
        email = 'admin@academy.example.com';
        userId = 0;
        break;
      default:
        setState(() {
          _isLoading = false;
        });
        return;
    }

    try {
      await supabase.signInWithPassword(
        email: email,
        password: 'mockpass',
      );

      if (!context.mounted) return;

      Widget nextScreen;
      if (role == 'Student') {
        nextScreen = Student_Dashboard(ID: userId);
      } else if (role == 'Teacher') {
        nextScreen = Teacher_Dashboard(ID: userId);
      } else {
        nextScreen = const Academy_Dashboard();
      }

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTopPop,
          child: nextScreen,
          childCurrent: widget,
        ),
      );
    } catch (e) {
      print_developer('Login error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Choose Role',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 102, 0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildRoleButton(context, 'Student'),
            const SizedBox(height: 20),
            _buildRoleButton(context, 'Teacher'),
            const SizedBox(height: 20),
            _buildRoleButton(context, 'Academy Admin'),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(BuildContext context, String role) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: 200.0,
        end: _isLoading ? 40.0 : 200.0,
      ),
      duration: const Duration(milliseconds: 300),
      builder: (context, width, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(width, 50),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 102, 0),
          ),
          onPressed: _isLoading ? null : () => _signInAsRole(context, role),
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : Text(
                  role,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        );
      },
    );
  }
}
