// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final ValueChanged<T?>? onSaved;
  final FormFieldValidator<T>? validator;
  final String labelText;
  final String? disabledHint;
  final bool? isExpanded;
  final bool? isDense;

  const CustomDropdownFormField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.labelText,
    this.onSaved,
    this.disabledHint = "Disabled",
    this.validator,
    this.isExpanded,
    this.isDense,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DropdownButtonFormField<T>(
        // icon: Icon(
        //   size: 24.0, // Adjust the size of the icon
        //   Icons.arrow_drop_down,
        //   color: Colors.grey[850],
        // ),
        // iconSize: 24.0, // Also set the size of the dropdown icon
        value: value,
        icon: null,
        iconSize: 0,
        style: const TextStyle(
          color: Color.fromARGB(255, 30, 54, 78),
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
        ),
        selectedItemBuilder: (BuildContext context) {
          return items
              .map<Widget>(
                (T value) => Text(
                  value.toString(),
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 30, 54, 78),
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList();
        },
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey[850],
            size: 50.0, // Increase the size of the icon here
          ),
          // contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          filled: true,
          fillColor: const Color.fromARGB(60, 147, 147, 147),
          labelText: labelText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          labelStyle: const TextStyle(
              color: Color.fromARGB(255, 30, 54, 78),
              fontWeight: FontWeight.bold),
        ),
        items: items.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Color.fromARGB(255, 30, 54, 78),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          );
        }).toList(),
        disabledHint: Text(
          disabledHint!,
          style: const TextStyle(
            color: Color.fromARGB(255, 30, 54, 78),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        onChanged: onChanged,
        onSaved: onSaved,
        validator: validator,
        isDense: isDense ?? true,
        isExpanded: isExpanded ?? false,
      ),
    );
  }
}
