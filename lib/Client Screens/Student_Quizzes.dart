// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Student_Quizzes extends StatefulWidget {
  final Student student;
  final String selected_Material;
  const Student_Quizzes(
      {super.key, required this.student, required this.selected_Material});

  @override
  _Student_QuizzesState createState() => _Student_QuizzesState();
}

class _Student_QuizzesState extends State<Student_Quizzes> {
  List<StudentQuizRecord> StudentRecords_list = [];
  Future<void> Get_Student_Quizzes() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Student_Quizzes/${widget.student.ID}/${widget.selected_Material.trim()}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      setState(() {
        StudentRecords_list.clear();
      });
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
          List<StudentQuizRecord> StudentRecords_data =
              jsonList.map((json) => StudentQuizRecord.fromMap(json)).toList();
          setState(() {
            StudentRecords_list = StudentRecords_data;
          });
          if (StudentRecords_list.isEmpty) {
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
      Get_Student_Quizzes();
    });
    super.initState();
  }

  TextStyle textStyle_white =
      const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await Get_Student_Quizzes();
            if (!mounted) {
              return;
            }
          },
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Stack(
                  children: [
                    Positioned(
                      top: 20, // Adjust the top margin
                      left: 20, // Adjust the left margin
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Align(
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
                        ), // Adjust the top margin
                        // child: Image.asset(
                        //   'assets/AUC Logo.png',
                        //   width: 75,
                        //   height: 75,
                        // ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: StudentRecords_list.length,
                    itemBuilder: (context, index) {
                      return CustomMarkListTile(
                        title: StudentRecords_list[index].quizName,
                        created_at: StudentRecords_list[index].createdAt,
                        mark: StudentRecords_list[index].mark,
                        max_mark: StudentRecords_list[index].maxMark,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomMarkListTile extends StatelessWidget {
  final String title;
  final DateTime created_at;
  final double? mark;
  final double max_mark;

  const CustomMarkListTile({
    super.key,
    required this.title,
    required this.mark,
    required this.created_at,
    required this.max_mark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(60, 147, 147, 147),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        title: Text(
          title,
          style: TextStyle(color: Colors.black, fontSize: 16),
          softWrap: false, // Adjust the font size as needed
        ),
        subtitle: Text(
          "${created_at.year}/${created_at.month}/${created_at.day}",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16), // Adjust the font size as needed
        ),
        trailing: Text(
          "$mark/$max_mark",
          style: TextStyle(
              color: Colors.black,
              fontSize: 16), // Adjust the font size as needed
        ),
      ),
    );
  }
}
