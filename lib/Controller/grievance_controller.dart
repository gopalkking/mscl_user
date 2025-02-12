import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/Model/complaint_model.dart';
import 'package:mscl_user/Model/complaint_type.dart';
import 'package:mscl_user/Model/department_type.dart';
import 'package:mscl_user/Model/street_model.dart';
import 'package:mscl_user/Model/ward_model.dart';
import 'package:mscl_user/Model/zone_model.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';

class GrievanceController extends GetxController{

final CustomerCurrentUser customerController = Get.put(CustomerCurrentUser());

Future<List<ComplaintType>> getAllComplaintTypes() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse(ApiUrl.complaintType),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);
       
        return decryptedJsonList.map((item) => ComplaintType.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Decryption failed: $e');
      }
    } else {
      throw Exception('Failed to load complaint types');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<Department>> getAllDepartment() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse(ApiUrl.department),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);

        return decryptedJsonList.map((item) => Department.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Decryption failed: $e');
      }

    } else {
      throw Exception('Failed to load complaint types');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<ComplaintModel>> getAllComplaint() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse(ApiUrl.complaint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);
        return decryptedJsonList.map((item) => ComplaintModel.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Decryption failed: $e');
      }
    } else {
      throw Exception('Failed to load complaint types');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}


Future<List<ZoneModel>> getZone() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse(ApiUrl.zone),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);
        return decryptedJsonList.map((item) => ZoneModel.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Decryption failed: $e');
      }
    } else {
      throw Exception('Failed to load complaint types');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<WardModel>> getWard() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse(ApiUrl.ward),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);

        return decryptedJsonList.map((item) => WardModel.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Decryption failed: $e');
      }
    } else {
      throw Exception('Failed to load complaint types');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<StreetModel>> getStreet() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse(ApiUrl.street),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);
        return decryptedJsonList.map((item) => StreetModel.fromJson(item)).toList();
      } catch (e) {
        throw Exception('Decryption failed: $e');
      }
    } else {
      throw Exception('Failed to load complaint types');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future grievancePost(
  BuildContext context,
  String complainttypetitle,
  String deptname,
  String zonename,
  String wardname,
  String streetname,
  String pincode,
  String complaintaddress,
  String complaint,
  String complaintdetails,
  String priority,
  String lon,
  String lat,
) async {
  var body = { 
    "grievance_mode": "Mobile",
    "complaint_type_title": complainttypetitle,
    "dept_name": deptname,
    "zone_name": zonename,
    "ward_name": wardname,
    "street_name": streetname,
    "pincode": pincode,
    "complaintaddress":complaintaddress,
    "complaint": complaint,
    "complaint_details": complaintdetails,
    "public_user_id": customerController.customer.publicUserId,
    "public_user_name": customerController.customer.publicUserName,
    "phone": customerController.customer.phone,
    "priority": priority,
    "lon":lon,
    "lat":lat,
  };
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  
  var response = await http.post(
    Uri.parse(ApiUrl.grievance),
    body: jsonEncode(body),
    headers: {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    },
  );

  // print("username: ${customerController.customer.publicUserId} ");
  //  print("public username: ${customerController.customer.publicUserName} ");
  //   print("phone: ${customerController.customer.phone} ");
  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    String grievanceId = json['data']; 
    debugPrint(jsonEncode(json)); // Convert the map to a string for printing
    
    Fluttertoast.showToast(
      msg: 'Submitted Successfully',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 15.0,
    ); 
    
    // Get.toNamed(AppPageNames.homeScreen);
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, AppPageNames.homeScreen);
    return grievanceId;
  }
}


}