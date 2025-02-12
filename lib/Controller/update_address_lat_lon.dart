// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Controller/user_controller.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';
class UpdateAddressLatLon extends GetxController {
      User userController = Get.put(User());
  final CustomerCurrentUser customerController = Get.put(CustomerCurrentUser());

  Future<bool> editprofile(BuildContext context,String lat, String address, String lon) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await http.post(
      Uri.parse(ApiUrl.editaddresslatlon(customerController.customer.publicUserId!)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'address': address,
        'lon': lon,
        'lat': lat,
      }),
    );

    if (response.statusCode == 200) {
       final fetcheduserdata = await userController.fetchUserData();
      if (fetcheduserdata) {
       Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppPageNames.homeScreen,
                      (route) => false,
                    );
      }
      Fluttertoast.showToast(
        msg: "Update profile successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "Failed to Update Profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false; // Failure
    }
  }
}
