// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Client%20Screens/Student_Attendances.dart';
import 'package:Academy_Management/Client%20Screens/Student_Quizzes.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/Main_Manger.dart';

int currentPageIndex = 0;

class Student_Material_Selection extends StatefulWidget {
  final Student student;
  final String Mode;
  const Student_Material_Selection(
      {super.key, required this.student, required this.Mode});

  @override
  _Student_Material_SelectionState createState() =>
      _Student_Material_SelectionState();
}

class _Student_Material_SelectionState
    extends State<Student_Material_Selection> {
  @override
  void initState() {
    super.initState();
  }

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.topCenter,
      body: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Positioned(
              top: 20, // Adjust the top margin
              left: 20, // Adjust the left margin
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the button
                  borderRadius: BorderRadius.circular(30), // Rounded border
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2), // Shadow position
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(
                        context); // Navigates back to the previous screen
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
                ),
                // child: Image.asset(
                //   'assets/AUC Logo.png',
                //   width: 75, // Set the width of the image
                //   height: 75, // Set the height of the image
                // ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        widget.Mode,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemCount: widget.student.Materials
                            .length, // Adjust this count to see the scrolling effect
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // Navigate to another screen when tapped
                              if (widget.Mode == "Quiz Marks") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Student_Quizzes(
                                      student: widget.student,
                                      selected_Material:
                                          widget.student.Materials[index],
                                    ),
                                  ),
                                );
                              } else if (widget.Mode == "Attendance") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Student_Attendances(
                                      student: widget.student,
                                      selected_Material:
                                          widget.student.Materials[index],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // White background
                                borderRadius: BorderRadius.circular(
                                    15.0), // Rounded corners
                                border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: 1.0), // Border to separate items
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    "assets/Materials_icons/${widget.student.Materials[index]}.png", // Replace with your image URL
                                    height: 100.0,
                                    width: 100.0,
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    widget.student.Materials[index],
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
