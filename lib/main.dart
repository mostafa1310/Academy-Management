// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:io';

import 'package:auc_project/Screens/Auth_Login.dart';
import 'package:auc_project/Teacher%20Screens/Teacher_Dashboard.dart';
import 'package:auc_project/config_prod.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'Center_Academy Screens/Academy_Dashboard.dart';
import 'Client Screens/Student_Dashboard.dart';
import 'firebase_options.dart';

const String name = 'my.AUC.AUC_APP';
const String Api_Url = Api_Url_var;

void print_developer(Object value) {
  developer.log(value.toString(), name: name);
}

late SupabaseClient supabase;
String supabaseUrl = "";
String supabaseKey = "";
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.fetchAndActivate();
  try {
    if (kIsWeb) {
      print_developer("is_web");
      print_developer(remoteConfig.getAll());
      supabaseKey = remoteConfig.getString("supabase_anonKey");
      supabaseUrl = remoteConfig.getString("supabase_url");
      print_developer(supabaseUrl);
      print_developer(supabaseKey);
    } else if (Platform.isAndroid || Platform.isIOS) {
      await dotenv.load(fileName: "keys.env");
      supabaseUrl = dotenv.env['supabaseUrl'] ?? '';
      supabaseKey = dotenv.env['supabaseKey'] ?? '';
      if (kDebugMode) {
        developer.log("it is a debug mode", name: name);
      } else {
        developer.log("it is a PhysicalDevice", name: name);
      }
    }

    if (supabaseKey.isNotEmpty && supabaseUrl.isNotEmpty) {
      print_developer("supabase initialize...");
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      supabase = Supabase.instance.client;
    }
    // ignore: empty_catches
  } catch (e) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    if (supabase.auth.currentUser == null) {
      return MaterialApp(
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
  supabase.auth.refreshSession();
  if (supabase.auth.currentUser!.userMetadata!.containsValue("Student")) {
    print_developer(supabase.auth.currentUser!.userMetadata!);
    int id = supabase.auth.currentUser!.userMetadata!["ID"];
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
  } else if (supabase.auth.currentUser!.email!.contains("academy")) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Academy_Dashboard(),
    );
  } else if (supabase.auth.currentUser!.userMetadata!
      .containsValue("Teacher")) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:
          Teacher_Dashboard(ID: supabase.auth.currentUser!.userMetadata!["ID"]),
    );
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
            'assets/AUC Logo.png',
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
