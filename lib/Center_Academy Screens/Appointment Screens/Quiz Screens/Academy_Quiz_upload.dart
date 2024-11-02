// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Widget/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';
import 'package:http/http.dart' as http;

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
    print_developer("start_upload");
    Quiz quiz = Quiz(
      Name: selected_Name,
      Max_mark: selected_Max_Mark,
      Appointment_ID: widget.Appointment_ID,
    );
    try {
      supabase.realtime.disconnect();
      print_developer(jsonEncode(quiz.toJson()));
      final response = await http.post(
        Uri.parse("${Api_Url}Student_Management/Quiz_Upload"),
        body: jsonEncode(quiz.toJson()),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        print_developer('Data: ${response.body}');
        error_show("Quiz Uploaded successfully", context);
        return true;
      } else {
        print_developer('Error: ${response.statusCode} - ${response.body}');
        error_show(response.body, context);
        return false;
      }
    } catch (e) {
      print_developer(e);
      error_show("Failed", context);
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
            Back_Button(),
            Logo(),
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
