// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/User%20preferences/token_preferance.dart';
import 'package:mscl_user/User%20preferences/user_prefernces.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';


bool isCheck = true;

class TokenManager {
  static const String _tokenTimeKey = '';

  static Future<void> saveTokenTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_tokenTimeKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenTime = prefs.getInt(_tokenTimeKey);
    if (tokenTime == null) return false;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final difference = currentTime - tokenTime;
    // print("tokenTime: $tokenTime");
    // print("difference: $difference");

    return difference < 3 * 60 * 60 * 1000;
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenTimeKey);
  }
}

class SessionExpirationHandler {
  static void startChecking(BuildContext context) {

    _checkTokenValidity(context);
    Timer.periodic(const Duration(minutes: 5), (_) => _checkTokenValidity(context));
  }

  static Future<void> _checkTokenValidity(BuildContext context) async {
    if (!await TokenManager.isTokenValid() && isCheck) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const SessionExpiredPopup(),
      );
    }
  }
}



class SessionExpiredPopup extends StatelessWidget {
  const SessionExpiredPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Session Expired'),
      content: const Text('Your session has expired. Please log in again.'),
      actions: [
        TextButton(
          child: const Text('Log In'),
          onPressed: () async{
            isCheck = false;
            TokenManager.clearToken();
           TokenManager.clearToken();
           await RememberUserPre.removeToken();
                    await RememberUserPrefs.removeUserInfo().then((value) {
                              Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppPageNames.loginScreen,
                      (route) => false,
                    );
                 });
          },
        ),
      ],
    );
  }
}