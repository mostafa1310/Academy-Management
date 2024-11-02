// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api
import 'package:Academy_Management/Center_Academy%20Screens/Academy_Teacher_upload.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Screens/Auth_Login.dart';
import 'package:Academy_Management/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Appointment Screens/Academy_Appointments.dart';
import 'Academy_student_upload.dart';

int currentPageIndex = 0;

class Academy_Dashboard extends StatefulWidget {
  const Academy_Dashboard({super.key});

  @override
  _Academy_DashboardState createState() => _Academy_DashboardState();
}

class _Academy_DashboardState extends State<Academy_Dashboard> {
  late List<NavigationDestination> NavigationDestinationsItems =
      <NavigationDestination>[
    NavigationDestination(
      icon: Icon(
        Icons.upload,
        color: Color.fromARGB(255, 0, 52, 90),
      ),
      label: 'Add Student',
    ),
    NavigationDestination(
      icon: Icon(
        Icons.person,
        color: Color.fromARGB(255, 0, 52, 90),
      ),
      label: 'Appointments',
    ),
    NavigationDestination(
      icon: Icon(
        Icons.upload,
        color: Color.fromARGB(255, 0, 52, 90),
      ),
      label: 'Add Teacher',
    ),
  ];
  var Pages = <Widget>[];
  @override
  void initState() {
    currentPageIndex = 0;
    Pages = <Widget>[
      /// Home page
      Academy_student_upload(),

      Academy_Appointments(),
      Academy_Teacher_upload(),
    ];
    super.initState();
  }

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.topCenter,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Stack(children: [
          Pages[currentPageIndex],
          Logo(),
        ]),
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((Set<MaterialState> states) =>states.contains(())),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? const TextStyle(color: Colors.black)
                : const TextStyle(color: Colors.black),
          ),
        ),
        child: NavigationBar(
          height: 75,
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 300),
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
            if (currentPageIndex != 1) {
              supabase.channel('schema-db-changes').unsubscribe();
            }
          },
          indicatorColor: const Color.fromARGB(255, 160, 159, 159),
          selectedIndex: currentPageIndex,
          destinations: NavigationDestinationsItems,
        ),
      ),
    );
  }

  Padding Settings(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            Navigator.pop(context);
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTopPop,
                duration: const Duration(seconds: 2),
                child: const LoginPage(),
                childCurrent: widget,
              ),
            );
          },
          child: const Text('Sign Out'),
        ));
  }
}

class MaterialItem {
  String name;
  bool isSelected;

  MaterialItem({required this.name, this.isSelected = false});
}
