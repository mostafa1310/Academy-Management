// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api

import 'package:flutter/material.dart';

class Test_navigation extends StatefulWidget {
  const Test_navigation({super.key});

  @override
  _Test_navigationState createState() => _Test_navigationState();
}

class _Test_navigationState extends State<Test_navigation> {
  int _currentIndex = 0;

  // List of screens corresponding to each tab
  final List<Widget> _screens = [
    const AddStudentScreen(),
    const AttendanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Title'),
        backgroundColor: const Color(0xFF0056A6), // Customize the AppBar color
      ),
      body: _screens[_currentIndex], // Display the selected screen

      // Option 1: Standard BottomNavigationBar with Customization
      /*
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Add Student',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Attendance',
          ),
        ],
        backgroundColor: Color(0xFFE0E0E0), // Customize the background color
        selectedItemColor: Color(0xFF0056A6), // Customize the selected item color
        unselectedItemColor: Colors.grey, // Customize the unselected item color
        selectedFontSize: 14,
        unselectedFontSize: 12,
      ),
      */

      // Option 2: Custom BottomAppBar with InkWell Widgets
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFE0E0E0), // Background color of the BottomAppBar
        shape: const CircularNotchedRectangle(), // Optional notch
        notchMargin: 8.0, // Margin around the notch (if any)
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person_add_alt_1,
                    color: _currentIndex == 0
                        ? const Color(0xFF0056A6)
                        : Colors.grey,
                  ),
                  Text(
                    'Add Student',
                    style: TextStyle(
                      color: _currentIndex == 0
                          ? const Color(0xFF0056A6)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: _currentIndex == 1
                        ? const Color(0xFF0056A6)
                        : Colors.grey,
                  ),
                  Text(
                    'Attendance',
                    style: TextStyle(
                      color: _currentIndex == 1
                          ? const Color(0xFF0056A6)
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the floating button
        },
        backgroundColor: const Color(0xFF0056A6),
        child: const Icon(Icons.add), // Customize the button color
      ),
    );
  }
}

class AddStudentScreen extends StatelessWidget {
  const AddStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Add Student Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Attendance Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
