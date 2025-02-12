// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/color.dart';
class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
 final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;
  String? passwordErrorText;

  @override
  void initState() {
    super.initState();

    _confirmPasswordController.addListener(() {
      _validatePasswords();
    });
  }

  void _validatePasswords() {
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      if (confirmPassword.isNotEmpty && newPassword != confirmPassword) {
        passwordErrorText = "Passwords do not match";
      } else {
        passwordErrorText = null;
      }
    });
  }
  String? _validatePasswordStrength(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a password';
  } else if (value.length < 8) {
    return 'Password must be at least 8 characters long';
  } else if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
    return 'Password must contain at least one uppercase letter';
  } else if (!RegExp(r'(?=.*?[a-z])').hasMatch(value)) {
    return 'Password must contain at least one lowercase letter';
  } else if (!RegExp(r'(?=.*?[0-9])').hasMatch(value)) {
    return 'Password must contain at least one digit';
  } else if (!RegExp(r'(?=.*?[!@#\$&*~])').hasMatch(value)) {
    return 'Password must contain at least one special character';
  }
  return null;
}

  Future<void> _changePassword() async {
    final oldPassword = _oldPasswordController.text;
    final newPassword = _newPasswordController.text;
    final customer = _customerController.customer;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');


    final response = await http.post(
      Uri.parse(ApiUrl.changepass(customer.phone!)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'old_password': oldPassword,
        'login_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Password changed successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      Navigator.pushNamedAndRemoveUntil(context, AppPageNames.homeScreen, (route) => false);
    } else {
      Fluttertoast.showToast(
        msg: "Failed to change password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
       
  }

  final CustomerCurrentUser _customerController = Get.put(CustomerCurrentUser());

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 215, 229, 241),
                        padding: const EdgeInsets.only(left: 9),
                      ),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      AppLocalizations.of(context)!.changepass,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500, 
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: !isPasswordVisible,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.oldpass,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                      ),
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your old password';
                      }
                      return null;
                    },
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !isPasswordVisible1,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.newpass,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible1 ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible1 = !isPasswordVisible1;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                      ),
                         validator: _validatePasswordStrength,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !isPasswordVisible2,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.confirmpass,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible2 ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible2 = !isPasswordVisible2;
                            });
                          },
                        ),
                        errorText: passwordErrorText,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                      ),
                       validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 300),
                    Center(
                      child: CustomFillButton(
                        buttontext: AppLocalizations.of(context)!.changepass,
                        buttoncolor: maincolor,
                        onPressed: (){
                                  if (formKey.currentState!.validate()) {
                                    _changePassword();
                                  }else{
                                    
                                  }
                        },
                        minimumSize: const Size(301, 54),
                        buttontextsize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}