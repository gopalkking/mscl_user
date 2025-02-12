import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  const CustomTextField({super.key, required this.hinttext, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
                                
                                    controller: controller ,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: hinttext,
                                      hintStyle: const TextStyle(
                                          color: Colors.black,
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
                                  );
  }
}