// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:typed_data';
import 'package:Academy_Management/Client%20Screens/Student_Material_Selection.dart';
import 'package:flutter/material.dart';
import '../Screens/Auth_Login.dart';
import '../mock/mock_service.dart';
import '../Main_Manger.dart';

int currentPageIndex = 0;

class Student_Dashboard extends StatefulWidget {
  final int ID;
  const Student_Dashboard({super.key, required this.ID});

  @override
  _Student_DashboardState createState() => _Student_DashboardState();
}

class _Student_DashboardState extends State<Student_Dashboard> {
  Student _student =
      Student(Name: "", Email: "", Phone: "", Grade: "", Materials: []);
  Uint8List? student_image;
  late Future<Student?> _futureData;
  Future<Student?> Get_Student_data(int ID) async {
    try {
      final mockDB = MockDatabaseService();
      final students = await mockDB.getStudents();
      final mockData = students.firstWhere((s) => s['ID'] == ID);

      // Transform mock data to match Student model
      final studentData = {
        'ID': mockData['ID'],
        'Name': mockData['name'],
        'Email': mockData['email'],
        'Phone': mockData['phone'] ?? '',
        'Grade': mockData['grade'] ?? '',
        // mock_data uses 'materials' as a List - ensure it's converted to List<String>
        'Materials': (mockData['materials'] as List<dynamic>?)
                ?.map((m) => m.toString())
                .toList() ??
            [],
      };

      _student = Student.fromMap(studentData);
      return _student;
    } catch (e) {
      debugPrint("Failed to load student data: $e");
      return null;
    }
  }

  @override
  void initState() {
    _futureData = Get_Student_data(widget.ID);
    super.initState();
  }

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (!snapshot.hasData) {
            return Text('Error: ${snapshot.error}');
          }
          return Scaffold(
            persistentFooterAlignment: AlignmentDirectional.topCenter,
            body: Container(
              color: Colors.white,
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: student_image != null
                              ? MemoryImage(student_image!)
                              : AssetImage("assets/User.png"),
                          alignment: Alignment.center,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          _student.Name,
                          textAlign: TextAlign.center,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 102, 0),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Welcome to',
                          textAlign: TextAlign.center,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 28,
                            color: Color.fromARGB(255, 0, 53, 90),
                          ),
                        ),
                        Text(
                          'Academy App',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 53, 90),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Student_Material_Selection(
                                          student: _student,
                                          Mode: 'Quiz Marks',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2,
                                        color:
                                            Color.fromARGB(60, 147, 147, 147),
                                      ),
                                    ),
                                    child: Image.asset(
                                      width: 70,
                                      height: 70,
                                      'assets/quiz_icon.png', // Replace with your asset path
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Quiz Marks',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Student_Material_Selection(
                                          student: _student,
                                          Mode: 'Attendance',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 2,
                                        color:
                                            Color.fromARGB(60, 147, 147, 147),
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/attendance_icon.png', // Replace with your asset path
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Attendance',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 255, 102, 0),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 10,
                            ),
                            textStyle: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            await MockSupabaseService().signOut();
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign out',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
