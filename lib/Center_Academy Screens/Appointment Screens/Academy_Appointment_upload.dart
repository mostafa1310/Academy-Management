// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Widget/CustomDropDownFormField.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_service.dart';
import '../../../mock/mock_data.dart';
import '../../../Widget/back_button.dart';

int currentPageIndex = 0;

class Academy_Appointment_upload extends StatefulWidget {
  const Academy_Appointment_upload({super.key});

  @override
  _Academy_Appointment_uploadState createState() =>
      _Academy_Appointment_uploadState();
}

class _Academy_Appointment_uploadState
    extends State<Academy_Appointment_upload> {
  String selected_Grade = "Grade 10";
  String selected_Teacher = "";
  String selected_First_day = "Saturday";
  String selected_Second_day = "Saturday";
  String selected_Hour_Mode = "AM";
  int selected_Hour_From = 1;
  int selected_Hour_To = 1;
  List<String> Grades_List = ["Grade 10", "Grade 11", "Grade 12"];
  List<String> Days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];
  String selected_Material = "";
  List<MaterialItem> materials = [
    MaterialItem(name: 'English'),
    MaterialItem(name: 'Math 1'),
    MaterialItem(name: 'Math 2'),
    MaterialItem(name: 'Physics'),
    MaterialItem(name: 'Chemistry'),
    MaterialItem(name: 'Biology'),
    MaterialItem(name: 'Programming'),
    MaterialItem(name: 'Conversation'),
    MaterialItem(name: 'Business'),
  ];
  final _formKey = GlobalKey<FormState>();
  List<Teacher> Teachers_list = [];
  bool _isLoading = false;
  Future<void> Get_Appointment_Available_Teachers() async {
    try {
      setState(() {
        Teachers_list.clear();
        selected_Teacher = "";
      });

      // Get mock teachers
      final mockDB = MockDatabaseService();
      final teachers = await mockDB.getTeachers();

      // Filter teachers by material
      final availableTeachers = teachers
          .where((teacher) => teacher['material'] == selected_Material)
          .map((teacher) => Teacher(
                ID: teacher['ID'],
                Name: teacher['name'],
                Email: teacher['email'],
                Phone: teacher['phone'],
                Material: teacher['material'],
              ))
          .toList();

      if (!mounted) return;

      if (availableTeachers.isEmpty) {
        error_show("No teachers available for this material", context);
        return;
      }

      setState(() {
        Teachers_list = availableTeachers;
        selected_Teacher = Teachers_list[0].Name;
      });
    } catch (e) {
      debugPrint("Failed to load teachers: $e");
      if (mounted) {
        error_show("Failed to load teachers", context);
      }
    }
  }

  Future<bool> send_Appointment_data() async {
    try {
      // Create appointment data
      final appointmentData = {
        'ID': MockData.appointments.length + 1,
        'teacher_id':
            Teachers_list.firstWhere((x) => x.Name == selected_Teacher).ID,
        'material': selected_Material,
        'grade': selected_Grade,
        'first_day': selected_First_day,
        'second_day': selected_Second_day,
        'hour_from': selected_Hour_From,
        'hour_to': selected_Hour_To,
        'hour_mode': selected_Hour_Mode,
        'students': [],
        'created_at': DateTime.now().toIso8601String(),
      };

      // Add to mock data
      MockData.appointments.add(appointmentData);

      error_show("Appointment created successfully", context);
      return true;
    } catch (e) {
      debugPrint("Failed to create appointment: $e");
      error_show("Failed to create appointment", context);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: top_gap + top_gap_extra),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomDropdownFormField<String>(
                              items: Days,
                              value: selected_First_day,
                              onChanged: (String? value) {
                                setState(() {
                                  selected_First_day = value!;
                                });
                              },
                              labelText: 'First Day',
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: CustomDropdownFormField<String>(
                              items: Days,
                              value: selected_Second_day,
                              onChanged: (String? value) {
                                setState(() {
                                  selected_Second_day = value!;
                                });
                              },
                              labelText: 'Second Day',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomDropdownFormField<int>(
                              items: const [
                                1,
                                2,
                                3,
                                4,
                                5,
                                6,
                                7,
                                8,
                                9,
                                10,
                                11,
                                12,
                              ],
                              value: selected_Hour_From,
                              onChanged: (int? value) {
                                setState(() {
                                  selected_Hour_From = value!;
                                });
                              },
                              labelText: 'From',
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: CustomDropdownFormField<int>(
                              items: const [
                                1,
                                2,
                                3,
                                4,
                                5,
                                6,
                                7,
                                8,
                                9,
                                10,
                                11,
                                12,
                              ],
                              value: selected_Hour_To,
                              onChanged: (int? value) {
                                setState(() {
                                  selected_Hour_To = value!;
                                });
                              },
                              labelText: 'To',
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: CustomDropdownFormField<String>(
                              items: const ["AM", "PM"],
                              value: selected_Hour_Mode,
                              onChanged: (String? value) {
                                setState(() {
                                  selected_Hour_Mode = value!;
                                });
                              },
                              labelText: 'Timing',
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomDropdownFormField<String>(
                      items: Grades_List,
                      value: selected_Grade,
                      onChanged: (String? value) {
                        setState(() {
                          selected_Grade = value!;
                        });
                      },
                      labelText: 'Grade',
                    ),
                    SizedBox(height: 20),
                    CustomDropdownFormField<String>(
                      disabledHint: "Chose Material First",
                      items: Teachers_list.map((x) => x.Name).toList(),
                      value: selected_Teacher,
                      onChanged: (String? value) {
                        setState(() {
                          selected_Teacher = value!;
                        });
                      },
                      labelText: 'Teacher',
                      validator: (value) {
                        if (value != null && selected_Teacher.isNotEmpty) {
                          return null;
                        } else {
                          return "Please Chose a Teacher";
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: materials.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(
                            materials[index].name,
                            style: TextStyle(
                                color: Color.fromARGB(255, 218, 107, 50),
                                fontWeight: FontWeight.bold),
                          ),
                          value: materials[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              for (var element in materials) {
                                element.isSelected = false;
                              }
                              materials[index].isSelected = value!;
                              selected_Material = materials[index].name;
                              if (value) {
                                Get_Appointment_Available_Teachers();
                              } else {
                                setState(() {
                                  Teachers_list.clear();
                                  selected_Teacher = "";
                                });
                              }
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
                              5,
                            ), // Optional: if you want rounded corners
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 100.0,
                        end: _isLoading ? 40.0 : 100.0,
                      ),
                      duration: Duration(
                        milliseconds: 300,
                      ),
                      builder: (
                        context,
                        width,
                        child,
                      ) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (_isLoading) {
                              return;
                            }
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () {
                                  _isLoading = true;
                                },
                              );
                              if (await send_Appointment_data()) {
                                _formKey.currentState!.reset();
                                setState(
                                  () {
                                    selected_First_day = "Saturday";
                                    selected_Grade = "Grade 10";
                                    selected_Second_day = "Saturday";
                                    selected_Hour_Mode = "AM";
                                    for (var element in materials) {
                                      element.isSelected = false;
                                    }
                                    _isLoading = false;
                                    Navigator.pop(context);
                                  },
                                );
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
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Back_Button(),
          ],
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
