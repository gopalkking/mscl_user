import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String labelText;
  final String? value;
 final ValueChanged<String?> onChanged;
  final List<String> items;
  const DropdownWidget({super.key,required this.labelText, this.value,required this.onChanged, required this.items});

  @override
  Widget build(BuildContext context) {
      final uniqueItems = items.toSet().toList();
    if (value != null && !uniqueItems.contains(value)) {
      // print('Value "$value" not found in unique items list.');
    }
    return DropdownButtonFormField<String>(
            decoration:  InputDecoration(
              labelText:labelText,
               hintStyle: const TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.1),
                                              width: 2.0)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: const BorderSide(
                                              color:
                                                Color.fromRGBO(0, 0, 0, 0.1),
                                             width: 2.0)),
            ),
          value: uniqueItems.contains(value) ? value : null, // Handle missing value
      onChanged: onChanged,
      items: uniqueItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
          );
  }
}