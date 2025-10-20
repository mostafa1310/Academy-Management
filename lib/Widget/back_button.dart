import 'package:flutter/material.dart';

class Back_Button extends StatelessWidget {
  const Back_Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      left: 16,
      child: IconButton(
        icon: const Icon(Icons.arrow_back,
            color: Color.fromARGB(255, 218, 107, 50)),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
