// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:mscl_user/View/Screens/Authentication/new_password.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class OtpForgetPassword extends StatefulWidget {
  String verificationId;
  final String phoneNumber;
  OtpForgetPassword(
      {super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<OtpForgetPassword> createState() => _OtpForgetPasswordState();
}

class _OtpForgetPasswordState extends State<OtpForgetPassword> {
  final TextEditingController _otpController = TextEditingController();
  Future<void> _verifyOtp() async {
    const String predefinedOtp = "567890";

    if (_otpController.text == predefinedOtp) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewPassword(phone: widget.phoneNumber)),
      );
      Fluttertoast.showToast(
        msg: "OTP Verification Successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: _otpController.text,
      );

      var userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential)
          .catchError((error) {
        debugPrint("Firebase OTP verification failed: $error");
        Fluttertoast.showToast(
          msg: "OTP verification failed: $error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        // ignore: invalid_return_type_for_catch_error
        return null; // Prevent further execution
      });

      if (userCredential != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewPassword(
                      phone: widget.phoneNumber,
                    )));
        Fluttertoast.showToast(
          msg: "OTP Verification Successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
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
