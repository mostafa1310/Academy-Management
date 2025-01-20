// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';

import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';
import 'package:http/http.dart' as http;

class Student_Attendances extends StatefulWidget {
  final Student student;
  final String selected_Material;
  const Student_Attendances(
      {super.key, required this.student, required this.selected_Material});

  @override
  _Student_AttendancesState createState() => _Student_AttendancesState();
}

class _Student_AttendancesState extends State<Student_Attendances> {
  List<StudentAttendanceRecord> StudentRecords_list = [];

  Future<void> Get_Student_Attendances() async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Student_Attendances/${widget.student.ID}/${widget.selected_Material.trim()}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      setState(() {
        StudentRecords_list.clear();
      });
      if (response.statusCode == 200) {
        var jsonList = jsonDecode(response.body);

        if (jsonList is List) {
          if (jsonList.isEmpty) {
            error_show("Nothing", context);
            return;
          }

          List<StudentAttendanceRecord> StudentRecords_data = jsonList
              .map((json) => StudentAttendanceRecord.fromMap(json))
              .toList();
          setState(() {
            StudentRecords_list = StudentRecords_data;
          });
          if (StudentRecords_list.isEmpty) {
            error_show("Nothing", context);
          }
        }
      } else {
        error_show(response.body, context);
      }
    } catch (e) {
      print_developer(e);
      error_show("Failed to load data", context);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Student_Attendances();
    });
    super.initState();
  }

  TextStyle textStyle_white =
      const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get_Student_Attendances();
          if (!mounted) {
            return;
          }
        },
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Back button and logo
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
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
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
              const SizedBox(height: 20), // Space between the logo and list
              // List of attendance records
              Expanded(
                child: ListView.builder(
                  itemCount: StudentRecords_list.length,
                  itemBuilder: (context, index) {
                    return CustomCheckboxListTile(
                      title: StudentRecords_list[index].Attendance_name,
                      created_at: StudentRecords_list[index].created_at,
                      Attend: StudentRecords_list[index].Attend,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  final String title;
  final DateTime created_at;
  final bool Attend;

  const CustomCheckboxListTile({
    super.key,
    required this.title,
    required this.Attend,
    required this.created_at,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color.fromARGB(60, 147, 147, 147),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Attend
            ? const Icon(
                Icons.check,
                color: Colors.green,
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "A",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        title: Text(title,
            style: const TextStyle(color: Colors.black, fontSize: 16)),
        subtitle: Text(
          "${created_at.year}/${created_at.month}/${created_at.day}",
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        tileColor: Attend ? Colors.white : Colors.grey.shade200,
      ),
    );
  }
}
