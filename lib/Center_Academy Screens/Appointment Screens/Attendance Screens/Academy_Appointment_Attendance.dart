// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously, depend_on_referenced_packages, prefer_const_constructors, camel_case_types, library_private_types_in_public_api

import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Academy_Appointments_Students_edit.dart';
import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Attendance%20Screens/Academy_Attendance_Students_upload.dart';
import 'package:Academy_Management/Center_Academy%20Screens/Appointment%20Screens/Attendance%20Screens/Academy_Attendance_upload.dart';
import 'package:Academy_Management/Main_Manger.dart';
import 'package:flutter/material.dart';
import '../../../mock/mock_data.dart';
import '../../../mock/mock_service.dart';

int currentPageIndex = 0;

class Academy_Appointment_Attendance extends StatefulWidget {
  final Appointment appointment;
  const Academy_Appointment_Attendance({super.key, required this.appointment});

  @override
  _Academy_Appointment_AttendanceState createState() =>
      _Academy_Appointment_AttendanceState();
}

class _Academy_Appointment_AttendanceState
    extends State<Academy_Appointment_Attendance> {
  List<AppointmentAttendance> Attendance_list = [];
  Future<void> Get_Appointment_Attendance(int ID) async {
    try {
      setState(() {
        Attendance_list.clear();
      });

      final mockDB = MockDatabaseService();
      final attendanceRecords = await mockDB.getAttendance();

      // Filter attendance records for this appointment
      final appointmentAttendance = attendanceRecords
          .where((record) => record['appointment_id'] == ID)
          .map((record) => AppointmentAttendance(
                ID: record['ID'] ?? MockData.getNextId(),
                Name: record['name'] ?? "Attendance ${DateTime.now()}",
                Appointment_ID: record['appointment_id'],
                Students: (record['students'] as List<dynamic>?)
                    ?.map((s) => Student_Appointment(
                          ID: s['student_id'],
                          Name: s['name'],
                        ))
                    .toList(),
                created_at: DateTime.now(),
              ))
          .toList();

      if (!mounted) return;

      setState(() {
        Attendance_list = appointmentAttendance;
      });

      if (Attendance_list.isEmpty) {
        error_show("No attendance records found", context);
      }
    } catch (e) {
      debugPrint("Failed to load attendance data: $e");
      if (mounted) {
        error_show("Failed to load attendance data", context);
      }
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get_Appointment_Attendance(widget.appointment.ID);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: top_gap + top_gap_extra),
      alignment: Alignment.topCenter,
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Get_Appointment_Attendance(widget.appointment.ID);
              if (!mounted) {
                return;
              }
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: Attendance_list.length,
                    itemBuilder: (context, index) {
                      return Attendance_widget(
                        appointment: widget.appointment,
                        Attendance: Attendance_list[index],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 16,
            child: FloatingActionButton(
              heroTag: null,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Ensures it's perfectly round
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Academy_Attendance_upload(
                      Appointment_ID: widget.appointment.ID,
                    ),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 16,
            child: FloatingActionButton(
              heroTag: null,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(50), // Ensures it's perfectly round
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Academy_Appointments_Students_edit(
                      appointment: widget.appointment,
                    ),
                  ),
                );
              },
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}

class Attendance_widget extends StatelessWidget {
  const Attendance_widget({
    super.key,
    required this.Attendance,
    required this.appointment,
  });

  final AppointmentAttendance Attendance;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(5),
      decoration: ShapeDecoration(
        color: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(width: 2, color: Colors.blue.shade900),
        ),
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Academy_Attendance_Students_upload(
                appointment: appointment,
                Attendance: Attendance,
              ),
            ),
          );
        },
        title: Text(
          Attendance.Name,
          style: TextStyle(color: Colors.white),
          softWrap: false,
        ),
        // subtitle: Text(
        //   "${Attendances[index].created_at!.year}/${Attendances[index].created_at!.month}/${Attendances[index].created_at!.day}",
        //   style: textStyle_white,
        // ),
        trailing: Text(
          "${Attendance.created_at!.year}/${Attendance.created_at!.month}/${Attendance.created_at!.day}",
          style: TextStyle(color: Colors.white),
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
