import 'package:flutter/material.dart';
import 'package:mscl_user/View/Screens/closed_reports.dart';
import 'package:mscl_user/View/Screens/grievance_detail.dart';
import 'package:mscl_user/View/Screens/myreports_content.dart';
import 'package:mscl_user/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyReports extends StatefulWidget {
  final int? selectedindex;
  const MyReports({super.key, this.selectedindex});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {

  
  late int _selectedIndex;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedindex ?? 0; 
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black), // Ensure the drawer icon is visible
         leading: Padding(
           padding: const EdgeInsets.only(left: 15),
           child: Image.asset("assets/images/logo2.jpeg",),
         ),
    //       actions: [
    //       Padding(
    //         padding: const EdgeInsets.only(right: 20.0),
    //         child: InkWell(
    //           onTap: () {
    //            // Navigator.pushNamed(context, AppPageNames.notificationScreen);
    //              Fluttertoast.showToast(
    //   msg: 'No Notification',
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: Colors.blue,
    //   textColor: Colors.white,
    //   fontSize: 15.0,
    // ); 
               
    //           },
    //           child: const Icon(
    //             Icons.notifications_outlined,
    //             size: 30,
    //             color: Colors.black,
    //           ),
    //         ),
    //       ),
    //     ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.5),
            child: Container(
              decoration: const BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)]),
              height: 0.8,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const GrievanceDetail()));
          },
          backgroundColor: maincolor,
          shape: const CircleBorder(),
          child: const Icon(Icons.feed_outlined,color: Colors.white,size: 30,),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                 Row(
                  
                    children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: _selectedIndex == 0
                                ? Colors.white
                                : maincolor,
                            backgroundColor: _selectedIndex == 0
                                ? maincolor
                                : Colors.white, // Text color
                            side: const BorderSide(
                              color: maincolor,
                              width: 1,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.03,
                                vertical: MediaQuery.of(context).size.height * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.02),
                            ),
                            minimumSize: const Size(108, 39)
                          ),
                          child:  Text(
                            AppLocalizations.of(context)!.myreports,
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400
                            ),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: _selectedIndex == 1
                                ? Colors.white
                                : maincolor,
                            backgroundColor: _selectedIndex == 1
                                ? maincolor
                                : Colors.white, // Text color
                            side: const BorderSide(
                              color: maincolor,
                              width: 1,
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width * 0.03,
                                vertical: MediaQuery.of(context).size.height * 0.01),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.02),
                            ),
                             minimumSize: const Size(108, 39)
                          ),
                          child: Text(
                           AppLocalizations.of(context)!.closed,
                            style: const TextStyle(  fontSize: 14.0,
                              fontWeight: FontWeight.w400),
                          ),
                        ),
                    ],
                  ),
                   const SizedBox(
                    height: 20,
                  ),
                  IndexedStack(
                    index: _selectedIndex,
                    children:  const [
                     MyReportsContent(),
                     ClosedContent()
                      // Container(
                      //   child: const Center(
                      //     child: Text('content for lastmonth'),
                      //   ),
                      // )
                    ],
                  )
              ],
            ),
          ),
        ),
    );
  }
}


