// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_service.dart';
import '../../../mock/mock_data.dart';
import '../../../Widget/back_button.dart';

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
      setState(() {
        Students_list.clear();
        studentItems.clear();
      });

      final mockDB = MockDatabaseService();
      final students = await mockDB.getStudents();

      // Convert students to Student_Appointment format
      final appointmentStudents = students
          .map((student) => Student_Appointment(
                ID: student['ID'],
                Name: student['name'],
              ))
          .toList();

      if (!mounted) return;

      if (appointmentStudents.isEmpty) {
        error_show("No students found", context);
        return;
      }

      setState(() {
        Students_list = appointmentStudents;
        studentItems.addAll(
          Students_list.map((item) => Student_MapItem(student: item)).toList(),
        );
      });
    } catch (e) {
      debugPrint("Failed to load student data: $e");
      if (mounted) {
        error_show("Failed to load student data", context);
      }
    }
  }

  Future<bool> send_Attendance_Students() async {
    try {
      // Get selected students
      final selectedStudents = studentItems
          .where((x) => x.isSelected)
          .map((x) => {
                'student_id': x.student.ID,
                'name': x.student.Name,
              })
          .toList();

      // Get the attendance record to update
      final mockDB = MockDatabaseService();
      final attendance = await mockDB.getAttendance();
      final attendanceIndex =
          attendance.indexWhere((a) => a['ID'] == widget.Attendance.ID);

      if (attendanceIndex == -1) {
        error_show("Attendance record not found", context);
        return false;
      }

      // Update the attendance record with selected students
      MockData.attendance[attendanceIndex]['students'] = selectedStudents;

      error_show("Students attendance updated successfully", context);
      return true;
    } catch (e) {
      debugPrint("Failed to update attendance: $e");
      error_show("Failed to update attendance", context);
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
              const Back_Button(),
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
