// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? initialValue;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool readonly;
  final String? hintText;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.initialValue = "",
    required this.keyboardType,
    this.obscureText = false,
    required this.onChanged,
    required this.validator,
    this.hintText = "",
    this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.readonly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        controller: controller,
        readOnly: readonly,
        focusNode: focusNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: onEditingComplete,
        decoration: InputDecoration(
          hintStyle: const TextStyle(
              color: Color.fromARGB(255, 30, 54, 78),
              fontSize: 16,
              overflow: TextOverflow.visible),
          hintText: hintText,
          labelText: labelText,
          filled: true,
          fillColor: const Color.fromARGB(60, 147, 147, 147),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          alignLabelWithHint: true,
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 30, 54, 78),
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.visible),
        ),
        style: const TextStyle(
            color: Color.fromARGB(255, 30, 54, 78),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.visible),
      ),
    );
  }
}
