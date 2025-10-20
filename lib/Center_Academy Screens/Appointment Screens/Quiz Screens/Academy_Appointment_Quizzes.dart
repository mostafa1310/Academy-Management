// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_Students_upload.dart';
import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Quiz%20Screens/Academy_Quiz_upload.dart';
import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_service.dart';

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

      final mockDB = MockDatabaseService();
      final quizzes = await mockDB.getQuizzes();

      // Filter quizzes for this appointment
      final appointmentQuizzes = quizzes
          .where((quiz) => quiz['appointment_id'] == widget.appointment.ID)
          .toList();

      if (!mounted) return;

      if (appointmentQuizzes.isEmpty) {
        error_show("No quizzes found", context);
        return;
      }

      setState(() {
        Quizzes_list = appointmentQuizzes.map((quiz) {
          // parse created_at if present
          DateTime createdAt = DateTime.now();
          try {
            if (quiz['created_at'] != null) {
              createdAt = DateTime.parse(quiz['created_at'].toString());
            }
          } catch (_) {}

          return Quiz(
            ID: quiz['ID'],
            Name: quiz['name'] ?? quiz['title'] ?? 'Quiz',
            Appointment_ID: quiz['appointment_id'],
            Max_mark: (quiz['max_mark'] ?? 100).toDouble(),
            Students: (quiz['students'] as List<dynamic>?)
                    ?.map<Student_Quiz_mark>((s) => Student_Quiz_mark(
                          ID: s['student_id'],
                          Name: s['name'],
                          Mark: (s['mark'] ?? 0).toDouble(),
                        ))
                    .toList() ??
                [],
            created_at: createdAt,
          );
        }).toList();
      });
    } catch (e) {
      debugPrint("Failed to load quiz data: $e");
      if (mounted) {
        error_show("Failed to load quiz data", context);
      }
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
