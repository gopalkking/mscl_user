// ignore_for_file: avoid_print, unused_element

import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'package:mscl_user/View/Screens/reports_full_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';


class NewRequest extends StatefulWidget {
  final String deptName;
  final String publicUserName;
  final String complaintTypeTitle;
  final String grievanceId;
  final String updattime;
  final String createdtime;
  final String createdday;
  final String updatedate;
  final String assigned;
  final String assignednumber;
  final String phone;
  final String zone;
  final String ward;
  final String status;
  final String statusflow;
  final String complaint;
  final String pincode;
  final String address;
  final String disc;
  final String dateandtime;
  final String timeago;
  final String worksheetje;
  const NewRequest({super.key, required this.deptName, required this.publicUserName, required this.complaintTypeTitle, required this.grievanceId, required this.updattime, required this.assigned, required this.phone, required this.zone, required this.ward, required this.status, required this.complaint, required this.pincode, required this.address, required this.disc, required this.dateandtime, required this.timeago, required this.createdtime, required this.updatedate, required this.createdday, required this.statusflow, required this.assignednumber, required this.worksheetje});

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  bool _isBottomContainerVisible = false;
   bool _isBottomContainerVisible2 = false;
    final PageController _pageController = PageController();
    final List<Uint8List> _imageBytesList = [];
  void _toggleBottomContainer() {
    setState(() {
      _isBottomContainerVisible = !_isBottomContainerVisible;
    });
  }
  void _toggleBottomContainer2() {
    setState(() {
      _isBottomContainerVisible2 = !_isBottomContainerVisible2;
    });
  }
void _launchURL (Uri uri, bool inapp) async {
   try {
     if (inapp) {
       await launchUrl(uri,mode: LaunchMode.inAppWebView);
     }
     else{
       await launchUrl(uri,mode: LaunchMode.externalApplication);
     }
   } catch (e) {
     print(e.toString());
   }
   }

    Future<void> fetchGrievancesimage() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  
  try {
    final response = await http.get(
      Uri.parse(ApiUrl.grievanceattchment(widget.grievanceId)),
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
        List<dynamic> decryptedJsonList = jsonDecode(decryptedData);
         for (var item in decryptedJsonList) {
          String attachmentId = item['attachment'];
          print('hhee:$attachmentId');
          // Fetch and display the image
          await fetchAndDisplayImage(attachmentId);
        }
        setState(() {});
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

Future<void> fetchAndDisplayImage(String attachmentId) async {
    final url = ApiUrl.grievanceWorksheet(attachmentId);
    // Log the URL
    
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String? contentType = response.headers['content-type'];

        if (contentType == null || contentType == 'undefined') {
          contentType = 'image/jpeg'; 
        }

        if (contentType.startsWith('image/')) {
          // Add image bytes to list
          _imageBytesList.add(response.bodyBytes);
          // Trigger rebuild
          setState(() {});
        } else {
          print('Unexpected content-type: $contentType');
          print('Response body: ${response.body}');
        }
      } else {
        print('Failed to load image, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Image fetch failed: $e');
    }
  }
  @override
  void initState() {
    fetchGrievancesimage();
    super.initState();
  }

    @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     final double screenWidth = MediaQuery.of(context).size.width;

    return  Scaffold(
        backgroundColor: const Color.fromRGBO(244, 252, 255, 1),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("View Grievance",style: TextStyle(fontWeight: FontWeight.w500),),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
              height: 0.8,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth*0.92,
                    //  height: screenHeight*0.21,
                      padding: const EdgeInsets.all(20),
                      decoration:  BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)]),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text( AppLocalizations.of(context)!.reqoverview,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                          const SizedBox(height: 20,),
                          Row(
                            children: [
                               Text(widget.grievanceId,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
                              const SizedBox(width: 5,),
                              Container(
                                height: 26,
                                width: 80,
                                decoration: BoxDecoration(border: Border.all(color: Colors.green),borderRadius: BorderRadius.circular(5)),
                                child:  Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(widget.status,style: const TextStyle(color: Colors.green,),textAlign: TextAlign.center,),
                                ),
                    
                              ),
                             // SizedBox(width: screenWidth/26,),
                             const Spacer(),
                               Text(widget.dateandtime,style: const TextStyle(fontSize: 11,color: Colors.black54),)
                            ],
                          ),
                          const SizedBox(height: 10,),
                           Row(children: [
                            Text( AppLocalizations.of(context)!.raiseby,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                            const SizedBox(width: 5,),
                            Text(widget.publicUserName,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
                          ],),
                          const SizedBox(height: 10,),
                            Row(children: [
                             Text( AppLocalizations.of(context)!.department,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                            const SizedBox(width: 5,),
                             SizedBox(
                                width:150,
                                child: Text(
                                  widget.deptName,
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w500),
                                      softWrap: true,
                                ),
                              
                              ),
                            
                          ],),
                          const SizedBox(height: 10,),
                             Row(
                              children: [
                                 Text( AppLocalizations.of(context)!.assignto1,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                                 const SizedBox(width: 5,),
                            Text(widget.assigned,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                                 const Spacer(),
                                InkWell(
                        onTap: () =>
                            _launchURL(Uri.parse('tel:${widget.assignednumber}'), false),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 4,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    Icons.call,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Call",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            )),
                      ),
                              ],
                            ),
                          
                           
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                     Container(
                   width: screenWidth*0.9,
                   height: 40,
                   decoration: const BoxDecoration(color: Colors.white,boxShadow: [BoxShadow(color: Colors.grey)]),
                   child: Row(
                    children: [
                      const SizedBox(width: 10,),
                     Text( AppLocalizations.of(context)!.grivedetail,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black)),
                       //SizedBox(width: screenWidth*0.43,),
                       const Spacer(),
                       IconButton(onPressed: _toggleBottomContainer2, icon: Icon(_isBottomContainerVisible2
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),)
                    ],
                   ),
                   ),
                    // const SizedBox(height: 10,),
                   if (_isBottomContainerVisible2)
                    Container(
                        width: screenWidth*0.9,
                     // height: screenHeight*0.43,
                      padding: const EdgeInsets.all(20),
                      decoration:  BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)]),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Row(children: [
                             Text( AppLocalizations.of(context)!.phonenum1,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                           // const SizedBox(width: 71,),
                           const Spacer(),
                            SizedBox(width: 150, child: Text(widget.phone,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),softWrap: true,))
                          ],),
                          const SizedBox(height: 10,),
                            Row(children: [
                             Text( AppLocalizations.of(context)!.address1,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                           // const SizedBox(width: 113,),
                           const Spacer(),
                            SizedBox(width: 150, child: Text(widget.address,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),softWrap: true,))
                          ],),
                          const SizedBox(height: 10,),
                            Row(children: [
                            Text( AppLocalizations.of(context)!.pincode,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                          //  const SizedBox(width: 114,),
                          const Spacer(),
                            SizedBox(width: 150, child: Text(widget.pincode,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),softWrap: true,))
                          ],),
                          const SizedBox(height: 10,),
                            Row(children: [
                             Text( AppLocalizations.of(context)!.zone,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                          //  const SizedBox(width: 132,),
                          const Spacer(),
                            SizedBox(width: 150, child: Text(widget.zone,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),softWrap: true,))
                          ],),
                          const SizedBox(height: 10,),
                            Row(children: [
                            Text( AppLocalizations.of(context)!.ward,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                           // const SizedBox(width: 131,),
                           const Spacer(),
                            SizedBox(width: 150, child: Text(widget.ward,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,),softWrap: true,))
                          ],),
                          const SizedBox(height: 10,),
                          // Row(children: [
                          //   Text( AppLocalizations.of(context)!.area,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.black54),),
                          //  // const SizedBox(width: 131,),
                          //  const Spacer(),
                          //   const Text("Area",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black54),)
                          // ],),
                          // const SizedBox(height: 10,),
                            Row(children: [
                            Text( AppLocalizations.of(context)!.req,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                           // const SizedBox(width: 115,),
                           const Spacer(),
                            SizedBox(width: 150, child: Text(widget.complaint,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500),softWrap: true,))
                          ],),
                          const SizedBox(height: 10,),
                            Row(children: [
                             Text( AppLocalizations.of(context)!.department1,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54),),
                          //  const SizedBox(width: 95,),
                          const Spacer(),
                            SizedBox(
                                width:150,
                                child: Text(
                                  widget.deptName,
                                  style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.w500),
                                      softWrap: true,
                                ),
                              
                              )
                          ],),
                          const SizedBox(height: 10,),
                           const Row(children: [
                            // const Text("Attachments :",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400,color: Colors.black54),),
                            // const SizedBox(width: 30,),
                            // const Icon(Icons.picture_as_pdf_outlined,color: Colors.red,),
                            //  const SizedBox(width: 2,),
                            // const Text("1.3MB",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),),
                            // const SizedBox(width: 2,),
                            // InkWell(onTap: (){},child: const Icon(Icons.file_download_outlined),)
                          
                          ],),
                          GestureDetector(onTap: (){
                              Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportsFullView(
                        deptName: widget.deptName,
                        publicUserName: widget.publicUserName,
                        complaintTypeTitle: widget.complaintTypeTitle,
                        grievanceId: widget.grievanceId,
                        createdAt: widget.dateandtime,
                        assigned: widget.assigned,
                        phone: widget.phone,
                        ward: widget.ward,
                        zone: widget.zone ,
                        complaint: widget.complaint,
                        status:widget.status,
                        pincode: widget.pincode,
                        address: widget.address,
                        disc: widget.disc,
                        timeago: widget.timeago,
                      ),
                    ),
                  );
                          }, child:  Text( AppLocalizations.of(context)!.reqfullview,style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),))
                        ],
                      ),
                    ),
                    const SizedBox(height: 24,),
                       if(widget.worksheetje.isNotEmpty)
                       Container(
                       width: screenWidth * 0.92,
                    padding: const EdgeInsets.all(20),
                    decoration:  BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         const Text("Response : ", style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),),
                        Text(
                              widget.worksheetje,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                 const SizedBox(height: 10),
                      Stack(
              children: [
              if (_imageBytesList.isNotEmpty)
                SizedBox(
                  height: 350.0, 
                  child: PageView.builder(
                    controller:_pageController,
                    itemCount: _imageBytesList.length,
                    itemBuilder: (context, index) {
                      return OrientationBuilder(
                        builder: (context,orientation) {
                          return InstaImageViewer(
                            child: Image.memory(
                              _imageBytesList[index],
                               fit: BoxFit.contain,
                         width: orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.height,
                            ),
                          );
                        }
                      );
                    },
                  ),
                ),
              // else
              //  const Text('No image',style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.black,
              //   ),),
                 if (_imageBytesList.isNotEmpty)
              Positioned(
                right: 0,
                left: 10,
                top: 320,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _imageBytesList.length,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey,
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      spacing: 8.0,
                    ),
                  ),
                ),
              ),
              ],
            ),
            //          Container(
            //       width: screenWidth*0.9,
            //       height: 40,
            //       decoration: const BoxDecoration(color: Color.fromRGBO(244, 252, 255, 1),boxShadow: [BoxShadow(color: Colors.grey)]),
            //       child: Row(
            //         children: [
            //           const SizedBox(width: 10,),
            //            Text( AppLocalizations.of(context)!.complainhis,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black)),
            //           const SizedBox(width: 3,),
            //           const Text("#564258",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black54)),
            //           // SizedBox(width: screenWidth*0.25,),
            //           const Spacer(),
            //            IconButton(onPressed: _toggleBottomContainer, icon: Icon(_isBottomContainerVisible
            //               ? Icons.keyboard_arrow_up
            //               : Icons.keyboard_arrow_down),)
            //         ],
            //       ),
            //     ),
            //                     if (_isBottomContainerVisible)
            //     Container(
            //       color: Colors.white,
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //              Text(widget.createdday,style: const TextStyle(fontWeight: FontWeight.w500,),),
            //             Padding(
            //               padding: const EdgeInsets.all(10.0),
            //               child: Column(
            //                 children: [
            //                   Row(
            //                     children: [
            //                       Text(widget.createdtime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
            //                       const SizedBox(width: 40,),
            //                       Container(
            //                         height: 25,
            //                         width: 1.5,
            //                         color: Colors.black,
            //                       ),
            //                        const SizedBox(width: 30,),
            //                       const Text("Logged in",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black54),)
            //                     ],
            //                   ),
            //                   const SizedBox(height: 10,),
            //                    Row(
            //                     children: [
            //                      Text(widget.createdtime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
            //                       const SizedBox(width: 40,),
            //                       Container(
            //                         height: 25,
            //                         width: 1.5,
            //                         color: Colors.black,
            //                       ),
            //                        const SizedBox(width: 30,),
            //                       const Text("Ticket Raised- R 0001122",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black54),)
            //                     ],
            //                   ),
            //                   const SizedBox(height: 10,),
            //                    Row(
            //                     children: [
            //                       Text(widget.createdtime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
            //                       const SizedBox(width: 40,),
            //                       Container(
            //                         height: 27,
            //                         width: 1.5,
            //                         color: Colors.black,
            //                       ),
            //                        const SizedBox(width: 30,),
            //                       const Text("Assigned to particular\n department",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black54),)
            //                     ],
            //                   ),
            //                   const SizedBox(height: 10,),
            //                 ],
            //               ),
            //             ),
            //             const SizedBox(height: 5,),
            //              Text(widget.updatedate,style: const TextStyle(fontWeight: FontWeight.w500,),),
            //             Padding(
            //               padding: const EdgeInsets.all(10.0),
            //               child: Column(
            //                 children: [
            //                   Row(
            //                     children: [
            //                      Text(widget.updattime,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
            //                       const SizedBox(width: 40,),
            //                       Container(
            //                         height: 25,
            //                         width: 1.5,
            //                         color: Colors.black,
            //                       ),
            //                        const SizedBox(width: 30,),
            //                       Row(
            //                             children: [
            //                               const Text(
            //                                 "Status :",
            //                                 style: TextStyle(
            //                                     fontSize: 14,
            //                                     fontWeight: FontWeight.w400,
            //                                     color: Colors.black54),
            //                               ),
            //                               Text(
            //                                 widget.statusflow,
            //                                 style: const TextStyle(
            //                                     fontSize: 14,
            //                                     fontWeight: FontWeight.w400,
            //                                     color: Colors.black54),
            //                               ),
            //                             ],
            //                           )
            //                     ],
            //                   ),
                             
            //                 ],
            //               ),
            //             ),
            //             const SizedBox(height: 10,),
            //              Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //        Container(
            //         height: 44,
            //        // width: 104,
            //         padding: const EdgeInsets.symmetric(horizontal: 40.0),
            //         decoration: BoxDecoration(border: Border.all(color: Colors.grey)) ,
            //        child:  Center(
            //          child: Text( AppLocalizations.of(context)!.status,style: const TextStyle(color: Colors.black87,fontSize: 19,fontWeight: FontWeight.w400),
            //                            ),
            //        ),),
            //         Container(
            //         height: 44,
            //        // width: 104,
            //         padding: const EdgeInsets.symmetric(horizontal: 40.0),
            //         decoration: const BoxDecoration(color: Color.fromRGBO(0, 63, 91, 1), ) ,
            //        child:  Center(
            //          child: Text(widget.status,style: const TextStyle(color: Colors.white,fontSize: 19,fontWeight: FontWeight.w400),
            //                            ),
            //        ),),
            //     ],
            //   ),
            //  ),
            //           ],
            //         ),
            //       ),
            //     ),
                    
                  ],
                ),
               ),
              //const SizedBox(height: 10,),
               
                const SizedBox(height: 10,),
                
            ],
          ),

        ),
        );
  }
}