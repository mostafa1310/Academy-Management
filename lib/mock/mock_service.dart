import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:Academy_Management/mock/mock_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseService {
  static final MockSupabaseService _instance = MockSupabaseService._internal();
  User? _currentUser;

  factory MockSupabaseService() {
    return _instance;
  }

  MockSupabaseService._internal();

  User? get currentUser => _currentUser;

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final userData = {
      'aud': 'authenticated',
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch,
      'sub': 'mock-user-id',
      'email': email,
      'phone': '',
      'app_metadata': {'provider': 'email'},
      'user_metadata': email.contains('academy')
          ? MockData.academyData
          : email.contains('teacher')
              ? MockData.teacherData
              : MockData.studentData,
      'role': '',
    };

    _currentUser = User.fromJson(userData);

    final session = Session(
      accessToken: 'mock_token',
      tokenType: 'bearer',
      expiresIn: 604800, // 7 days in seconds
      refreshToken: 'mock_refresh_token',
      user: _currentUser!,
    );

    return AuthResponse(session: session);
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  Future<void> refreshSession() async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Session is always valid in mock
  }
}

// Mock service for general data operations
class MockDatabaseService {
  static final MockDatabaseService _instance = MockDatabaseService._internal();

  factory MockDatabaseService() {
    return _instance;
  }

  MockDatabaseService._internal();

  Future<List<Map<String, dynamic>>> getStudents() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.students;
  }

  Future<List<Map<String, dynamic>>> getTeachers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.teachers;
  }

  Future<List<Map<String, dynamic>>> getAppointments() async {
    await Future.delayed(const Duration(milliseconds: 500));
    debugPrint('Mock appointments data: ${MockData.appointments}');
    return MockData.appointments;
  }

  Future<List<Map<String, dynamic>>> getQuizzes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.quizzes;
  }

  Future<List<Map<String, dynamic>>> getAttendance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MockData.attendance;
  }

  Future<Map<String, dynamic>> createStudent(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final student = {
      ...data,
      'ID': MockData.getNextId(),
    };
    MockData.addStudent(student);
    return student;
  }

  Future<Map<String, dynamic>> createTeacher(Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final teacher = {
      ...data,
      'ID': MockData.getNextId(),
    };
    MockData.addTeacher(teacher);
    return teacher;
  }

  Future<String> uploadFile(String path) async {
    await Future.delayed(const Duration(seconds: 1));
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'https://local.mock/uploads/$timestamp.png';
  }
}
