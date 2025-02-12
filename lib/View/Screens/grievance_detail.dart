// ignore_for_file: avoid_print

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mscl_user/Controller/grievance_controller.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/Model/complaint_model.dart';
import 'package:mscl_user/Model/street_model.dart';
import 'package:mscl_user/Model/ward_model.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/View/Screens/mapscreen.dart';
import 'package:mscl_user/View/widgets/buttons.dart';
import 'package:mscl_user/View/widgets/dropdown_widget.dart';
import 'package:mscl_user/color.dart';
import 'package:http/http.dart' as http;

class GrievanceDetail extends StatefulWidget {
  const GrievanceDetail({super.key});

  @override
  State<GrievanceDetail> createState() => _GrievanceDetailState();
}

class _GrievanceDetailState extends State<GrievanceDetail> {
  final GrievanceController grievanceController =
      Get.put(GrievanceController());
  String? _selectedComplainttype;
  String? _selectedDepartment;
  String? selectComplaint;
  // String? selectedZone;
  String? selectedWard;
  String? selectedZoneName;
  String? selectedStreet;
  List<String> complaintTypes = [];
  List<String> departmentTypes = [];
  List<String> complaint = [];
  List<String> zones = [];
  List<String> wards = [];
  List<String> streets = [];
  final TextEditingController pincode = TextEditingController();
  TextEditingController address = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
    final TextEditingController _locationcontroller = TextEditingController();
   TextEditingController lon = TextEditingController();
  TextEditingController lat = TextEditingController();
  final CustomerCurrentUser customerController = Get.put(CustomerCurrentUser());
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  List<String> filteredComplaints = [];
  List<String> filteredzone = [];
  
  Future<void> _pickFiles() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();

      for (var file in pickedFiles) {
        final fileBytes = await file.readAsBytes();
        final fileSizeInKB = fileBytes.lengthInBytes / 1024;


        if (fileSizeInKB <= 400) {
          if (_selectedFiles.length < 5) {
            setState(() {
              _selectedFiles.add(file);
            });
          } else {
            Fluttertoast.showToast(
              msg: 'You can only select up to 5 images in total',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 15.0,
            );
            break;
          }
        } else {
          Fluttertoast.showToast(
            msg: 'File ${file.name} exceeds 400KB and was not added',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 15.0,
          );
        }
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  

  Future<void> _uploadFiles(String grievanceId) async {
    if (_selectedFiles.isEmpty) return;

    final uri = Uri.parse(ApiUrl.grievattach);

    final request = http.MultipartRequest('POST', uri)
      ..fields['grievance_id'] = grievanceId
      ..fields['created_by_user'] = 'public_user';

    for (var file in _selectedFiles) {
      final multipartFile =
          await http.MultipartFile.fromPath('files', file.path);
      request.files.add(multipartFile);
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  Future<void> fetchGrievanceData() async {
  try {
    grievanceController.getAllComplaintTypes().then((complaintType1) {
      setState(() {
        complaintTypes =
            complaintType1.map((type) => type.complaintType).toList();
      });
    });

    grievanceController.getAllDepartment().then((department1) {
      setState(() {
        departmentTypes =
            department1.map((type) => type.deptname).toList();
      });
    });

    grievanceController.getAllComplaint().then((complaint1) {
      setState(() {
        complaint =
            complaint1.map((type) => type.complainttypetitle).toList();
      });
    });

    grievanceController.getZone().then((zoneType) {
      setState(() {
        zones = zoneType.map((type) => type.zonename).toList();
      });
    });

    grievanceController.getWard().then((wardType) {
      setState(() {
        wards = wardType.map((type) => type.wardname).toList();
      });
    });

    grievanceController.getStreet().then((streetType) {
      setState(() {
        streets =
            streetType.map((type) => type.streetname).toList();
      });
    });
  } catch (e) {
    debugPrint('Error fetching grievance data incrementally: $e');
  }
}


  void fetchComplaintsByDepartment(String selectedDepartment) async {
    try {
      List<ComplaintModel> allComplaints =
          await grievanceController.getAllComplaint();

      // Filter complaints based on the selected department
      List<ComplaintModel> departmentComplaints =
          allComplaints.where((complaint) {
        return complaint.deptname == selectedDepartment;
      }).toList();

      setState(() {
        filteredComplaints = departmentComplaints
            .map((complaint) => complaint.complainttypetitle)
            .toList();
        selectComplaint = null; // Reset the selected complaint type
      });
    } catch (e) {
      debugPrint('Error fetching complaints: $e');
    }
  }

  void onDepartmentSelected(String department) {
    setState(() {
      _selectedDepartment = department;
    });

    fetchComplaintsByDepartment(department);
  }

  List<String> filteredStreets = [];

 

  void fetchStreetsByWard(String selectedWard) async {
    try {
      List<StreetModel> allStreets = await grievanceController.getStreet();
      List<StreetModel> wardStreets = allStreets.where((street) {
        return street.wardname == selectedWard;
      }).toList();
      setState(() {
        filteredStreets =
            wardStreets.map((street) => street.streetname).toList();
        selectedStreet = null;
      });
    } catch (e) {
      debugPrint('Error fetching streets by ward: $e');
    }
  }

  void _showAddressDialog(BuildContext context) {
  final TextEditingController addressController = TextEditingController();
    bool isLocationAccessed = false;
     Position? fetchedPosition;
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
  showDialog(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context,setState) {
        LatLng? selectedLocation;
        return AlertDialog(
          title: const Text('Enter your Address'),
          backgroundColor: Colors.white,
          content: SizedBox(
            width: MediaQuery.of(context).size.height/3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                  const SizedBox(height: 10),
                TextFormField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                    labelText: 'address',
                                    hintStyle: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                            width: 2.0)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        borderSide: const BorderSide(
                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                            width: 2.0)),
                                  ),
                                  maxLines: 3,
                                ),
                const SizedBox(height: 15),
                   TextFormField(
                controller: _locationcontroller,
                decoration: InputDecoration(
                  hintText: 'Pick from the map',
                   hintStyle: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
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
                readOnly: true,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  MapScreen(lat: customerController.customer.lat!,lon: customerController.customer.lon!,),
                    ),
                  );

                  if (result != null && result is LatLng) {
                    setState(() {
                      selectedLocation = result;
                      _locationcontroller.text =
                          'Lat: ${result.latitude}, Lon: ${result.longitude}';
                             lon.text= '${result.longitude}';
                       lat.text= '${result.latitude}';

                    });
                  }
                },
                 validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please mark location';
                    } 
                    return null; 
                  },),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                        onPressed: ()async {
                          if (_locationcontroller.text.isNotEmpty && addressController.text.trim().isNotEmpty) {
                    
      address.text = addressController.text;
  
      // lon.text = selectedLocation!.latitude.toString();
      // lat.text = selectedLocation!.longitude.toString();

      Navigator.pop(context);
      // Call your API to post address along with latitude and longitude
    //  final success = await updateAddressLatLon.editprofile('${fetchedPosition!.latitude}', addressController.text, '${fetchedPosition!.longitude}');
    //     if (success) {
   
    //   }
    } else {
      String errorMessage = '';
      if (addressController.text.trim().isEmpty) {
        errorMessage = 'Please enter an address.';
      } else if ( _locationcontroller.text.trim().isEmpty) {
        errorMessage = ' Please pick location first.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
        ),
      );}
                        },style: ElevatedButton.styleFrom(
                        backgroundColor: maincolor, // blue background color
                        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 8),//5
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),  //10
                      ),
                      child:const Text("Submit",style:  TextStyle(color: Colors.white,fontSize: 14),),),
            )//11
          ],
        );
      }
    ),
  );
}


  @override
  void initState() {
    super.initState();
    fetchGrievanceData();
    address.text = customerController.customer.address!;
    lon.text = customerController.customer.lon!;
    lat.text = customerController.customer.lat!;
    // print("username: ${customerController.customer.publicUserId} ");
    // print("public username: ${customerController.customer.publicUserName} ");
    // print("phone: ${customerController.customer.lat} ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    const SizedBox(
                      width: 3,
                    ),
                    const Text(
                      "Grievance Details",
                      style:
                          TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              complaintTypes.isEmpty ||
                      departmentTypes.isEmpty ||
                      complaint.isEmpty ||
                      zones.isEmpty ||
                      wards.isEmpty 
                      // ||
                      // streets.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            'Please wait, loading...',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownWidget(
                            labelText: 'Complaint Type',
                            value: _selectedComplainttype,
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedComplainttype = newValue;
                              });
                            },
                            items: complaintTypes,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Department',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            value: _selectedDepartment,
                            items: departmentTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(), // Correctly mapping Strings to DropdownMenuItems
                            onChanged: (newValue) {
                              onDepartmentSelected(newValue!);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'Complaint',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            value: selectComplaint,
                            items: filteredComplaints.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectComplaint = newValue!;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Ward',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            value: selectedWard,
                            items: wards.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) async {
                              setState(()  {
                                selectedWard = newValue; 
                                
                                selectedStreet = null; 
                                filteredStreets = [];  
                              });
                               List<WardModel> wardType = await grievanceController.getWard();
                                 var selectedWardModel = wardType.firstWhere((ward) => ward.wardname == newValue);
                                selectedZoneName = selectedWardModel.zonename;
                              fetchStreetsByWard(newValue!);
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Street',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            value: selectedStreet,
                            items: filteredStreets.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.75),
                                  child: Text(
                                    value,
                                    maxLines: 2,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedStreet = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: pincode,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              labelText: 'Pincode',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a pincode';
                              } else if (value.length != 6) {
                                return 'Pincode must be 6 digits';
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                          const SizedBox(height: 16),
                            TextFormField(
                            controller: address,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: 'Complaint Address',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            maxLines: 2,                            
                          ),
                          const SizedBox(height: 5),
                           Row(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {
                           _showAddressDialog(context);
                          },
                          child:  const Text(
                         "Change Address",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              hintStyle: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      width: 2.0)),
                            ),
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16.0),
                          GestureDetector(
                            onTap: _pickFiles,
                            child: DottedBorder(
                              color: Colors.grey,
                              strokeWidth: 1,
                              dashPattern: const [5, 5],
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(4),
                              child: Container(
                                height: 100,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4.0),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image, size: 30),
                                      SizedBox(width: 10),
                                      Text('Upload Files (Up to 5 Files)',
                                          style: TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _selectedFiles.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                leading: const Icon(Icons.file_present),
                                title: Text(_selectedFiles[index].name),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () => _removeFile(index),
                                ),
                              );
                            },
                          ),
                          Center(
                              child: CustomFillButton(
                                  buttontext: "Submit",
                                  buttoncolor: maincolor,
                                  onPressed: () async {
                                    if (_selectedComplainttype == null ||
                                        _selectedDepartment == null ||
                                        //  selectedZone == null ||
                                        selectedWard == null ||
                                        selectedStreet == null ||
                                        pincode.text.isEmpty ||
                                        pincode.text.length != 6 ||
                                        address.text.isEmpty ||
                                        selectComplaint == null ||
                                        descriptionController.text.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg:
                                            'Please enter all required data and ensure the pincode is 6 digits',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 15.0,
                                      );
                                      return;
                                    }

                                    List<ComplaintModel> complaint1 =
                                        await grievanceController
                                            .getAllComplaint();
                                    // Initialize priority variable
                                    String priority = "";
                                    // Iterate over the complaint list to find the matching complaint type
                                    for (var type in complaint1) {
                                      if (type.complainttypetitle ==
                                          selectComplaint) {
                                        priority = type
                                            .priority; // Assign the found priority
                                        break; // Exit the loop once the match is found
                                      }
                                    }

                                    String? grievanceId =
                                        await grievanceController.grievancePost(
                                      context,
                                      _selectedComplainttype ?? "",
                                      _selectedDepartment ?? "",
                                      selectedZoneName ??'',
                                      selectedWard ?? "",
                                      selectedStreet ?? "",
                                      pincode.text,
                                      address.text,
                                      selectComplaint ?? "",
                                      descriptionController.text,
                                      priority,
                                      lon.text,
                                      lat.text
                                    );
                                    if (grievanceId != null &&
                                        _selectedFiles.isNotEmpty) {
                                      // Upload files using the grievance ID
                                      await _uploadFiles(grievanceId);
                                    }
                                  },
                                  minimumSize: const Size(301, 54),
                                  buttontextsize: 20)),
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



