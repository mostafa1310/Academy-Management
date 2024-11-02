// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Widget/CustomDropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';
import 'package:http/http.dart' as http;

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
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Teachers_For_Appointment/$selected_Material"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (!mounted) {
        return;
      }
      if (response.statusCode == 200) {
        print_developer("decode data");
        var jsonList = jsonDecode(utf8.decode(response.bodyBytes));

        if (jsonList is List) {
          if (jsonList.isEmpty) {
            error_show("No Teacher Found", context);
            return;
          }
          print_developer("parse data $jsonList");
          print_developer(jsonList.firstOrNull);
          List<Teacher> Teachers_data =
              jsonList.map((json) => Teacher.fromMap(json)).toList();
          if (Teachers_data.isEmpty) {
            error_show("Nothing", context);
            selected_Teacher = "";
            return;
          }
          setState(() {
            Teachers_list = Teachers_data;
            selected_Teacher = Teachers_list[0].Name;
          });
          print_developer(Teachers_list.length);
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

  Future<bool> send_Appointment_data() async {
    print_developer("start_upload");
    Appointment appointment = Appointment(
      date: Date(
        First_Day: selected_First_day,
        Second_Day: selected_Second_day,
        Hour_From: selected_Hour_From,
        Hour_To: selected_Hour_To,
        Hour_Mode: selected_Hour_Mode,
      ),
      Grade: selected_Grade,
      Material: selected_Material,
      Teacher_ID:
          Teachers_list.firstWhere((x) => x.Name == selected_Teacher).ID!,
    );
    try {
      supabase.realtime.disconnect();
      print_developer(jsonEncode(appointment.toJson()));
      final response = await http.post(
        Uri.parse("${Api_Url}Student_Management/Appointment_Upload"),
        body: jsonEncode(appointment.toJson()),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        print_developer('Data: ${response.body}');
        error_show("Appointment Uploaded successfully", context);

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
            Logo(),
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
