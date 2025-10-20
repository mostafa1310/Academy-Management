// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_service.dart';
import '../../../mock/mock_data.dart';
import '../../../Widget/back_button.dart';

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

      // Get mock students
      final mockDB = MockDatabaseService();
      final students = await mockDB.getStudents();

      // Filter students by grade and material
      final filteredStudents = students.where((student) {
        final gradeMatch = student['grade'] == widget.appointment.Grade;
        final materials = (student['materials'] as List<dynamic>?)
            ?.map((m) => m.toString())
            .toList();
        final materialMatch = materials != null
            ? materials.contains(widget.appointment.Material)
            : false;
        return gradeMatch && materialMatch;
      }).map((student) {
        // Map student's materials list to the Student model
        final materials = (student['materials'] as List<dynamic>?)
            ?.map((m) => m.toString())
            .toList();

        return Student(
          ID: student['ID'],
          Name: student['name'],
          Email: student['email'],
          Phone: student['phone'],
          Grade: student['grade'],
          Materials: materials ?? [],
        );
      }).toList();

      if (!mounted) return;

      if (filteredStudents.isEmpty) {
        error_show("No students found", context);
        return;
      }

      setState(() {
        Students_list = filteredStudents;
        studentItems.addAll(
          Students_list.map((item) => StudentItem(student: item)).toList(),
        );
      });
    } catch (e) {
      debugPrint("Failed to load students: $e");
      if (mounted) {
        error_show("Failed to load students", context);
      }
    }
  }

  Future<bool> send_Appointment_Students() async {
    try {
      // Get selected students
      final selectedStudents = studentItems
          .where((x) => x.isSelected)
          .map((x) => {
                'student_id': x.student.ID,
                'name': x.student.Name,
              })
          .toList();

      // Get the appointment to update
      final appointmentIndex = MockData.appointments
          .indexWhere((a) => a['ID'] == widget.appointment.ID);

      if (appointmentIndex == -1) {
        error_show("Appointment not found", context);
        return false;
      }

      // Update the appointment with selected students
      MockData.appointments[appointmentIndex]['students'] = selectedStudents;

      error_show("Students assigned successfully", context);
      return true;
    } catch (e) {
      debugPrint("Failed to assign students: $e");
      error_show("Failed to assign students", context);
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
