// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'mock_data.dart';

class MockDebugMenu extends StatefulWidget {
  const MockDebugMenu({super.key});

  @override
  _MockDebugMenuState createState() => _MockDebugMenuState();
}

class _MockDebugMenuState extends State<MockDebugMenu> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return Positioned(
        bottom: 16,
        right: 16,
        child: FloatingActionButton(
          mini: true,
          backgroundColor: Colors.grey.withOpacity(0.7),
          child: const Icon(Icons.bug_report),
          onPressed: () {
            setState(() {
              _isExpanded = true;
            });
          },
        ),
      );
    }

    return Positioned(
      bottom: 16,
      right: 16,
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 250,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Mock Data Controls',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              _buildActionButton(
                'Reset Data',
                () {
                  MockData.resetData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mock data has been reset'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                'Load Large Dataset',
                () {
                  // TODO: Implement loading larger dataset
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Loading large dataset...'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildActionButton(
                'Simulate Network Delay',
                () {
                  // TODO: Implement network delay toggle
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Network delay simulation toggled'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
