// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:auc_project/Main_Manger.dart';
import 'package:auc_project/Widget/CustomDropDownFormField.dart';
import 'package:auc_project/Widget/CustomTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../Screens/Auth_Login.dart';
import 'package:auc_project/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Academy_student_upload extends StatefulWidget {
  const Academy_student_upload({super.key});

  @override
  _Academy_student_uploadState createState() => _Academy_student_uploadState();
}

class _Academy_student_uploadState extends State<Academy_student_upload> {
  final TextEditingController Student_name_field =
      TextEditingController(text: "");
  final TextEditingController Student_Email_field =
      TextEditingController(text: "");
  final TextEditingController Student_Phone_field =
      TextEditingController(text: "");
  String selected_Name = "";
  String selected_Phone = "";
  String selected_Grade = "Grade 10";
  String selected_Email = "";
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

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  Future<bool> send_Student_data() async {
    print_developer("start_upload");
    Student student = Student(
        Name: selected_Name,
        Grade: selected_Grade,
        Phone: selected_Phone,
        Email: selected_Email.toLowerCase(),
        Materials: materials
            .where((material) => material.isSelected)
            .map((material) => material.name)
            .toList());
    try {
      supabase.realtime.disconnect();
      print_developer(jsonEncode(student.toJson()));
      final response = await http.post(
        Uri.parse("${Api_Url}Student_Management/Student_Upload"),
        body: jsonEncode(student.toJson()),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        print_developer('Data: ${response.body}');
        var json = jsonDecode(response.body);
        _showPopup(context, json["email"], json["password"]);
        error_show("Student Uploaded successfully", context);
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

  void _showPopup(BuildContext context, String Email, String password) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Student Login info",
            softWrap: false,
          ),
          content: Text(
            "Email:$Email\npassword:$password",
            style: TextStyle(fontSize: 16),
            softWrap: false,
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Copy"),
              onPressed: () async {
                await Clipboard.setData(
                    ClipboardData(text: "Email:$Email\npassword:$password"));
              },
            ),
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: top_gap),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "New Student",
                style: TextStyle(
                    fontSize: 24,
                    color: Color.fromARGB(255, 30, 54, 78),
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                keyboardType: TextInputType.name,
                labelText: "Student Name",
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
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomDropdownFormField<String>(
                items: const <String>["Grade 10", "Grade 11", "Grade 12"],
                value: selected_Grade,
                onChanged: (String? value) {
                  setState(() {
                    selected_Grade = value!;
                  });
                },
                isExpanded: false,
                isDense: true,
                labelText: 'Grade',
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                keyboardType: TextInputType.phone,
                labelText: "Student Phone Number",
                hintText: "Phone Number",
                initialValue: null,
                controller: Student_Phone_field,
                onChanged: (value) {
                  try {
                    setState(() {
                      if (value.trim().isNotEmpty) {
                        selected_Phone = value;
                      }
                    });
                  } catch (e) {
                    selected_Phone = "";
                  }
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Phone Number';
                  } else if (int.tryParse(value) == null ||
                      int.tryParse(value) == 0) {
                    return 'Enter a Valid NUmber';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                keyboardType: TextInputType.emailAddress,
                labelText: "Student Email",
                hintText: "Email",
                controller: Student_Email_field,
                initialValue: null,
                onChanged: (value) {
                  try {
                    setState(() {
                      if (value.trim().isNotEmpty) {
                        selected_Email = value;
                      }
                    });
                  } catch (e) {
                    selected_Email = "";
                  }
                },
                validator: (String? value) {
                  String pattern =
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                  RegExp regExp = RegExp(pattern);
                  if (regExp.hasMatch(value!)) {
                    return null;
                  } else {
                    return 'Please enter a valid email';
                  }
                },
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.transparent,
                    child: CheckboxListTile(
                      title: Text(
                        materials[index].name,
                        style: TextStyle(
                            color: Color.fromARGB(255, 218, 107, 50),
                            fontWeight: FontWeight.bold),
                      ),
                      value: materials[index].isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          materials[index].isSelected = value!;
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
                            5), // Optional: if you want rounded corners
                      ),
                    ),
                  );
                },
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
                              if (await send_Student_data()) {
                                _formKey.currentState!.reset();
                                setState(() {
                                  selected_Email = "";
                                  selected_Grade = "Grade 10";
                                  selected_Name = "";
                                  selected_Phone = "";
                                  Student_name_field.text = "";
                                  Student_Email_field.text = "";
                                  Student_Phone_field.text = "";
                                  for (var element in materials) {
                                    element.isSelected = false;
                                  }
                                  _isLoading = false;
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
                      backgroundColor: const Color.fromARGB(255, 255, 102, 0),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
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
              Settings(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding Settings(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            await Supabase.instance.client.auth.signOut();
            Navigator.pop(context);
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTopPop,
                childCurrent: context.widget,
                child: const LoginPage(),
              ),
            );
          },
          child: const Text('Sign Out'),
        ));
  }
}

class MaterialItem {
  String name;
  bool isSelected;

  MaterialItem({required this.name, this.isSelected = false});
}
