
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mscl_user/Controller/update_address_lat_lon.dart';
import 'package:mscl_user/Controller/user_controller.dart';
import 'package:mscl_user/Model/customer.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/View/Screens/mapscreen.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/color.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
    final TextEditingController _addressController = TextEditingController();
  final TextEditingController _locationcontroller = TextEditingController();
  TextEditingController lon = TextEditingController();
  TextEditingController lat = TextEditingController();
    final CustomerCurrentUser _customerController =
      Get.put(CustomerCurrentUser());
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
      User userController = Get.put(User());
      UpdateAddressLatLon updateAddressLatLon = Get.put(UpdateAddressLatLon());
  CustomerModel customer = CustomerModel();
  
     
    
  // Future<void> editprofile(String userid,String adddress,String lat, String lon) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('authToken');

  //   final response = await http.post(
  //     Uri.parse(ApiUrl.editaddresslatlon(userid)),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: jsonEncode({
  //       'address':adddress,
  //       'lon': lon,
  //       'lat': lat,
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //    final fetcheduserdata = await userController.fetchUserData();
  //     if (fetcheduserdata) {
  //      Navigator.pushNamedAndRemoveUntil(
  //                     context,
  //                     AppPageNames.homeScreen,
  //                     (route) => false,
  //                   );
  //     }
  //      Fluttertoast.showToast(
  //       msg: "Update profile successfully",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //     );
  //   } else {
  //      Fluttertoast.showToast(
  //       msg: "Failed to Update Profile",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //     );
  //   }
  // }

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
  
  LatLng? selectedLocation;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 50),
            child: Row(
              children: [
                // IconButton(
                //     onPressed: () {
                //      Navigator.pop(context);
                //     },
                //     style: IconButton.styleFrom(
                //         backgroundColor:
                //             const Color.fromARGB(255, 215, 229, 241),
                //         padding: const EdgeInsets.only(left: 9)),
                //     icon: const Icon(
                //       Icons.arrow_back_ios,
                //     )),
                SizedBox(
                  width: 10,
                ),
                // Text(
                //   AppLocalizations.of(context)!.editprofile,
                //   style: const TextStyle(
                //       fontWeight: FontWeight.w500, fontSize: 18),
                // ),
      Text(
        "Complete details",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26,
        ),
      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: FutureBuilder(
                  future:  _customerController.getUserInfo(),
                builder: (context,snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // CustomTextField(
                      //   hinttext: customer.publicUserName ?? "Name",
                      //   controller: _usernameController,
                      // )
                       const Text(
        "Address",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 5,),

                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          hintText:  "Address",
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
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address';
                          }
                          return null;
                        },
                        
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                             const Text(
        "Location",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 5,),
                      TextFormField(
                        controller: _locationcontroller,
                        decoration: InputDecoration(
                            hintText: "Enter your location",
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
                              builder: (context) => const MapScreen(
                                lat: '',
                                lon: '',
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
                              buttontext: "Submit",
                              buttoncolor: maincolor,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  updateAddressLatLon.editprofile(context,lat.text, _addressController.text, lon.text);
                                  // editprofile(_customerController.customer.publicUserId!,
                                  //     _addressController.text,
                                  //     lat.text,lon.text);
                                } else if (_addressController.text.isEmpty ||
                                    _locationcontroller.text.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: "Please to fill address and location the details",
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
                  );
                }
                }
              ),
            ),
          ),
        ],
      )),
    );
  }
}