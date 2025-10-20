// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_Students_upload.dart';
import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_upload.dart';
import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';

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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock quiz data
      final mockQuizzes = [
        Quiz(
          ID: 1,
          Appointment_ID: widget.appointment.ID,
          Max_mark: 100,
          Name: "Quiz 1",
          created_at: DateTime.now().subtract(const Duration(days: 2)),
          Students: [
            Student_Quiz_mark(
              ID: 1001,
              Name: "John Doe",
              Mark: 85,
            ),
            Student_Quiz_mark(
              ID: 1002,
              Name: "Alice Johnson",
              Mark: 92,
            ),
          ],
        ),
        Quiz(
          ID: 2,
          Appointment_ID: widget.appointment.ID,
          Max_mark: 50,
          Name: "Pop Quiz",
          created_at: DateTime.now(),
          Students: [
            Student_Quiz_mark(
              ID: 1001,
              Name: "John Doe",
              Mark: 45,
            ),
            Student_Quiz_mark(
              ID: 1002,
              Name: "Alice Johnson",
              Mark: 48,
            ),
          ],
        ),
      ];

      setState(() {
        Quizzes_list = mockQuizzes;
      });
    } catch (e) {
      print_developer("Failed to load data $e");
      error_show("Failed to load data", context);
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
          color: Colors.white,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
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
