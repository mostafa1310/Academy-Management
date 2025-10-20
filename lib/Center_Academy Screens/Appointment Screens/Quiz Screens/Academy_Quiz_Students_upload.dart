// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_data.dart';
import '../../../mock/mock_service.dart';

int currentPageIndex = 0;

class Academy_Quiz_Students_upload extends StatefulWidget {
  final Appointment appointment;
  final Quiz quiz;
  const Academy_Quiz_Students_upload(
      {super.key, required this.appointment, required this.quiz});

  @override
  _Academy_Quiz_Students_uploadState createState() =>
      _Academy_Quiz_Students_uploadState();
}

class _Academy_Quiz_Students_uploadState
    extends State<Academy_Quiz_Students_upload> {
  List<Student_MapItem> studentItems = [];
  List<Student_Appointment> Students_list = [];
  final _formKey = GlobalKey<FormState>();
  Future<void> Get_Appointment_Students(int ID) async {
    try {
      setState(() {
        Students_list.clear();
        studentItems.clear();
      });

      final mockDB = MockDatabaseService();
      final students = await mockDB.getStudents();

      // Get students from this appointment
      final appointmentStudents = students.map((student) {
        return Student_Appointment(
          ID: student['ID'],
          Name: student['name'],
        );
      }).toList();

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

  Future<bool> send_Quiz_Students() async {
    try {
      debugPrint("Updating quiz students");

      // Get the quiz to update
      final mockDB = MockDatabaseService();
      final quizzes = await mockDB.getQuizzes();
      final quizIndex = quizzes.indexWhere((q) => q['ID'] == widget.quiz.ID);

      if (quizIndex == -1) {
        error_show("Quiz not found", context);
        return false;
      }

      // Update the quiz with new student marks
      final students = studentItems
          .map((item) => {
                'student_id': item.student.ID,
                'name': item.student.Name,
                'mark': item.Mark,
              })
          .toList();

      MockData.quizzes[quizIndex]['students'] = students;

      error_show("Quiz marks updated successfully", context);
      return true;
    } catch (e) {
      debugPrint("Failed to update quiz marks: $e");
      error_show("Failed to update quiz marks", context);
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

  bool _isLoading = false;

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
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: top_gap + top_gap_extra,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: studentItems.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 75,
                            child: ListTile(
                              title: Text(
                                studentItems[index].student.Name,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 218, 107, 50),
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: SizedBox(
                                width: 125,
                                height: 75,
                                child: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        studentItems[index].Mark =
                                            double.tryParse(value) ?? 0.0;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Mark',
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 30, 54, 78),
                                    ),
                                    filled: true,
                                    fillColor:
                                        const Color.fromARGB(60, 147, 147, 147),
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    alignLabelWithHint: true,
                                    // contentPadding: EdgeInsets.symmetric(
                                    //   vertical:
                                    //       20.0, // Increase this to make the TextField taller
                                    //   horizontal: 10.0,
                                    // ),
                                  ),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 30, 54, 78),
                                      fontSize: 20),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Enter the Mark";
                                    }
                                    if (studentItems[index].Mark <=
                                        widget.quiz.Max_mark) {
                                      return null;
                                    } else {
                                      return "Over Max Mark";
                                    }
                                  },
                                ),
                              ),
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
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    if (await send_Quiz_Students()) {
                                      setState(() {
                                        for (var element in studentItems) {
                                          element.Mark = 0;
                                        }
                                        _isLoading = false;
                                        Navigator.pop(context);
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
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
                              : const Text(
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
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
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

class Student_MapItem {
  Student_Appointment student;
  double Mark;

  Student_MapItem({required this.student, this.Mark = 0});
}
