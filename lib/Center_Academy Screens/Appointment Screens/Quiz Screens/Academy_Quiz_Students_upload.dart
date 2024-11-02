// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import 'package:Academy_Management/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Academy_Quiz_Students_upload extends StatefulWidget {
  final Appointment appointment;
  final Quiz quiz;
  const Academy_Quiz_Students_upload(
      {super.key, required this.appointment, required this.quiz});

  @override
  _Academy_Quiz_Students_uploadState createState() =>
      _Academy_Quiz_Students_uploadState();
}

class _Academy_Quiz_Students_uploadState
    extends State<Academy_Quiz_Students_upload> {
  List<Student_MapItem> studentItems = [];
  List<Student_Appointment> Students_list = [];
  final _formKey = GlobalKey<FormState>();
  Future<void> Get_Appointment_Students(int ID) async {
    try {
      setState(() {
        Students_list.clear();
        studentItems.clear();
      });
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Appointment_Students/${widget.appointment.ID}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (!mounted) {
        return;
      }
      if (response.statusCode == 200) {
        print_developer("decode data");
        var jsonList = jsonDecode(response.body);

        if (jsonList is List) {
          if (jsonList.isEmpty) {
            error_show("Nothing", context);
            return;
          }
          print_developer("parse data $jsonList");
          print_developer(jsonList.firstOrNull);
          List<Student_Appointment> Students_data = jsonList
              .map((json) => Student_Appointment.fromMap(json))
              .toList();
          setState(() {
            Students_list = Students_data;
          });
          if (Students_list.isEmpty) {
            error_show("Nothing", context);
          }
          print_developer(Students_list.length);
          studentItems.addAll(
            Students_list.map((item) => Student_MapItem(student: item))
                .toList(),
          );
        }
      } else {
        print_developer('Error: ${response.statusCode} - ${response.body}');
        error_show(response.body, context);
      }
    } catch (e) {
      print_developer("Failed to load data $e");
      error_show("Failed to load data", context);
      // ignore: empty_catches
    }
  }

  Future<bool> send_Quiz_Students() async {
    print_developer("start_upload");
    List<Map<String, dynamic>> selected_Students_list = studentItems
        .map((x) => Student_Quiz_mark(
            Name: x.student.Name, ID: x.student.ID, Mark: x.Mark))
        .toList()
        .map((x) => x.toJson())
        .toList();
    // print_developer(selected_Students_list.length);
    try {
      supabase.realtime.disconnect();
      print_developer(jsonEncode(selected_Students_list));
      final response = await http.post(
        Uri.parse(
            "${Api_Url}Student_Management/Upload_Quiz_Students/${widget.quiz.ID}"),
        body: jsonEncode(selected_Students_list),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (response.statusCode == 200) {
        print_developer('Data: ${response.body}');
        error_show("Students Uploaded successfully", context);
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Appointment_Students(widget.appointment.ID);
    });
    super.initState();
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await Get_Appointment_Students(widget.appointment.ID);
          if (!mounted) {
            return;
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: Colors.white,
          alignment: Alignment.topCenter,
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: top_gap + top_gap_extra,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: studentItems.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 75,
                            child: ListTile(
                              title: Text(
                                studentItems[index].student.Name,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 218, 107, 50),
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: SizedBox(
                                width: 125,
                                height: 75,
                                child: TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      setState(() {
                                        studentItems[index].Mark =
                                            double.tryParse(value) ?? 0.0;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Mark',
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 30, 54, 78),
                                    ),
                                    filled: true,
                                    fillColor:
                                        const Color.fromARGB(60, 147, 147, 147),
                                    border: const OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    alignLabelWithHint: true,
                                    // contentPadding: EdgeInsets.symmetric(
                                    //   vertical:
                                    //       20.0, // Increase this to make the TextField taller
                                    //   horizontal: 10.0,
                                    // ),
                                  ),
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 30, 54, 78),
                                      fontSize: 20),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Enter the Mark";
                                    }
                                    if (studentItems[index].Mark <=
                                        widget.quiz.Max_mark) {
                                      return null;
                                    } else {
                                      return "Over Max Mark";
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                                    if (await send_Quiz_Students()) {
                                      setState(() {
                                        for (var element in studentItems) {
                                          element.Mark = 0;
                                        }
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
                Back_Button(),
                Logo(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Student_MapItem {
  Student_Appointment student;
  double Mark;

  Student_MapItem({required this.student, this.Mark = 0});
}
