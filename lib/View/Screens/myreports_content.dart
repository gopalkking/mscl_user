// ignore_for_file: avoid_print

import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/Model/grievance.dart';
import 'package:mscl_user/View/Screens/new_request.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyReportsContent extends StatefulWidget {
  const MyReportsContent({super.key});

  @override
  State<MyReportsContent> createState() => _MyReportsContentState();
}

class _MyReportsContentState extends State<MyReportsContent> {
  List<Grievance> grievances = [];

  @override
  void initState() {
    super.initState();
    fetchGrievances();
  }

  Future<void> fetchGrievances() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final userId = prefs.getString('userId');
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.getgriev(userId!)),
        headers: {'Authorization': 'Bearer $token'},
      );

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
          List<dynamic> decryptedJsonList = jsonDecode(decryptedData);
          print('Decrypted Data: $decryptedData');
          setState(() {
            grievances = decryptedJsonList.map((item) {
              return Grievance(
                  id: item['_id'],
                  grievanceId: item['grievance_id'],
                  grievanceMode:
                      item['grievance_mode'] ?? '', // New field added
                  complaintTypeTitle: item['complaint_type_title'],
                  deptName: item['dept_name'],
                  zoneName: item['zone_name'],
                  wardName: item['ward_name'],
                  streetName: item['street_name'],
                  pincode: item['pincode'],
                  complaint: item['complaint'],
                  complaintDetails: item['complaint_details'],
                  publicUserId: item['public_user_id'],
                  publicUserName: item['public_user_name'],
                  phone: item['phone'],
                  status: item['status'],
                  statusflow: item['statusflow'],
                  priority: item['priority'],
                  createdAt: item['createdAt'],
                  updatedAt: item['updatedAt'],
                  version: item['__v'],
                  assign: item['assign_username'] ?? '',
                  assignnumber: item['assign_userphone'] ?? '',
                  worksheetJE: item['worksheet_JE'] ?? '');
            }).toList();
          });

          grievances.sort((a, b) => DateTime.parse(b.createdAt)
              .compareTo(DateTime.parse(a.createdAt)));
        } catch (e) {
          print('Decryption failed: $e');
        }
      } else {
        print('Failed to load grievances');
      }
    } catch (e) {
      print('HTTP request failed: $e');
    }
  }

  String formatDate(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString).toLocal();
    final DateFormat formatter = DateFormat('MMMM dd yyyy, hh:mm a');
    return formatter.format(dateTime);
  }

  String formatDay(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString).toLocal();
    final DateFormat formatter = DateFormat('EEEE, dd MMMM');
    return formatter.format(dateTime);
  }

  String formatTime(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString).toLocal();
    final DateFormat timeFormatter = DateFormat('hh:mm a');
    return timeFormatter.format(dateTime);
  }

  String formatTimeAgo(String dateString) {
    final DateTime dateTime = DateTime.parse(dateString);
    return timeago.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return grievances.isEmpty
        ? const Center(
            child: Text(
              "No data available",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : Column(
            children: grievances.map((grievance) {
              final createdAt = DateTime.parse(grievance.createdAt);
              final timeAgo = timeago.format(createdAt);
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewRequest(
                        deptName: grievance.deptName,
                        publicUserName: grievance.publicUserName,
                        complaintTypeTitle: grievance.complaintTypeTitle,
                        grievanceId: grievance.grievanceId,
                        updattime: formatTime(grievance.updatedAt),
                        assigned: grievance.assign,
                        assignednumber: grievance.assignnumber,
                        phone: grievance.phone,
                        ward: grievance.wardName,
                        zone: grievance.zoneName,
                        complaint: grievance.complaint,
                        status: grievance.status,
                        statusflow: grievance.statusflow,
                        pincode: grievance.pincode,
                        address: grievance.streetName,
                        disc: grievance.complaintDetails,
                        dateandtime: formatDate(grievance.createdAt),
                        createdtime: formatTime(grievance.createdAt),
                        createdday: formatDay(grievance.createdAt),
                        updatedate: formatDay(grievance.updatedAt),
                        timeago: timeAgo,
                        worksheetje: grievance.worksheetJE ?? '',
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromRGBO(238, 245, 255, 1),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: 1.0)
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                  maxRadius: 30,
                                  backgroundColor: Colors.blue[100],
                                  child: Text(
                                    grievance.complaint
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 24,
                                    ),
                                  )),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        grievance.complaint.length > 22
                                            ? SizedBox(
                                                width: 110,
                                                child: Text(
                                                  grievance.complaint,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  softWrap: true,
                                                ),
                                              )
                                            : Text(
                                                grievance.complaint,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                softWrap: true,
                                              ),
                                        Container(
                                          //  width: 50,
                                          //height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.green,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text(
                                                grievance.status,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .complainno,
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "#${grievance.grievanceId}",
                                          style: const TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                // width: screenWidth * 0.27,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .assignto,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          grievance.assign,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // width: screenWidth * 0.27,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.date,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          timeAgo,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
  }
}
