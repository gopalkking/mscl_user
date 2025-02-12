import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';
import 'package:mscl_user/View/Screens/Authentication/otp_signup.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
   bool _showPrefixIcon = true;
   bool _showPrefixIcon1 = true;
   bool _showPrefixIcon2 = true;
   bool _showPrefixIcon3 = true;
   final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController =
      TextEditingController(text: "+91"); // Set initial country code
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
    final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
   bool _isPasswordVisible = false;
   bool _isConfirmPasswordVisible = false;
    String? passwordErrorText;
   @override
  void initState() {
    super.initState();

    _confirmPasswordController.addListener(() {
      _validatePasswords();
    });
  }

  void _validatePasswords() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      if (confirmPassword.isNotEmpty && password != confirmPassword) {
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



  Future<void> _sendOtp() async {
      
    String phoneNumber = _phoneNumberController.text.trim();
    FirebaseAuth auth = FirebaseAuth.instance;

    setState(() {
      _isLoading = true;
    });

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to send OTP: ${e.message}")),
        );
        setState(() {
          _isLoading = false;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _isLoading = false;
        });
       Navigator.push(context, MaterialPageRoute(builder: (context) => SignupOtp(verificationId: verificationId, fullName: _fullNameController.text.trim(), phoneNumber: phoneNumber, email: _emailController.text.trim(), password: _passwordController.text.trim(),)));
    },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
       
 }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false ,
      backgroundColor: backgroundColor,
      body: SafeArea(child:Column(
           crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.all(8),
            child: Row(children: [
              IconButton(onPressed: (){
          Navigator.pop(context);
         },style: IconButton.styleFrom(
           backgroundColor: const Color.fromARGB(255, 215, 229, 241),
           padding:  const EdgeInsets.only(left: 9)
         ), icon: const Icon(Icons.arrow_back_ios,)),
            ],),
            ),
            const SizedBox(height: 10,),
             Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(AppLocalizations.of(context)!.signup,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
                  const SizedBox(height: 20,),
                  TextFormField(
                                    controller: _fullNameController,
                                      onChanged: (value) {
                                        setState(() {
                                          _showPrefixIcon = value.isEmpty;
                                        });
                                      },
                                      style: const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        prefixIcon: _showPrefixIcon
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 14, vertical: 16),
                                                child: RichText(
                                                  text:  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.fullname,
                                                        style: const TextStyle(
                                                            color: Colors.black),
                                                      ),
                                                      const TextSpan(
                                                        text: '*',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : null,
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
                                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Please enter Fullname';
                                } else if (RegExp(
                                r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+ [A-Za-z]+\.?\s*$")
                            .hasMatch(value)){
                                  return 'Enter Correct Fullname';
                                } else {
                                  return null;
                                }
                              },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                    ),
                                    const SizedBox(height: 14.0),
                              TextFormField(
  controller: _phoneNumberController,
  keyboardType: TextInputType.phone,
  style: const TextStyle(color: Colors.black),
  onChanged: (value) {
    setState(() {
      _showPrefixIcon1 = value.isEmpty;
    });
  },
  inputFormatters: [
    LengthLimitingTextInputFormatter(13), 
  ],
  decoration: InputDecoration(
    prefixIcon: _showPrefixIcon1
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.phonenum,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          )
        : null,
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
      return 'Please enter your phone number';
    } else if (value.length != 13) {
      return 'Phone number must be 10 digits';
    }
    return null;
  },
   autovalidateMode: AutovalidateMode.onUserInteraction,
),
                                    const SizedBox(height: 14.0),
                   TextFormField(
                                    controller: _emailController,
                                   onChanged: (value) {
                                        setState(() {
                                          _showPrefixIcon2 = value.isEmpty;
                                        });
                                      },
                                      style: const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        prefixIcon: _showPrefixIcon2
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 14, vertical: 16),
                                                child: RichText(
                                                  text:  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.emailid,
                                                        style: const TextStyle(
                                                            color: Colors.black),
                                                      ),
                                                      const TextSpan(
                                                        text: '*',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : null,
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
                                     validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      final emailRegex = RegExp(
                                          r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                  ),
                  const SizedBox(height: 14,),
                  TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                         onChanged: (value) {
                                        setState(() {
                                          _showPrefixIcon3 = value.isEmpty;
                                        });
                                      },
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                       // hintText: AppLocalizations.of(context)!.password,
                         prefixIcon: _showPrefixIcon3
                                            ? Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 14, vertical: 16),
                                                child: RichText(
                                                  text:  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: AppLocalizations.of(context)!.password,
                                                        style: const TextStyle(
                                                            color: Colors.black),
                                                      ),
                                                      const TextSpan(
                                                        text: '*',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0),
                        ),
                      ),
                      validator: _validatePasswordStrength,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isConfirmPasswordVisible,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.confirmpass,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        errorText: passwordErrorText,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0),
                        ),
                      ),
                         validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  const SizedBox(height: 150,),
                        
                  Center(child: _isLoading
                          ? const CircularProgressIndicator()
                          : CustomFillButton(buttontext: AppLocalizations.of(context)!.sendotp, buttoncolor: maincolor,
                           onPressed:  (){
                               if (_formKey.currentState!.validate()) {
                                _sendOtp();
                               }
                           }, minimumSize: const Size(301, 54), buttontextsize: 20)),
                  const SizedBox(height: 5,),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                         Text(
                          AppLocalizations.of(context)!.alreadyacc,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                             Navigator.pushNamed(context, AppPageNames.loginScreen);
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen()));
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.login,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ]),
                  ],
                ),
              ),
            ),
            
          ],
        )),
    );
  }
}