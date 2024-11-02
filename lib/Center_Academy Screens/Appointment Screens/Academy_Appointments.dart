// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'dart:convert';

import 'package:auc_project/Center_Academy%20Screens/Appointment%20Screens/Academy_Appointment_Management.dart';
import 'package:auc_project/Center_Academy%20Screens/Appointment%20Screens/Academy_Appointment_upload.dart';
import 'package:auc_project/Main_Manger.dart';
import 'package:auc_project/Widget/CustomDropDownFormField.dart';
import 'package:flutter/material.dart';
import 'package:auc_project/main.dart';
import 'package:http/http.dart' as http;

int currentPageIndex = 0;

class Academy_Appointments extends StatefulWidget {
  const Academy_Appointments({super.key});

  @override
  _Academy_AppointmentsState createState() => _Academy_AppointmentsState();
}

class _Academy_AppointmentsState extends State<Academy_Appointments> {
  final TextEditingController Student_name_field =
      TextEditingController(text: "");
  String selected_Grade = "Grade 10";
  String selected_Material = "English";
  List<String> Grades_List = ["Grade 10", "Grade 11", "Grade 12"];
  List<String> Material_List = [
    'English',
    'Math 1',
    'Math 2',
    'Physics',
    'Chemistry',
    'Biology',
    'Programming',
    'Conversation',
    'Business',
  ];
  List<Appointment> Appointments_list = [];
  Future<void> Get_Appointments(String Material, String Grade) async {
    try {
      final response = await http.get(
        Uri.parse(
            "${Api_Url}Student_Management/Get_Appointments/${Grade.trim()}/${selected_Material.trim()}"),
        headers: headers_request(supabase.auth.currentSession!.accessToken),
      );
      print_developer(
          'response: ${response.statusCode} - ${jsonDecode(response.body)}');
      if (!mounted) {
        return;
      }
      if (response.statusCode == 200) {
        setState(() {
          Appointments_list.clear();
        });
        print_developer("decode data");
        var jsonList = jsonDecode(response.body);

        if (jsonList is List) {
          if (jsonList.isEmpty) {
            error_show("Nothing", context);
            return;
          }
          print_developer("parse data $jsonList");
          print_developer(jsonList.firstOrNull);
          List<Appointment> Appointments_data =
              jsonList.map((json) => Appointment.fromMap(json)).toList();
          setState(() {
            Appointments_list = Appointments_data;
          });
          if (Appointments_list.isEmpty) {
            error_show("Nothing", context);
          }
        }
      } else {
        print_developer('Error: ${response.statusCode} - ${response.body}');
        error_show(response.body, context);
      }
    } catch (e) {
      print_developer("Failed to load data");
      error_show("Failed to load data", context);
      // ignore: empty_catches
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Appointments(selected_Material, selected_Grade);
    });
    super.initState();
  }

  TextStyle textStyle_white =
      const TextStyle(color: Colors.white, fontSize: 16);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top_gap),
      color: Colors.transparent,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Get_Appointments(selected_Material, selected_Grade);
              if (!mounted) {
                return;
              }
            },
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomDropdownFormField<String>(
                        value: selected_Grade,
                        onChanged: (newValue) async {
                          setState(() {
                            selected_Grade = newValue!;
                          });
                          await Get_Appointments(
                              selected_Material, selected_Grade);
                        },
                        items: Grades_List,
                        labelText: 'Grade',
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: CustomDropdownFormField<String>(
                        value: selected_Material,
                        onChanged: (newValue) async {
                          setState(() {
                            selected_Material = newValue!;
                          });
                          await Get_Appointments(
                              selected_Material, selected_Grade);
                        },
                        items: Material_List,
                        labelText: 'Material',
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: Appointments_list.length,
                      itemBuilder: (context, index) {
                        return Appointment_widget(
                          index: index,
                          Appointments: Appointments_list,
                          textStyle_white: textStyle_white,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              heroTag: null,
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1, color: Color.fromARGB(255, 30, 54, 78)),
                borderRadius:
                    BorderRadius.circular(50), // Ensures it's perfectly round
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Academy_Appointment_upload(),
                  ),
                );
              },
              child: Icon(
                size: 40,
                weight: 10,
                Icons.add,
                color: Color.fromARGB(255, 30, 54, 78),
                shadows: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Appointment_widget extends StatelessWidget {
  const Appointment_widget({
    super.key,
    required this.Appointments,
    required this.textStyle_white,
    required this.index,
  });

  final List<Appointment> Appointments;
  final TextStyle textStyle_white;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: ListTile(
        onTap: () {
          // Navigate to player details
          // supabase.realtime.disconnect();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Academy_Appointment_Management(
                appointment: Appointments[index],
              ),
            ),
          );
        },
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
        title: Text(
          "${Appointments[index].date.First_Day}:${Appointments[index].date.Second_Day}",
          style: textStyle_white,
          softWrap: false, // Adjust the font size as needed
        ),
        // subtitle: Text(
        //   "${Appointments[index].date.Hour_From}:${Appointments[index].date.Hour_To} ${Appointments[index].date.Hour_Mode}",
        //   style: textStyle_white, // Adjust the font size as needed
        // ),
        trailing: Text(
          "${Appointments[index].date.Hour_From}:${Appointments[index].date.Hour_To} ${Appointments[index].date.Hour_Mode}",
          style: textStyle_white, // Adjust the font size as needed
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
