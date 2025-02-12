// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Controller/user_controller.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/Model/customer.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';
import 'package:mscl_user/View/Screens/mapscreen.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/View/widgets/textfield.dart';
import 'package:mscl_user/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScreen extends StatefulWidget {
  final Object? arugment;
  const EditScreen({super.key, this.arugment});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();
  TextEditingController lon = TextEditingController();
  TextEditingController lat = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  Future<void> _editprofile(
    String username,
    String address,
    String pincode,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await http.post(
      Uri.parse(ApiUrl.editprof(customer.publicUserId!)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'public_user_name': username,
        'address': address,
        'pincode': pincode,
        'verification_status': "verified",
        'user_status': true,
        'role': "user"
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Update profile successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      editprofile(lat.text, lon.text);
      userController.fetchUserData();
      Navigator.pushNamedAndRemoveUntil(
          context, AppPageNames.homeScreen, (route) => false);
    } else {
      Fluttertoast.showToast(
        msg: "Failed to Update Profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> editprofile(String lat, String lon) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    final response = await http.post(
      Uri.parse(ApiUrl.editaddresslatlon(customer.publicUserId!)),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'lon': lon,
        'lat': lat,
      }),
    );

    if (response.statusCode == 200) {
    } else {}
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  final CustomerCurrentUser _customerController =
      Get.put(CustomerCurrentUser());
  User userController = Get.put(User());
  CustomerModel customer = CustomerModel();

  void setChatScreenParameter(Object? argument) {
    if (argument != null && argument is CustomerModel) {
      customer = argument;
    }
  }

  @override
  void initState() {
    determinePosition();
    _customerController.getUserInfo();
    setChatScreenParameter(widget.arugment);
    _usernameController.text = customer.publicUserName.toString();
    _addressController.text = customer.address.toString();
    _pincodeController.text = customer.pincode.toString();
    _locationcontroller.text = 
      (customer.lat!.isNotEmpty && customer.lon!.isNotEmpty) 
      ? 'Lat: ${customer.lat}, Lon: ${customer.lon}' 
      : '';

    super.initState();
  }

  LatLng? selectedLocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppPageNames.homeScreen);
                    },
                    style: IconButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 215, 229, 241),
                        padding: const EdgeInsets.only(left: 9)),
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    )),
                const SizedBox(
                  width: 10,
                ),
                // Text(
                //   AppLocalizations.of(context)!.editprofile,
                //   style: const TextStyle(
                //       fontWeight: FontWeight.w500, fontSize: 18),
                // ),
                 if (customer.address?.isNotEmpty == true &&
        customer.pincode?.isNotEmpty == true &&
        customer.lat?.isNotEmpty == true &&
        customer.publicUserName?.isNotEmpty == true)
      Text(
        AppLocalizations.of(context)!.editprofile,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
    if (customer.address?.isEmpty != false || 
        customer.pincode?.isEmpty != false || 
        customer.lat?.isEmpty != false || 
        customer.publicUserName?.isEmpty != false)
      const Text(
        "Complete details",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    hinttext: customer.publicUserName ?? "Name",
                    controller: _usernameController,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                    const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText:  (customer.address != null && customer.address!.isNotEmpty)
        ? customer.address
        : "Address",
                      hintStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                    
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(
                      hintText:  (customer.pincode != null && customer.pincode!.isNotEmpty)
        ? customer.pincode
        : "pincode",
                      hintStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a pincode';
                      } else if (value.length != 6) {
                        return 'Pincode must be 6 digits';
                      }
                      return null;
                    },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _locationcontroller,
                    decoration: InputDecoration(
                        hintText: (customer.lat !.isNotEmpty && customer.lon !.isNotEmpty)
        ? 'Lat: ${customer.lat}, Lon: ${customer.lon}'
        : "Enter your location",
                      hintStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(0, 0, 0, 0.1), width: 2.0)),
                    ),
                    readOnly: true,
                    onTap: () async {
                 
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(
                            lat: customer.lat!,
                            lon: customer.lon!,
                          ),
                        ),
                      );

                      if (result != null && result is LatLng) {
                        setState(() {
                          selectedLocation = result;
                          _locationcontroller.text =
                              'Lat: ${result.latitude}, Lon: ${result.longitude}';
                          lon.text = '${result.longitude}';
                          lat.text = '${result.latitude}';
                        });
                      }
                    },
                    validator: (value) {
                      if (_locationcontroller.text.isEmpty) {
                        return 'Please mark location';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(
                    height: 300,
                  ),
                  Center(
                      child: CustomFillButton(
                          buttontext: AppLocalizations.of(context)!.updateprof,
                          buttoncolor: maincolor,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _editprofile(
                                  _usernameController.text,
                                  _addressController.text,
                                  _pincodeController.text);
                            } else if (_addressController.text.isEmpty ||
                                _locationcontroller.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: "Please to fill the details",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            }else{
                                Fluttertoast.showToast(
                                  msg: "Please to fill all the details",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white);
                            }
                          },
                          minimumSize: const Size(301, 54),
                          buttontextsize: 20)),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
