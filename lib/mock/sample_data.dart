// ignore_for_file: non_constant_identifier_names

class MockData {
  static Map<String, dynamic> studentData = {
    "ID": 1001,
    "name": "John Doe",
    "email": "john.doe@example.com",
    "role": "Student",
    "courses": ["Mathematics", "Physics", "Chemistry"]
  };

  static Map<String, dynamic> teacherData = {
    "ID": 2001,
    "name": "Jane Smith",
    "email": "jane.smith@example.com",
    "role": "Teacher",
    "subjects": ["Mathematics", "Physics"]
  };

  static Map<String, dynamic> academyData = {
    "name": "Demo Academy",
    "email": "admin@academy.example.com",
    "role": "Academy"
  };

  static List<Map<String, dynamic>> students = [
    {
      "ID": 1001,
      "name": "John Doe",
      "email": "john.doe@example.com",
    },
    {
      "ID": 1002,
      "name": "Alice Johnson",
      "email": "alice@example.com",
    }
  ];

  static List<Map<String, dynamic>> teachers = [
    {
      "ID": 2001,
      "name": "Jane Smith",
      "email": "jane.smith@example.com",
    },
    {
      "ID": 2002,
      "name": "Bob Wilson",
      "email": "bob@example.com",
    }
  ];

  static List<Map<String, dynamic>> appointments = [
    {
      "ID": 3001,
      "title": "Mathematics Class",
      "teacher_id": 2001,
      "date": "2025-10-21",
      "time": "10:00 AM"
    },
    {
      "ID": 3002,
      "title": "Physics Lab",
      "teacher_id": 2002,
      "date": "2025-10-22",
      "time": "2:00 PM"
    }
  ];

  static List<Map<String, dynamic>> attendance = [
    {
      "appointment_id": 3001,
      "student_id": 1001,
      "date": "2025-10-21",
      "status": "present"
    },
    {
      "appointment_id": 3001,
      "student_id": 1002,
      "date": "2025-10-21",
      "status": "absent"
    }
  ];

  static List<Map<String, dynamic>> quizzes = [
    {
      "ID": 4001,
      "title": "Mathematics Quiz 1",
      "appointment_id": 3001,
      "questions": [
        {
          "question": "What is 2 + 2?",
          "options": ["3", "4", "5", "6"],
          "correct_answer": "4"
        }
      ]
    }
  ];

  // In-memory data manipulation methods
  static int _nextId = 5001;

  static int getNextId() {
    return _nextId++;
  }

  static void addStudent(Map<String, dynamic> student) {
    students.add(student);
  }

  static void addTeacher(Map<String, dynamic> teacher) {
    teachers.add(teacher);
  }

  static void addAppointment(Map<String, dynamic> appointment) {
    appointments.add(appointment);
  }

  static void addQuiz(Map<String, dynamic> quiz) {
    quizzes.add(quiz);
  }

  static void addAttendance(Map<String, dynamic> record) {
    attendance.add(record);
  }

  static void resetData() {
    _nextId = 5001;
    // Reset all lists to their initial state
    // Implementation would restore the original mock data
  }
}
