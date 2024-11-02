// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_Students_upload.dart';
import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_upload.dart';
import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Academy_Appointment_Quizzes extends StatefulWidget {
  final Appointment appointment;
  const Academy_Appointment_Quizzes({super.key, required this.appointment});

  @override
  _Academy_Appointment_QuizzesState createState() =>
      _Academy_Appointment_QuizzesState();
}

class _Academy_Appointment_QuizzesState
    extends State<Academy_Appointment_Quizzes> {
  List<Quiz> Quizzes_list = [];
  Future<void> Get_Appointment_Quizzes() async {
    try {
      setState(() {
        Quizzes_list.clear();
      });
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Appointment_Quizzes/${widget.appointment.ID}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (!mounted) {
        return;
      }
      if (response.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top_gap + top_gap_extra),
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Get_Appointment_Quizzes();
              if (!mounted) {
                return;
              }
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: Quizzes_list.length,
                    itemBuilder: (context, index) {
                      return Quiz_widget(
                        index: index,
                        appointment: widget.appointment,
                        Quizzes: Quizzes_list,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 16,
            child: FloatingActionButton(
              heroTag: null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () {
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
        ],
      ),
    );
  }
}

class Quiz_widget extends StatelessWidget {
  const Quiz_widget({
    super.key,
    required this.Quizzes,
    required this.index,
    required this.appointment,
  });

  final List<Quiz> Quizzes;
  final Appointment appointment;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(width: 2, color: Colors.blue.shade900),
        ),
      ),
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
          style: TextStyle(color: Colors.white),
          softWrap: false, // Adjust the font size as needed
        ),
        // subtitle: Text(
        //   "${Quizzes[index].created_at!.year}/${Quizzes[index].created_at!.month}/${Quizzes[index].created_at!.day}",
        //   style: textStyle_white, // Adjust the font size as needed
        // ),
        trailing: Text(
          "${Quizzes[index].created_at!.year}/${Quizzes[index].created_at!.month}/${Quizzes[index].created_at!.day}",
          style:
              TextStyle(color: Colors.white), // Adjust the font size as needed
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
