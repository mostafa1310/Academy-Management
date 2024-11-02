// ignore_for_file: file_names, non_constant_identifier_names, camel_case_types

import 'package:Academy_Management/main.dart';
import 'package:flutter/material.dart';

double top_gap = 20;
double top_gap_extra = 40;
Map<String, String> headers_request(String accessToken) {
  return {
    'Authorization': 'Bearer $accessToken',
    'Content-Type': 'application/json',
    'x-client-info': supabase.auth.currentUser?.email ?? "un Known",
  };
}

String error_show(String value, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      value,
      style: const TextStyle(fontSize: 16, color: Colors.white),
    ),
    showCloseIcon: true,
  ));
  return value;
}

class Student {
  int? ID;
  String Name;
  String Email;
  String Phone;
  String Grade;
  List<String> Materials;

  Student({
    this.ID,
    required this.Name,
    required this.Email,
    required this.Phone,
    required this.Grade,
    required this.Materials,
  });
  Map<String, dynamic> toJson() {
    return {
      "Name": Name,
      "Email": Email,
      "Phone": Phone,
      "Grade": Grade,
      "Materials": Materials,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      ID: map['ID'],
      Name: map['Name'],
      Email: map['Email'],
      Phone: map['Phone'],
      Grade: map['Grade'],
      Materials: List<String>.from(map['Materials']),
      // Assign other variables from the map keys
    );
  }
}

class Appointment {
  int ID;
  Date date;
  String Grade;
  String Material;
  List<Student_Appointment>? Students;
  int Teacher_ID;
  Appointment({
    this.ID = 0,
    required this.date,
    required this.Grade,
    required this.Material,
    this.Students,
    required this.Teacher_ID,
  });
  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "Grade": Grade,
      "Material": Material,
      "Students": Students?.map((student) => student.toJson()).toList(),
      "Teacher_ID": Teacher_ID,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      ID: map['ID'],
      date: Date.fromMap(map['date']),
      Grade: map['Grade'],
      Material: map['Material'],
      Students: map['Students'] != null
          ? List<Student_Appointment>.from(map['Students']
              .map((student) => Student_Appointment.fromMap(student)))
          : null,
      Teacher_ID: map['Teacher_ID'],
      // Assign other variables from the map keys
    );
  }
}

class AppointmentAttendance {
  int? ID;
  String Name;
  int Appointment_ID;
  List<Student_Appointment>? Students;
  DateTime? created_at;

  AppointmentAttendance({
    this.ID,
    required this.Name,
    required this.Appointment_ID,
    this.Students,
    this.created_at,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": Name,
      "Appointment_ID": Appointment_ID,
    };
  }

  factory AppointmentAttendance.fromMap(Map<String, dynamic> map) {
    return AppointmentAttendance(
      ID: map["ID"],
      Name: map["Name"],
      Appointment_ID: map["Appointment_ID"],
      Students: map['Students'] != null
          ? List<Student_Appointment>.from(map['Students']
              .map((student) => Student_Appointment.fromMap(student)))
          : null,
      created_at: DateTime.parse(map["created_at"]),
    );
  }
}

class Student_Appointment {
  int ID;
  String Name;
  Student_Appointment({
    required this.ID,
    required this.Name,
  });
  Map<String, dynamic> toJson() {
    return {
      "ID": ID,
      "Name": Name,
    };
  }

  factory Student_Appointment.fromMap(Map<String, dynamic> map) {
    return Student_Appointment(
      ID: map['ID'],
      Name: map['Name'],
    );
  }
}

class Student_Quiz_mark {
  int ID;
  String Name;
  double Mark;
  Student_Quiz_mark({
    required this.ID,
    required this.Name,
    required this.Mark,
  });
  Map<String, dynamic> toJson() {
    return {
      "ID": ID,
      "Name": Name,
      "Mark": Mark,
    };
  }

  factory Student_Quiz_mark.fromMap(Map<String, dynamic> map) {
    return Student_Quiz_mark(
      ID: map['ID'],
      Name: map['Name'],
      Mark: map['Mark'].toDouble(),
    );
  }
}

class StudentQuizRecord {
  String quizName;
  DateTime createdAt;
  double? mark;
  double maxMark;

  StudentQuizRecord({
    required this.quizName,
    required this.createdAt,
    required this.maxMark,
    this.mark,
  });

  // Method to convert an instance to a JSON object (for serialization)
  Map<String, dynamic> toJson() {
    return {
      'Quiz_name': quizName,
      'created_at': createdAt,
      'Mark': mark,
      'Max_Mark': maxMark,
    };
  }

  // Factory method to create an instance from a Map (for deserialization)
  factory StudentQuizRecord.fromMap(Map<String, dynamic> map) {
    return StudentQuizRecord(
      quizName: map['Quiz_name'],
      createdAt: DateTime.parse(map['created_at']),
      maxMark: map['Max_Mark'].toDouble(),
      mark: map['Mark'].toDouble(),
    );
  }
}

class Quiz {
  int? ID;
  int Appointment_ID;
  double Max_mark;
  String Name;
  List<Student_Quiz_mark>? Students;
  DateTime? created_at;
  Quiz({
    this.ID = 0,
    required this.Appointment_ID,
    required this.Max_mark,
    required this.Name,
    this.Students,
    this.created_at,
  });
  Map<String, dynamic> toJson() {
    return {
      "Appointment_ID": Appointment_ID,
      "Max_mark": Max_mark,
      "Name": Name,
    };
  }

  factory Quiz.fromMap(Map<String, dynamic> map) {
    print_developer(map);
    return Quiz(
      ID: map['ID'],
      Appointment_ID: map['Appointment_ID'],
      Max_mark: map['Max_mark'].toDouble(),
      Name: map['Name'],
      Students: map['Students'] != null
          ? List<Student_Quiz_mark>.from(map['Students']
              .map((student) => Student_Quiz_mark.fromMap(student)))
          : null,
      created_at: DateTime.parse(map["created_at"]),
    );
  }
}

class Date {
  String First_Day;
  String Second_Day;
  int Hour_To;
  int Hour_From;
  String Hour_Mode;
  Date({
    required this.First_Day,
    required this.Second_Day,
    required this.Hour_From,
    required this.Hour_To,
    required this.Hour_Mode,
  });
  factory Date.fromMap(Map<String, dynamic> map) {
    return Date(
      First_Day: map['First_Day'],
      Second_Day: map['Second_Day'],
      Hour_From: map['Hour_From'],
      Hour_To: map['Hour_To'],
      Hour_Mode: map['Hour_Mode'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "First_Day": First_Day,
      "Second_Day": Second_Day,
      "Hour_From": Hour_From,
      "Hour_To": Hour_To,
      "Hour_Mode": Hour_Mode,
    };
  }
}

class StudentAttendanceRecord {
  String Attendance_name;
  DateTime created_at;
  bool Attend;

  StudentAttendanceRecord({
    required this.Attendance_name,
    required this.created_at,
    required this.Attend,
  });

  // Method to convert an instance to a JSON object (for serialization)
  Map<String, dynamic> toJson() {
    return {
      'Attendance_name': Attendance_name,
      'created_at': created_at,
      'Attend': Attend,
    };
  }

  // Factory constructor to create an instance from a Map (for deserialization)
  factory StudentAttendanceRecord.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceRecord(
      Attendance_name: map['Attendance_name'],
      created_at: DateTime.parse(map['created_at']),
      Attend: map['Attend'],
    );
  }
}

class Teacher {
  int? ID;
  String Name;
  String Phone;
  String Email;
  String Material;
  DateTime? created_at;

  Teacher({
    this.ID,
    required this.Name,
    required this.Phone,
    required this.Email,
    required this.Material,
    this.created_at,
  });

  // Method to convert a Teacher instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'Name': Name,
      'Phone': Phone,
      'Email': Email,
      'Material': Material,
    };
  }

  // Factory method to create a Teacher instance from a map
  factory Teacher.fromMap(Map<String, dynamic> map) {
    return Teacher(
      ID: map['ID'],
      Name: map['Name'],
      Phone: map['Phone'],
      Email: map['Email'],
      Material: map['Material'],
      created_at: DateTime.parse(map['created_at']),
    );
  }
}
