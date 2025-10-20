// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Widget/CustomTextFormField.dart';
import 'package:Academy_Management/mock/mock_data.dart';
import 'package:flutter/material.dart';

int currentPageIndex = 0;

class Academy_Quiz_upload extends StatefulWidget {
  final int Appointment_ID;
  const Academy_Quiz_upload({super.key, required this.Appointment_ID});

  @override
  _Academy_Quiz_uploadState createState() => _Academy_Quiz_uploadState();
}

class _Academy_Quiz_uploadState extends State<Academy_Quiz_upload> {
  final TextEditingController Quizzes_name_field =
      TextEditingController(text: "");
  final TextEditingController Quizzes_Mark_field =
      TextEditingController(text: "");
  String selected_Name = "";
  double selected_Max_Mark = 0;
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  Future<bool> send_Quiz_data() async {
    try {
      debugPrint("Creating new quiz");
      final quiz = {
        'ID': MockData.getNextId(),
        'title': selected_Name,
        'appointment_id': widget.Appointment_ID,
        'max_mark': selected_Max_Mark,
        'students': [],
        'created_at': DateTime.now().toIso8601String(),
      };

      MockData.addQuiz(quiz);
      error_show("Quiz created successfully", context);
      return true;
    } catch (e) {
      debugPrint("Failed to create quiz: $e");
      error_show("Failed to create quiz", context);
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
        alignment: Alignment.center,
        child: Stack(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    keyboardType: TextInputType.name,
                    labelText: "Quiz Name",
                    hintText: "Name",
                    initialValue: null,
                    controller: Quizzes_name_field,
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
                  CustomTextFormField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    labelText: "Quiz Max Marks",
                    hintText: "Mark",
                    initialValue: null,
                    controller: Quizzes_Mark_field,
                    onChanged: (value) {
                      try {
                        setState(() {
                          if (value.trim().isNotEmpty) {
                            selected_Max_Mark = double.tryParse(value)!;
                          }
                        });
                      } catch (e) {
                        selected_Max_Mark = 0;
                      }
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return error_show('Please enter Mark', context);
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
                                  if (await send_Quiz_data()) {
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
    );
  }
}

class MaterialItem {
  String name;
  bool isSelected;

  MaterialItem({required this.name, this.isSelected = false});
}
