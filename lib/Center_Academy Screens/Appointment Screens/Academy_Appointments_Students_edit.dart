// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:auc_project/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:auc_project/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Academy_Appointments_Students_edit extends StatefulWidget {
  final Appointment appointment;
  const Academy_Appointments_Students_edit(
      {super.key, required this.appointment});

  @override
  _Academy_Appointments_Students_editState createState() =>
      _Academy_Appointments_Students_editState();
}

class _Academy_Appointments_Students_editState
    extends State<Academy_Appointments_Students_edit> {
  List<StudentItem> studentItems = [];
  List<Student> Students_list = [];
  Future<void> Get_Appointment_Available_Students(int ID) async {
    try {
      setState(() {
        Students_list.clear();
        studentItems.clear();
      });
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Students_For_Attendance/${widget.appointment.Grade}/${widget.appointment.Material}"),
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
          List<Student> Students_data =
              jsonList.map((json) => Student.fromMap(json)).toList();
          setState(() {
            Students_list = Students_data;
          });
          if (Students_list.isEmpty) {
            error_show("Nothing", context);
          }
          print_developer(Students_list.length);
          studentItems.addAll(
            Students_list.map((item) => StudentItem(student: item)).toList(),
          );
        }
      } else {
        print_developer('Error: ${response.statusCode} - ${response.body}');
        error_show(response.body, context);
      }
    } catch (e) {
      print_developer("Failed to load data $e");
      error_show("Failed to load data $e", context);
      // ignore: empty_catches
    }
  }

  Future<bool> send_Appointment_Students() async {
    print_developer("start_upload");
    List<Map<String, dynamic>> selected_Students_list = studentItems
        .where((x) => x.isSelected)
        .toList()
        .map((x) => x.student)
        .toList()
        .map((x) => Student_Appointment(Name: x.Name, ID: x.ID!))
        .toList()
        .map((x) => x.toJson())
        .toList();
    print_developer(selected_Students_list.length);
    try {
      supabase.realtime.disconnect();
      print_developer(jsonEncode(selected_Students_list));
      final response = await http.post(
        Uri.parse(
            "${Api_Url}Student_Management/Upload_Appointment_Students/${widget.appointment.ID}"),
        body: jsonEncode(selected_Students_list),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        print_developer('Data: ${response.body}');
        error_show("Students Uploaded successfully", context);
        return true;
      } else {
        print_developer('Error: ${response.statusCode} - ${response.body}');
        error_show(response.body, context);
        return false;
      }
    } catch (e) {
      print_developer(e);
      error_show(e.toString(), context);
      return false;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Appointment_Available_Students(widget.appointment.ID);
    });
    super.initState();
  }

  TextStyle textStyle_white = const TextStyle(color: Colors.white);

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get_Appointment_Available_Students(widget.appointment.ID);
          if (!mounted) {
            return;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(height: top_gap + top_gap_extra),
                  Expanded(
                    child: ListView.builder(
                      itemCount: studentItems.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(
                            Students_list[index].Name,
                            style: TextStyle(
                                color: Color.fromARGB(255, 218, 107, 50),
                                fontWeight: FontWeight.bold),
                          ),
                          value: studentItems[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              studentItems[index].isSelected = value!;
                            });
                          },
                          checkColor: Colors.transparent,
                          activeColor: Color.fromARGB(
                              255, 218, 107, 50), // Fill color when checked
                          side: BorderSide(
                              color: Color.fromARGB(255, 218, 107, 50),
                              width: 2.0), // Border color when unchecked
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5), // Optional: if you want rounded corners
                          ),
                        );
                      },
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 100.0,
                      end: _isLoading ? 40.0 : 100.0,
                    ),
                    duration: Duration(milliseconds: 300),
                    builder: (context, width, child) {
                      return ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (await send_Appointment_Students()) {
                                  setState(() {
                                    for (var element in studentItems) {
                                      element.isSelected = false;
                                    }
                                    _isLoading = false;
                                    Navigator.pop(context);
                                  });
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(width, 40),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          disabledBackgroundColor:
                              const Color.fromARGB(255, 255, 102, 0),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 102, 0),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
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

class StudentItem {
  Student student;
  bool isSelected;

  StudentItem({required this.student, this.isSelected = false});
}
