// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:auc_project/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:auc_project/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Academy_Attendance_Students_upload extends StatefulWidget {
  final Appointment appointment;
  final AppointmentAttendance Attendance;
  const Academy_Attendance_Students_upload(
      {super.key, required this.appointment, required this.Attendance});

  @override
  _Academy_Attendance_Students_uploadState createState() =>
      _Academy_Attendance_Students_uploadState();
}

class _Academy_Attendance_Students_uploadState
    extends State<Academy_Attendance_Students_upload> {
  List<Student_MapItem> studentItems = [];
  List<Student_Appointment> Students_list = [];
  Future<void> Get_Appointment_Students(int ID) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Appointment_Students/${widget.appointment.ID}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (!mounted) {
        return;
      }
      if (response.statusCode == 200) {
        setState(() {
          Students_list.clear();
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
          List<Student_Appointment> Students_data = jsonList
              .map((json) => Student_Appointment.fromMap(json))
              .toList();
          setState(() {
            Students_list = Students_data;
          });
          if (Students_list.isEmpty) {
            error_show("Nothing", context);
          }
          print_developer(Students_list.length);
          studentItems.addAll(
            Students_list.map((item) => Student_MapItem(student: item))
                .toList(),
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

  Future<bool> send_Attendance_Students() async {
    print_developer("start_upload");
    List<Map<String, dynamic>> selected_Students_list = studentItems
        .where((x) => x.isSelected)
        .toList()
        .map((x) => Student_Appointment(Name: x.student.Name, ID: x.student.ID))
        .toList()
        .map((x) => x.toJson())
        .toList();
    print_developer(selected_Students_list.length);
    try {
      supabase.realtime.disconnect();
      print_developer(jsonEncode(selected_Students_list));
      final response = await http.post(
        Uri.parse(
            "${Api_Url}Student_Management/Upload_Attendance_Students/${widget.Attendance.ID}"),
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
      error_show("Failed", context);
      return false;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Appointment_Students(widget.appointment.ID);
    });
    super.initState();
  }

  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get_Appointment_Students(widget.appointment.ID);
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
                                if (await send_Attendance_Students()) {
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
                            : const Text("Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
              // Positioned(
              //   bottom: 40,
              //   right: 16,
              //   child: FloatingActionButton(
              //     heroTag: null,
              //     onPressed: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => Academy_Attendance_upload(
              //             Appointment_ID: widget.appointment.ID,
              //           ),
              //         ),
              //       );
              //     },
              //     child: Icon(Icons.add),
              //   ),
              // ),
              // Positioned(
              //   bottom: 40,
              //   left: 16,
              //   child: FloatingActionButton(
              //     heroTag: null,
              //     onPressed: () {
              //       // Navigate to the screen where you add more items
              //       // Navigator.push(
              //       //   context,
              //       //   PageTransition(
              //       //     type: PageTransitionType.rightToLeftPop,
              //       //     duration: const Duration(milliseconds: 500),
              //       //     child: const Academy_Appointment_upload(),
              //       //     childCurrent: widget,
              //       //   ),
              //       // );
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => Academy_Appointment_upload(),
              //         ),
              //       );
              //     },
              //     child: Icon(Icons.edit),
              //   ),
              // ),
              Back_Button(),
              Logo(),
            ],
          ),
        ),
      ),
    );
  }
}

class Student_MapItem {
  Student_Appointment student;
  bool isSelected;

  Student_MapItem({required this.student, this.isSelected = false});
}
