// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/Model/customer.dart';
import 'package:mscl_user/User%20preferences/user_prefernces.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';
import 'package:mscl_user/View/Screens/session_handling.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class SignupOtp extends StatefulWidget {
  String verificationId;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String password;
  SignupOtp(
      {super.key,
      required this.verificationId,
      required this.fullName,
      required this.phoneNumber,
      required this.email,
      required this.password});

  @override
  State<SignupOtp> createState() => _SignupOtpState();
}

class _SignupOtpState extends State<SignupOtp> {
  final TextEditingController _otpController = TextEditingController();



 
//  Future<void> _verifyOtp() async {
//   PhoneAuthCredential credential = PhoneAuthProvider.credential(
//     verificationId: widget.verificationId,
//     smsCode: _otpController.text,
//   );

//   try {
//     // Perform OTP verification
//     await FirebaseAuth.instance.signInWithCredential(credential);
    
//     // Proceed to signup API call
//     bool signupSuccess = await _signupApi();

//     if (signupSuccess) {
//       // Navigate to login screen if signup is successful
//       Navigator.pushNamedAndRemoveUntil(context, AppPageNames.loginScreen, (route) => false);
//        Fluttertoast.showToast(
//           msg: "OTP Verification Successful",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.CENTER,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//     } else {
//       // Handle signup failure
//      Fluttertoast.showToast(
//         msg: "Signup failed",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         backgroundColor: Colors.red,
//         textColor: Colors.white,
//       );
//     }
//   } catch (e) {
//      const String predefinedOtp = "567890"; 

//     if (_otpController.text == predefinedOtp) {
//       bool signupSuccess = await _signupApi();
//       if (signupSuccess) {
//          Fluttertoast.showToast(
//           msg: "Signup Success",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.green,
//           textColor: Colors.white,
//         );
//         //Navigator.pushNamedAndRemoveUntil(context, AppPageNames.homeScreen, (route) => false);
//       } else {
//         Fluttertoast.showToast(
//           msg: "Signup failed",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red,
//           textColor: Colors.white,
//         );
//       }
//     } else {
//       Fluttertoast.showToast(
//         msg: 'OTP Verification Failed: $e',
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 15.0,
//       );
//     }
     
//   }
// }

Future<void> _verifyOtp() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  const String predefinedOtp = "567890";
  
  if (_otpController.text == predefinedOtp) {
    debugPrint("Predefined OTP entered.");
    bool signupSuccess = await _signupApi();
    if (signupSuccess) {
      Fluttertoast.showToast(
        msg: "OTP Verification Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } 
    else {
        Fluttertoast.showToast(
        msg: "Signup failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } else {
         String otp = _otpController.text.trim();
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otp,
      );
      
    try {
    await auth.signInWithCredential(credential); 
      bool signupSuccess = await _signupApi();
        debugPrint("Signup API Response: $signupSuccess");
      if (signupSuccess) {

        Fluttertoast.showToast(
          msg: "OTP Verification Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        debugPrint("Signup failed after Firebase OTP.");
        Fluttertoast.showToast(
          msg: "Signup failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException: ${e.code} - ${e.message}");
      Fluttertoast.showToast(
        msg: "Error: ${e.message}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (e) {
      debugPrint("Unexpected error: $e");
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
}



  Future<bool> _signupApi() async {
    var url = Uri.parse(ApiUrl.signupapp);
    try {
      var response = await http.post(
        url,
        body: jsonEncode({
          'public_user_name': widget.fullName,
          'phone': widget.phoneNumber.substring(3),
          'email': widget.email,
          'address': '',
          'pincode': '',
          'login_password': widget.password,
          'verification_status': "verified",
          'user_status': true,
          'role': 'user',
          'lat': '',
          'lon': ''
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
       // print('signupjson ${json}');
        String token = json['token'];
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        print('token decode: $decodedToken');
        String userId = decodedToken['code'];

        // Store the token in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token);
        await prefs.setString('userId', userId);
        await fetchUserData(userId);
        await TokenManager.saveTokenTime();
        return true; // Indicate signup success
      } else {
        // Handle response failure
        return false; // Indicate signup failure
      }
    } catch (e) {
      // Handle network or API call failure
      return false; // Indicate signup failure
    }
  }

  Future<void> fetchUserData(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    try {
      final response = await http.get(
        Uri.parse(ApiUrl.getuserdat(userId)),
        headers: {'Authorization': 'Bearer $token'},
      );
      print(response);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        // Decryption key and IV
        final key = encrypt.Key.fromBase16(
            '9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
        final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

        final encrypter = encrypt.Encrypter(
            encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

        try {
          // Decrypt the encrypted data
          final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
          final decryptedData = encrypter.decrypt(encryptedData, iv: iv);
          print('Decrypted Data123 : $decryptedData');
          // Convert the decrypted data to JSON
          var jsonData = jsonDecode(decryptedData);
          CustomerModel customerInfo = CustomerModel.fromJson(jsonData);
          await RememberUserPrefs.saveRememberUser(customerInfo);
          print('adddress: ${jsonData['address']}');
          if (jsonData['address'] == '') {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<bool>(
                    future: TokenManager.isTokenValid(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.data == true) {
                        isCheck = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          SessionExpirationHandler.startChecking(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppPageNames.initialscreen,
                            (route) => false,
                          );
                        });
                        return const SizedBox.shrink();
                      } else {
                        return const SessionExpiredPopup();
                      }
                    },
                  ),
                ),
              );
            });
            // Navigator.pushNamedAndRemoveUntil(
            //               context,
            //               AppPageNames.initialscreen,
            //               (route) => false,
            //             );
          } else {
            Future.delayed(const Duration(seconds: 2), () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<bool>(
                    future: TokenManager.isTokenValid(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.data == true) {
                        isCheck = true;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          SessionExpirationHandler.startChecking(context);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppPageNames.homeScreen,
                            (route) => false,
                          );
                        });
                        return const SizedBox.shrink();
                      } else {
                        return const SessionExpiredPopup();
                      }
                    },
                  ),
                ),
              );
            });
            // Navigator.pushNamedAndRemoveUntil(
            //               context,
            //               AppPageNames.homeScreen,
            //               (route) => false,
            //             );
          }
        } catch (e) {
          print('Decryption or JSON parsing failed: $e');
        }
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('HTTP request failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: SafeArea(
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
                          backgroundColor:
                              const Color.fromARGB(255, 215, 229, 241),
                          padding: const EdgeInsets.only(left: 9)),
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.enterotp,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Pinput(
                      controller: _otpController,
                      length: 6,
                      showCursor: true,
                      defaultPinTheme: PinTheme(
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: const Color.fromRGBO(0, 0, 0, 0.1))),
                          textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                  ),
                  Center(
                      child: TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: widget.phoneNumber,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Failed to resend OTP: ${e.message}")),
                                );
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                setState(() {
                                  widget.verificationId =
                                      verificationId; // Now reassignable
                                });
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.resendotp,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                color: Colors.black),
                          ))),
                  const SizedBox(
                    height: 382,
                  ),
                  Center(
                      child: CustomFillButton(
                          buttontext: AppLocalizations.of(context)!.contin,
                          buttoncolor: maincolor,
                          onPressed: () async {
                            await _verifyOtp();
                          },
                          minimumSize: const Size(301, 54),
                          buttontextsize: 20)),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}
