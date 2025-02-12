// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/Model/customer.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:mscl_user/User%20preferences/user_prefernces.dart';
import 'package:mscl_user/View/Screens/inital__screen.dart';

class User extends GetxController {
 
  var isLoading = true.obs;
  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }
  Future<bool> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
      final userid = prefs.getString('userId');
    final response = await http.get(
      Uri.parse(ApiUrl.getuserdat(userid!)),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);

      // Decryption key and IV
      final key = encrypt.Key.fromBase16('9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
      final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      
        // Decrypt the encrypted data
        final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
        final decryptedData = encrypter.decrypt(encryptedData, iv: iv);
        // Convert the decrypted data to JSON
        var jsonData = jsonDecode(decryptedData);
        CustomerModel customerInfo = CustomerModel.fromJson(jsonData);
        await RememberUserPrefs.saveRememberUser(customerInfo);
        return true;
    } else {
      print('Failed to fetch user data: ${response.statusCode}');
      return false;
    }
  
}


Future<void> checkCustomerAddress(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  final userid = prefs.getString('userId');

  // Fetch user data directly from API
  final response = await http.get(
    Uri.parse(ApiUrl.getuserdat(userid!)),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);

    // Decryption key and IV
    final key = encrypt.Key.fromBase16('9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
    final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    try {
      // Decrypt the encrypted data
      final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
      final decryptedData = encrypter.decrypt(encryptedData, iv: iv);

      // Convert the decrypted data to JSON
      var jsonData = jsonDecode(decryptedData);

      // Check if the address is empty
      final address = jsonData['address'];
      if (address == null || address.isEmpty) {
        print('Address is empty: $address');
 
        // Navigate to InitialScreen if the address is empty
        Future.microtask(() {
          Navigator.pushReplacement(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const InitialScreen()),
          );
        });
      } else {
        print('Customer address is set: $address');
      }
    } catch (e) {
      print('Decryption failed: $e');
    }
  } else {
    print('Failed to fetch user data: ${response.statusCode}');
  }
}

  
}
