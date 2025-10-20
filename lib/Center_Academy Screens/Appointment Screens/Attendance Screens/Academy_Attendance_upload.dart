// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Widget/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_data.dart';
import '../../../Widget/back_button.dart';

int currentPageIndex = 0;

class Academy_Attendance_upload extends StatefulWidget {
  final int Appointment_ID;
  const Academy_Attendance_upload({super.key, required this.Appointment_ID});

  @override
  _Academy_Attendance_uploadState createState() =>
      _Academy_Attendance_uploadState();
}

class _Academy_Attendance_uploadState extends State<Academy_Attendance_upload> {
  final TextEditingController Student_name_field =
      TextEditingController(text: "");
  String selected_Name = "";
  List<String> Days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];
  List<MaterialItem> materials = [
    MaterialItem(name: 'Science'),
    MaterialItem(name: 'Math'),
    MaterialItem(name: 'English'),
    MaterialItem(name: 'Biology'),
    MaterialItem(name: 'Physics'),
  ];
  final _formKey = GlobalKey<FormState>();

  var _isLoading = false;
  Future<bool> send_Attendance_data() async {
    try {
      // Create a new attendance record
      final attendance = {
        'ID': MockData.attendance.length + 1,
        'name': selected_Name,
        'appointment_id': widget.Appointment_ID,
        'students': [],
        'created_at': DateTime.now().toIso8601String(),
      };

      // Add to mock data
      MockData.attendance.add(attendance);

      error_show("Attendance created successfully", context);
      return true;
    } catch (e) {
      debugPrint("Failed to create attendance: $e");
      error_show("Failed to create attendance", context);
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
      body: GestureDetector(
        onTap: () async {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.white,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: top_gap),
                    CustomTextFormField(
                      keyboardType: TextInputType.name,
                      labelText: "Attendance Name",
                      hintText: "Name",
                      initialValue: null,
                      controller: Student_name_field,
                      onChanged: (value) {
                        try {
                          setState(() {
                            if (value.trim().isNotEmpty) {
                              selected_Name = value;
                            }
                          });
                        } catch (e) {
                          selected_Name = "";
                        }
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return error_show('Please enter Name', context);
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
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
                                    if (await send_Attendance_data()) {
                                      _formKey.currentState!.reset();
                                      setState(() {
                                        selected_Name = "";
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
              ),
              const Back_Button(),
            ],
          ),
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
