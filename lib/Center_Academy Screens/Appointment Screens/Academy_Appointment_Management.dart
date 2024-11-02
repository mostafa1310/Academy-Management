// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api
import 'package:auc_project/Center_Academy%20Screens/Appointment%20Screens/Attendance%20Screens/Academy_Appointment_Attendance.dart';
import 'package:auc_project/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Appointment_Quizzes.dart';
import 'package:auc_project/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:auc_project/main.dart';

int currentPageIndex = 0;

class Academy_Appointment_Management extends StatefulWidget {
  final Appointment appointment;
  const Academy_Appointment_Management({super.key, required this.appointment});

  @override
  _Academy_Appointment_ManagementState createState() =>
      _Academy_Appointment_ManagementState();
}

class _Academy_Appointment_ManagementState
    extends State<Academy_Appointment_Management> {
  late List<NavigationDestination> NavigationDestinationsItems =
      <NavigationDestination>[
    NavigationDestination(
      icon: Icon(
        Icons.person,
        color: Color.fromARGB(255, 0, 52, 90),
      ),
      label: 'Attendance',
    ),
    NavigationDestination(
      icon: Icon(
        Icons.quiz,
        color: Color.fromARGB(255, 0, 52, 90),
      ),
      label: 'Quizzes Marks',
    ),
  ];
  var Pages = <Widget>[];
  @override
  void initState() {
    currentPageIndex = 0;
    Pages = <Widget>[
      /// Home page
      Academy_Appointment_Attendance(
        appointment: widget.appointment,
      ),
      Academy_Appointment_Quizzes(
        appointment: widget.appointment,
      ),
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
          Back_Button(),
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
}

class MaterialItem {
  String name;
  bool isSelected;

  MaterialItem({required this.name, this.isSelected = false});
}
