// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'package:Academy_Management/Screens/Auth_Login.dart';
import 'package:Academy_Management/Teacher%20Screens/Teacher_Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import 'Center_Academy Screens/Academy_Dashboard.dart';
import 'Client Screens/Student_Dashboard.dart';
import 'mock/mock_service.dart';

const String name = 'my.Academy_Management.Academy_Management_APP';

void print_developer(Object value) {
  developer.log(value.toString(), name: name);
}

late MockSupabaseService supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize mock services
  supabase = MockSupabaseService();
  
  print_developer("Mock services initialized");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    if (supabase.currentUser == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginPage(),
      );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: app(),
      );
    }
  }
}

MaterialApp app() {
  supabase.refreshSession();
  final metadata = supabase.currentUser?.userMetadata;
  
  if (metadata != null) {
    if (metadata.containsValue("Student")) {
      print_developer(metadata);
      int id = metadata["ID"];
      return MaterialApp(
        title: 'Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Student_Dashboard(
          ID: id,
        ),
      );
    } else if (supabase.currentUser?.email?.contains("academy") ?? false) {
      return MaterialApp(
        title: 'Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const Academy_Dashboard(),
      );
    } else if (metadata.containsValue("Teacher")) {
      return MaterialApp(
        title: 'Home',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Cairo',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Teacher_Dashboard(ID: metadata["ID"]),
      );
    }
  }

  return MaterialApp(
    title: 'Home',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      fontFamily: 'Cairo',
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const Text("Not Available"),
  );
}

class Logo extends StatelessWidget {
  const Logo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(
                  15), // Half of the width/height to make it fully round
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Image.asset(
            'assets/Academy_Management Logo.png',
            width: 75, // Set the width of the image
            height: 75, // Set the height of the image
          ),
        ),
      ),
    );
  }
}

class Back_Button extends StatelessWidget {
  const Back_Button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10, // Adjust the top margin
      left: 10, // Adjust the left margin
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the button
          borderRadius: BorderRadius.circular(30), // Rounded border
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2), // Shadow position
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
    );
  }
}
