// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Academy_Appointment_Management.dart';
import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Academy_Appointment_upload.dart';
import 'package:Academy_Management/Main_Manger.dart';
import 'package:Academy_Management/Widget/CustomDropDownFormField.dart';
import 'package:flutter/material.dart';
import '../../mock/mock_service.dart';

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
  String selected_Material = "Math 1";
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
      setState(() {
        Appointments_list.clear();
      });

      // Get mock appointments
      final mockDB = MockDatabaseService();
      final appointments = await mockDB.getAppointments();

      debugPrint('Fetched ${appointments.length} appointments');
      debugPrint('Filtering for grade: $Grade, material: $Material');

      // Validate appointments structure
      for (var apt in appointments) {
        if (apt['date'] == null) {
          debugPrint('Warning: appointment ${apt['ID']} has null date');
        } else {
          debugPrint('Appointment ${apt['ID']} date structure: ${apt['date']}');
        }
      }

      // Filter appointments by grade and material
      final filteredAppointments = appointments.where((apt) {
        final matches = apt['grade'] == Grade && apt['material'] == Material;
        debugPrint(
            'Checking appointment ${apt['ID']}: grade=${apt['grade']}, material=${apt['material']}, matches=$matches');
        return matches;
      }).map((apt) {
        // mock_data stores the date fields inside a nested 'date' map
        final dateMap = apt['date'] as Map<String, dynamic>?;

        // Debug print to trace the date map
        debugPrint('Processing appointment ${apt['ID']} date fields:');
        debugPrint('  First_Day: ${dateMap?['First_Day']}');
        debugPrint('  Second_Day: ${dateMap?['Second_Day']}');
        debugPrint('  Hour_From: ${dateMap?['Hour_From']}');
        debugPrint('  Hour_To: ${dateMap?['Hour_To']}');
        debugPrint('  Hour_Mode: ${dateMap?['Hour_Mode']}');

        if (dateMap == null) {
          debugPrint('Warning: null date map for appointment ${apt['ID']}');
          return Appointment(
            ID: apt['ID'] ?? 0,
            Material: apt['material'] ?? '',
            Grade: apt['grade'] ?? '',
            Teacher_ID: apt['teacher_id'] ?? 0,
            date: Date(
              First_Day: '',
              Second_Day: '',
              Hour_From: 0,
              Hour_To: 0,
              Hour_Mode: '',
            ),
          );
        }

        final firstDay = dateMap['First_Day']?.toString() ?? '';
        final secondDay = dateMap['Second_Day']?.toString() ?? '';
        final hourFrom = dateMap['Hour_From'] is int
            ? dateMap['Hour_From'] as int
            : int.tryParse(dateMap['Hour_From']?.toString() ?? '') ?? 0;
        final hourTo = dateMap['Hour_To'] is int
            ? dateMap['Hour_To'] as int
            : int.tryParse(dateMap['Hour_To']?.toString() ?? '') ?? 0;
        final hourMode = dateMap['Hour_Mode']?.toString() ?? '';

        return Appointment(
          ID: apt['ID'] ?? 0,
          Material: apt['material']?.toString() ?? '',
          Grade: apt['grade']?.toString() ?? '',
          Teacher_ID: apt['teacher_id'] ?? 0,
          date: Date(
            First_Day: firstDay,
            Second_Day: secondDay,
            Hour_From: hourFrom,
            Hour_To: hourTo,
            Hour_Mode: hourMode,
          ),
        );
      }).toList();

      if (!mounted) return;

      if (filteredAppointments.isEmpty) {
        error_show("No appointments found", context);
        return;
      }

      setState(() {
        Appointments_list = filteredAppointments;
      });
    } catch (e) {
      debugPrint("Failed to load appointments: $e");
      if (mounted) {
        error_show("Failed to load appointments", context);
      }
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
