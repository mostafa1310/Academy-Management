class MockData {
  static List<Map<String, dynamic>> attendance = [
    {
      'ID': 1,
      'name': 'Week 1 Attendance - Math 1',
      'appointment_id': 1,
      'material': 'Math 1',
      'students': [
        {'student_id': 1, 'name': 'John Doe', 'attended': true},
        {'student_id': 2, 'name': 'Jane Smith', 'attended': false}
      ],
      'created_at': '2025-10-01T10:00:00Z'
    },
    {
      'ID': 2,
      'name': 'Week 2 Attendance - Math 1',
      'appointment_id': 1,
      'material': 'Math 1',
      'students': [
        {'student_id': 1, 'name': 'John Doe', 'attended': true},
        {'student_id': 2, 'name': 'Jane Smith', 'attended': true},
        {'student_id': 7, 'name': 'Hassan Mahmoud', 'attended': false}
      ],
      'created_at': '2025-10-08T10:00:00Z'
    },
    {
      'ID': 3,
      'name': 'Physics - Midmonth Attendance',
      'appointment_id': 3,
      'material': 'Physics',
      'students': [
        {'student_id': 4, 'name': 'Sara Ali', 'attended': true},
        {'student_id': 5, 'name': 'Omar Adel', 'attended': true},
        {'student_id': 6, 'name': 'Mona Karim', 'attended': false}
      ],
      'created_at': '2025-10-02T09:30:00Z'
    },
    {
      'ID': 4,
      'name': 'English - Week 1',
      'appointment_id': 4,
      'material': 'English',
      'students': [
        {'student_id': 9, 'name': 'Khaled Nassar', 'attended': true},
        {'student_id': 10, 'name': 'Dina Youssef', 'attended': false}
      ],
      'created_at': '2025-10-03T11:00:00Z'
    },
    {
      'ID': 5,
      'name': 'Programming - Intro Session',
      'appointment_id': 6,
      'material': 'Programming',
      'students': [
        {'student_id': 3, 'name': 'Ali Hassan', 'attended': true},
        {'student_id': 11, 'name': 'Mahmoud Saber', 'attended': true},
        {'student_id': 12, 'name': 'Noha Samir', 'attended': false}
      ],
      'created_at': '2025-10-05T16:00:00Z'
    },
    {
      'ID': 6,
      'name': 'Conversation - Practice Class',
      'appointment_id': 7,
      'material': 'Conversation',
      'students': [
        {'student_id': 1, 'name': 'John Doe', 'attended': true},
        {'student_id': 8, 'name': 'Lina Farid', 'attended': true}
      ],
      'created_at': '2025-10-07T12:00:00Z'
    },
    {
      'ID': 7,
      'name': 'Biology - Lab Day',
      'appointment_id': 9,
      'material': 'Biology',
      'students': [
        {'student_id': 5, 'name': 'Omar Adel', 'attended': true},
        {'student_id': 12, 'name': 'Noha Samir', 'attended': true}
      ],
      'created_at': '2025-10-09T09:00:00Z'
    },
    {
      'ID': 8,
      'name': 'Business - Guest Lecture',
      'appointment_id': 8,
      'material': 'Business',
      'students': [
        {'student_id': 2, 'name': 'Jane Smith', 'attended': true},
        {'student_id': 9, 'name': 'Khaled Nassar', 'attended': true}
      ],
      'created_at': '2025-10-11T14:00:00Z'
    }
  ];

  static List<Map<String, dynamic>> students = [
    {
      'ID': 1,
      'name': 'John Doe',
      'email': 'john@example.com',
      'phone': '1234567890',
      'grade': 'Grade 10',
      'materials': ['Math 1', 'Conversation']
    },
    {
      'ID': 2,
      'name': 'Jane Smith',
      'email': 'jane@example.com',
      'phone': '0987654321',
      'grade': 'Grade 10',
      'materials': ['Math 1', 'English', 'Business']
    },
    {
      'ID': 3,
      'name': 'Ali Hassan',
      'email': 'ali.hassan@example.com',
      'phone': '201234567890',
      'grade': 'Grade 11',
      'materials': ['Math 2', 'Programming']
    },
    {
      'ID': 4,
      'name': 'Sara Ali',
      'email': 'sara.ali@example.com',
      'phone': '201112223344',
      'grade': 'Grade 11',
      'materials': ['Physics', 'Math 2']
    },
    {
      'ID': 5,
      'name': 'Omar Adel',
      'email': 'omar.adel@example.com',
      'phone': '201223344556',
      'grade': 'Grade 12',
      'materials': ['Physics', 'Biology', 'Math 2']
    },
    {
      'ID': 6,
      'name': 'Mona Karim',
      'email': 'mona.karim@example.com',
      'phone': '201334455667',
      'grade': 'Grade 10',
      'materials': ['English', 'Physics']
    },
    {
      'ID': 7,
      'name': 'Hassan Mahmoud',
      'email': 'hassan.m@example.com',
      'phone': '201445566778',
      'grade':
          'Grade 9', // note: out-of-list grade intentionally present to test edge cases
      'materials': ['Math 1']
    },
    {
      'ID': 8,
      'name': 'Lina Farid',
      'email': 'lina.farid@example.com',
      'phone': '201556677889',
      'grade': 'Grade 10',
      'materials': ['Conversation', 'English']
    },
    {
      'ID': 9,
      'name': 'Khaled Nassar',
      'email': 'khaled.n@example.com',
      'phone': '201667788990',
      'grade': 'Grade 12',
      'materials': ['English', 'Business', 'Math 2']
    },
    {
      'ID': 10,
      'name': 'Dina Youssef',
      'email': 'dina.y@example.com',
      'phone': '201778899001',
      'grade': 'Grade 11',
      'materials': ['English', 'Chemistry']
    },
    {
      'ID': 11,
      'name': 'Mahmoud Saber',
      'email': 'mahmoud.s@example.com',
      'phone': '201889900112',
      'grade': 'Grade 10',
      'materials': ['Math 1', 'Programming']
    },
    {
      'ID': 12,
      'name': 'Noha Samir',
      'email': 'noha.s@example.com',
      'phone': '201990011223',
      'grade': 'Grade 11',
      'materials': ['Chemistry', 'Biology', 'Programming']
    }
  ];

  static List<Map<String, dynamic>> teachers = [
    {
      'ID': 1,
      'name': 'Prof Smith',
      'email': 'prof.smith@academy.com',
      'phone': '1112223333',
      'material': 'Math 1',
      'created_at': '2025-10-01T09:00:00Z'
    },
    {
      'ID': 2,
      'name': 'Dr. Rana',
      'email': 'rana@academy.com',
      'phone': '2223334444',
      'material': 'Physics',
      'created_at': '2025-09-25T08:30:00Z'
    },
    {
      'ID': 3,
      'name': 'Ms. Hoda',
      'email': 'hoda@academy.com',
      'phone': '3334445555',
      'material': 'English',
      'created_at': '2025-08-20T13:20:00Z'
    },
    {
      'ID': 4,
      'name': 'Mr. Karim',
      'email': 'karim@academy.com',
      'phone': '4445556666',
      'material': 'Chemistry',
      'created_at': '2025-07-10T10:10:00Z'
    },
    {
      'ID': 5,
      'name': 'Ms. Leen',
      'email': 'leen@academy.com',
      'phone': '5556667777',
      'material': 'Programming',
      'created_at': '2025-06-05T15:45:00Z'
    },
    {
      'ID': 6,
      'name': 'Mr. Samir',
      'email': 'samir@academy.com',
      'phone': '6667778888',
      'material': 'Business',
      'created_at': '2025-05-12T11:30:00Z'
    },
    {
      'ID': 7,
      'name': 'Ms. Nora',
      'email': 'nora@academy.com',
      'phone': '7778889999',
      'material': 'Biology',
      'created_at': '2025-04-22T09:20:00Z'
    }
  ];

  static List<Map<String, dynamic>> appointments = [
    {
      'ID': 1,
      'teacher_id': 1,
      'material': 'Math 1',
      'grade': 'Grade 10',
      'date': {
        'First_Day': 'Monday',
        'Second_Day': 'Wednesday',
        'Hour_From': 10,
        'Hour_To': 12,
        'Hour_Mode': 'AM'
      }
    },
    {
      'ID': 2,
      'teacher_id': 1,
      'material': 'Math 2',
      'grade': 'Grade 11',
      'date': {
        'First_Day': 'Tuesday',
        'Second_Day': 'Thursday',
        'Hour_From': 14,
        'Hour_To': 16,
        'Hour_Mode': 'PM'
      }
    },
    {
      'ID': 3,
      'teacher_id': 2,
      'material': 'Physics',
      'grade': 'Grade 11',
      'date': {
        'First_Day': 'Saturday',
        'Second_Day': 'Monday',
        'Hour_From': 9,
        'Hour_To': 11,
        'Hour_Mode': 'AM'
      }
    },
    {
      'ID': 4,
      'teacher_id': 3,
      'material': 'English',
      'grade': 'Grade 12',
      'date': {
        'First_Day': 'Wednesday',
        'Second_Day': 'Friday',
        'Hour_From': 11,
        'Hour_To': 12,
        'Hour_Mode': 'AM'
      }
    },
    {
      'ID': 5,
      'teacher_id': 4,
      'material': 'Chemistry',
      'grade': 'Grade 11',
      'date': {
        'First_Day': 'Sunday',
        'Second_Day': 'Tuesday',
        'Hour_From': 16,
        'Hour_To': 18,
        'Hour_Mode': 'PM'
      }
    },
    {
      'ID': 6,
      'teacher_id': 5,
      'material': 'Programming',
      'grade': 'Grade 12',
      'date': {
        'First_Day': 'Thursday',
        'Second_Day': 'Saturday',
        'Hour_From': 13,
        'Hour_To': 15,
        'Hour_Mode': 'PM'
      }
    },
    {
      'ID': 7,
      'teacher_id': 5,
      'material': 'Conversation',
      'grade': 'Grade 10',
      'date': {
        'First_Day': 'Monday',
        'Second_Day': 'Friday',
        'Hour_From': 12,
        'Hour_To': 13,
        'Hour_Mode': 'PM'
      }
    },
    {
      'ID': 8,
      'teacher_id': 6,
      'material': 'Business',
      'grade': 'Grade 12',
      'date': {
        'First_Day': 'Tuesday',
        'Second_Day': 'Thursday',
        'Hour_From': 15,
        'Hour_To': 17,
        'Hour_Mode': 'PM'
      }
    },
    {
      'ID': 9,
      'teacher_id': 7,
      'material': 'Biology',
      'grade': 'Grade 11',
      'date': {
        'First_Day': 'Wednesday',
        'Second_Day': 'Saturday',
        'Hour_From': 9,
        'Hour_To': 11,
        'Hour_Mode': 'AM'
      }
    }
  ];

  static List<Map<String, dynamic>> quizzes = [
    {
      'ID': 1,
      'name': 'Math 1 Quiz 1',
      'appointment_id': 1,
      'material': 'Math 1',
      'max_mark': 100.0,
      'students': [
        {'student_id': 1, 'name': 'John Doe', 'mark': 85.0},
        {'student_id': 2, 'name': 'Jane Smith', 'mark': 92.0},
        {'student_id': 11, 'name': 'Mahmoud Saber', 'mark': 60.0}
      ],
      'created_at': '2025-10-15T14:30:00Z'
    },
    {
      'ID': 2,
      'name': 'Math 2 Quiz A',
      'appointment_id': 2,
      'material': 'Math 2',
      'max_mark': 100.0,
      'students': [
        {'student_id': 3, 'name': 'Ali Hassan', 'mark': 73.0},
        {'student_id': 4, 'name': 'Sara Ali', 'mark': 88.5},
        {'student_id': 12, 'name': 'Noha Samir', 'mark': 91.0}
      ],
      'created_at': '2025-10-18T16:30:00Z'
    },
    {
      'ID': 3,
      'name': 'Physics Midterm',
      'appointment_id': 3,
      'material': 'Physics',
      'max_mark': 60.0,
      'students': [
        {'student_id': 4, 'name': 'Sara Ali', 'mark': 52.0},
        {'student_id': 5, 'name': 'Omar Adel', 'mark': 58.0},
        {'student_id': 6, 'name': 'Mona Karim', 'mark': 45.5}
      ],
      'created_at': '2025-10-20T10:00:00Z'
    },
    {
      'ID': 4,
      'name': 'English Quiz 1',
      'appointment_id': 4,
      'material': 'English',
      'max_mark': 50.0,
      'students': [
        {'student_id': 9, 'name': 'Khaled Nassar', 'mark': 48.0},
        {'student_id': 10, 'name': 'Dina Youssef', 'mark': 35.0}
      ],
      'created_at': '2025-10-10T12:00:00Z'
    },
    {
      'ID': 5,
      'name': 'Chemistry Lab Test',
      'appointment_id': 5,
      'material': 'Chemistry',
      'max_mark': 40.0,
      'students': [
        {'student_id': 10, 'name': 'Dina Youssef', 'mark': 36.0},
        {'student_id': 12, 'name': 'Noha Samir', 'mark': 30.0}
      ],
      'created_at': '2025-10-12T09:00:00Z'
    },
    {
      'ID': 6,
      'name': 'Programming Project',
      'appointment_id': 6,
      'material': 'Programming',
      'max_mark': 100.0,
      'students': [
        {'student_id': 3, 'name': 'Ali Hassan', 'mark': 95.0},
        {'student_id': 11, 'name': 'Mahmoud Saber', 'mark': 80.0},
        {'student_id': 12, 'name': 'Noha Samir', 'mark': 88.0}
      ],
      'created_at': '2025-10-22T17:00:00Z'
    },
    {
      'ID': 7,
      'name': 'Business Case Study',
      'appointment_id': 8,
      'material': 'Business',
      'max_mark': 50.0,
      'students': [
        {'student_id': 2, 'name': 'Jane Smith', 'mark': 44.0},
        {'student_id': 9, 'name': 'Khaled Nassar', 'mark': 48.0}
      ],
      'created_at': '2025-10-25T13:30:00Z'
    },
    {
      'ID': 8,
      'name': 'Biology Practical',
      'appointment_id': 9,
      'material': 'Biology',
      'max_mark': 30.0,
      'students': [
        {'student_id': 5, 'name': 'Omar Adel', 'mark': 28.0},
        {'student_id': 12, 'name': 'Noha Samir', 'mark': 27.0}
      ],
      'created_at': '2025-10-26T08:00:00Z'
    }
  ];

  // Helper methods for managing mock data
  static int getNextId() {
    int maxId = 0;
    for (var list in [students, teachers, appointments, quizzes, attendance]) {
      for (var item in list) {
        try {
          if (item['ID'] is int && item['ID'] > maxId) {
            maxId = item['ID'] as int;
          }
        } catch (_) {}
      }
    }
    return maxId + 1;
  }

  static void addStudent(Map<String, dynamic> student) {
    if (!student.containsKey('ID')) {
      student['ID'] = getNextId();
    }
    students.add(student);
  }

  static void addTeacher(Map<String, dynamic> teacher) {
    if (!teacher.containsKey('ID')) {
      teacher['ID'] = getNextId();
    }
    teachers.add(teacher);
  }

  static void addAppointment(Map<String, dynamic> appointment) {
    if (!appointment.containsKey('ID')) {
      appointment['ID'] = getNextId();
    }
    appointments.add(appointment);
  }

  static void addQuiz(Map<String, dynamic> quiz) {
    if (!quiz.containsKey('ID')) {
      quiz['ID'] = getNextId();
    }
    quizzes.add(quiz);
  }

  static void addAttendance(Map<String, dynamic> att) {
    if (!att.containsKey('ID')) {
      att['ID'] = getNextId();
    }
    attendance.add(att);
  }

  static void resetData() {
    attendance.clear();
    students.clear();
    teachers.clear();
    appointments.clear();
    quizzes.clear();
  }

  // Authentication mock data
  static final Map<String, dynamic> academyData = {
    'role': 'academy',
    'name': 'Academy Admin',
  };

  static final Map<String, dynamic> teacherData = {
    'role': 'teacher',
    'name': 'Teacher User',
    'teacher_id': 1,
  };

  static final Map<String, dynamic> studentData = {
    'role': 'student',
    'name': 'Student User',
    'student_id': 1,
  };
}
