// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Teacher%20Screens/Teacher_Appointment_Quizzes.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Screens/Auth_Login.dart';
import 'package:Academy_Management/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Teacher_Dashboard extends StatefulWidget {
  final int ID;
  const Teacher_Dashboard({super.key, required this.ID});

  @override
  _Teacher_DashboardState createState() => _Teacher_DashboardState();
}

class _Teacher_DashboardState extends State<Teacher_Dashboard> {
  final TextEditingController Student_name_field =
      TextEditingController(text: "");
  List<Appointment> Appointments_list = [];
  Future<void> Get_Teacher_Appointments() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Teacher_Appointments/${widget.ID}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        setState(() {
          Appointments_list.clear();
        });
        print_developer("decode data");
        var jsonList = jsonDecode(response.body);

        if (jsonList is List) {
          if (jsonList.isEmpty) {
            error_show("Nothing", context);
            return;
          }
          print_developer("parse data $jsonList");
          print_developer(jsonList.firstOrNull);
          List<Appointment> Appointments_data =
              jsonList.map((json) => Appointment.fromMap(json)).toList();
          setState(() {
            Appointments_list = Appointments_data;
          });
          if (Appointments_list.isEmpty) {
            error_show("Nothing", context);
          }
        }
      } else {
        print_developer('Error: ${response.statusCode} - ${response.body}');
        error_show(response.body, context);
      }
    } catch (e) {
      print_developer("Failed to load data $e");
      error_show("Failed to load data", context);
      // ignore: empty_catches
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Teacher_Appointments();
    });
    super.initState();
  }

  TextStyle textStyle_blue =
      const TextStyle(color: Color.fromARGB(255, 0, 53, 90), fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await Get_Teacher_Appointments();
            if (!mounted) {
              return;
            }
          },
          child: Container(
            padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
            color: Colors.white,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to',
                  textAlign: TextAlign.center,
                  softWrap: false,
                  style: TextStyle(
                      fontSize: 28, color: Color.fromARGB(255, 0, 53, 90)),
                ),
                Text(
                  'AUC App',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 53, 90),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: Appointments_list.length,
                    itemBuilder: (context, index) {
                      return Appointment_widget(
                        index: index,
                        Appointments: Appointments_list,
                        textStyle_white: textStyle_blue,
                      );
                    },
                  ),
                ),
                // Positioned(
                //   bottom: 59,
                //   right: 16,
                //   child: FloatingActionButton(
                //     heroTag: null,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(
                //           50), // Ensures it's perfectly round
                //     ),
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => Academy_Appointment_upload(),
                //         ),
                //       );
                //     },
                //     child: Icon(Icons.add),
                //   ),
                // ),
                Settings(context),
              ],
            ),
          ),
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

class Appointment_widget extends StatelessWidget {
  const Appointment_widget({
    super.key,
    required this.Appointments,
    required this.textStyle_white,
    required this.index,
  });

  final List<Appointment> Appointments;
  final TextStyle textStyle_white;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(
                  color: Color.fromARGB(255, 0, 53, 90), width: 2))),
      child: ListTile(
        onTap: () {
          // Navigate to player details
          // supabase.realtime.disconnect();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Teacher_Appointment_Quizzes(
                appointment: Appointments[index],
              ),
            ),
          );
        },
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        title: Text(
          "${Appointments[index].date.First_Day}:${Appointments[index].date.Second_Day}",
          style: textStyle_white,
          softWrap: false, // Adjust the font size as needed
        ),
        // subtitle: Text(
        //   "${Appointments[index].date.Hour_From}:${Appointments[index].date.Hour_To} ${Appointments[index].date.Hour_Mode}",
        //   style: textStyle_white, // Adjust the font size as needed
        // ),
        trailing: Text(
          "${Appointments[index].date.Hour_From}:${Appointments[index].date.Hour_To} ${Appointments[index].date.Hour_Mode}",
          style: textStyle_white, // Adjust the font size as needed
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
