// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:auc_project/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_Students_upload.dart';
import 'package:auc_project/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_upload.dart';
import 'package:auc_project/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:auc_project/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Teacher_Appointment_Quizzes extends StatefulWidget {
  final Appointment appointment;
  const Teacher_Appointment_Quizzes({super.key, required this.appointment});

  @override
  _Teacher_Appointment_QuizzesState createState() =>
      _Teacher_Appointment_QuizzesState();
}

class _Teacher_Appointment_QuizzesState
    extends State<Teacher_Appointment_Quizzes> {
  List<Quiz> Quizzes_list = [];
  Future<void> Get_Appointment_Quizzes() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Appointment_Quizzes/${widget.appointment.ID}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        setState(() {
          Quizzes_list.clear();
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
          List<Quiz> Attendance_data =
              jsonList.map((json) => Quiz.fromMap(json)).toList();
          setState(() {
            Quizzes_list = Attendance_data;
          });
          if (Quizzes_list.isEmpty) {
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
      Get_Appointment_Quizzes();
    });
    super.initState();
  }

  TextStyle textStyle_white = const TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.topCenter,
      body: RefreshIndicator(
        onRefresh: () async {
          await Get_Appointment_Quizzes();
          if (!mounted) {
            return;
          }
        },
        child: Container(
          color: const Color.fromARGB(255, 2, 35, 83),
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: Quizzes_list.length,
                      itemBuilder: (context, index) {
                        return Quiz_widget(
                          index: index,
                          appointment: widget.appointment,
                          Quizzes: Quizzes_list,
                          textStyle_white: textStyle_white,
                        );
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 40,
                right: 16,
                child: FloatingActionButton(
                  heroTag: null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Ensures it's perfectly round
                  ),
                  onPressed: () {
                    // Navigate to the screen where you add more items
                    // Navigator.push(
                    //   context,
                    //   PageTransition(
                    //     type: PageTransitionType.rightToLeftPop,
                    //     duration: const Duration(milliseconds: 500),
                    //     child: const Academy_Appointment_upload(),
                    //     childCurrent: widget,
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Academy_Quiz_upload(
                          Appointment_ID: widget.appointment.ID,
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.add),
                ),
              ),
              Back_Button(),
              Logo(),
            ],
          ),
        ),
      ),
    );
  }
}

class Quiz_widget extends StatelessWidget {
  const Quiz_widget({
    super.key,
    required this.Quizzes,
    required this.textStyle_white,
    required this.index,
    required this.appointment,
  });

  final List<Quiz> Quizzes;
  final Appointment appointment;
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
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.white, width: 2))),
      child: ListTile(
        onTap: () {
          // Navigate to player details
          // supabase.realtime.disconnect();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Academy_Quiz_Students_upload(
                appointment: appointment,
                quiz: Quizzes[index],
              ),
            ),
          );
        },
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        title: Text(
          Quizzes[index].Name,
          style: textStyle_white,
          softWrap: false, // Adjust the font size as needed
        ),
        // subtitle: Text(
        //   "${Quizzes[index].created_at!.year}/${Quizzes[index].created_at!.month}/${Quizzes[index].created_at!.day}",
        //   style: textStyle_white, // Adjust the font size as needed
        // ),
        trailing: Text(
          "${Quizzes[index].created_at!.year}/${Quizzes[index].created_at!.month}/${Quizzes[index].created_at!.day}",
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
