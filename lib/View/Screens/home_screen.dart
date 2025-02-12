import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mscl_user/Controller/user_controller.dart';
import 'package:mscl_user/Controller/user_request.dart';
import 'package:mscl_user/User%20preferences/customer_current.dart';
import 'package:mscl_user/Utils/Constant/app_pages_names.dart';
import 'package:mscl_user/View/Screens/grievance_detail.dart';
import 'package:mscl_user/View/Screens/my_reports.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mscl_user/View/Screens/session_handling.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 
   final UserController _userController = UserController();
     final CustomerCurrentUser customerController = Get.put(CustomerCurrentUser());
     User user = Get.put(User());
   @override
  void initState() {
    super.initState();
     user.fetchUserData();
    _loadUserData();
    _loadUse();
    SessionExpirationHandler.startChecking(context);
    
  }

  //  Future<void> _checkCustomerAddress() async {
      
  //   // Fetch user information
  //   await user.fetchUserData();
  //   final customer = customerController.customer;
  //   // Check if the address is empty
  //   if (customer.address!.isEmpty) {
  //     // Navigate to InitialScreen if the address is empty
  //          print('hello:${customerController.customer.address}');
  //     Future.microtask(() {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => InitialScreen()),
  //       );
  //     });
  //   }
  // }
  Future<void> _loadUse() async {
  
   await user.checkCustomerAddress(context); // Wait for API call to complete
  
    
  }

 Future<void> _loadUserData() async {
  
  customerController.getUserInfo();
    await _userController.fetchUserData(); 
    await _userController.fetchUserDataclosed();
    
    // Replace 'userId' with actual user ID
    setState(() {}); // Update the screen after data is fetched
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
     
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
    //               Fluttertoast.showToast(
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
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: 
                Column(
                  children: [
                 ClipRRect(
  borderRadius: BorderRadius.circular(15.0), // Adjust the radius as needed
  child: const Image(
    image: AssetImage("assets/images/trichy.png"),
    height: 229,
    width: 358,
    fit: BoxFit.cover, // Ensures the image fits within the dimensions
  ),
),
                    const SizedBox(height: 15,),
                    
                      FutureBuilder(
                        future:  customerController.getUserInfo(),
                builder: (context,snapshot) {
             if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
                return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                                         Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReports()));
                                  },
                                  child: Container(
                                     width: screenWidth*0.27,
                                     //height: screenHeight*0.10,
                                    decoration:  BoxDecoration(
                                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                                      //boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 1)],
                                    borderRadius: BorderRadius.circular(5),color: const Color.fromRGBO(255, 240, 240, 1)),
                                    child:  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              
                                              Text('${_userController.itemCount + _userController.closedCount}' ,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500 ),),
                                            
                                             // SizedBox(width: 30,),
                                            
                                              const Image(image: AssetImage("assets/icons/user_check-1.jpg"),height: 29,width: 29,)
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: Text(AppLocalizations.of(context)!.totalreq,style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400),),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                  GestureDetector(
                                    onTap: (){
                                                           Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReports()));
                                    },
                                    child: Container(
                                     width: screenWidth*0.27,
                                    // height: screenHeight*0.10,
                                    decoration:  BoxDecoration(
                                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                                      //boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 1)],
                                    borderRadius: BorderRadius.circular(5),color: const Color.fromRGBO(218, 213, 248, 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                      
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                             
                                               Text('${_userController.statusCount}' ,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500 ),),
                                            
                                             // SizedBox(width: 30,),
                                              const Image(image: AssetImage("assets/icons/hot_request-1.jpg"),height: 29,width: 29,)
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: Text(AppLocalizations.of(context)!.openreq,style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400),),
                                          )
                                        ],
                                      ),
                                    ),
                                                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                                           Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReports(selectedindex: 1,)));
                                    },
                                    child: Container(
                                     width: screenWidth*0.27,
                                    // height: screenHeight*0.10,
                                    decoration:  BoxDecoration(
                                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                                      //boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 1)],
                                    borderRadius: BorderRadius.circular(5),color: const Color.fromRGBO(225, 255, 245, 1)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                      
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                           Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                            
                                              Text('${_userController.closedCount}' ,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.w500 ),),
                                          
                                             // SizedBox(width: 30,),
                                              const Image(image: AssetImage("assets/icons/all_open-1.jpg"),height: 29,width: 29,)
                                            ],
                                          ),
                                          const SizedBox(height: 15,),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 4),
                                            child: Text(AppLocalizations.of(context)!.closereq,style: const TextStyle(color: Colors.black54,fontSize: 12,fontWeight: FontWeight.w400),),
                                          )
                                        ],
                                      ),
                                    ),
                                                                    ),
                                  )
                                        
                              ],
                            );
                        }
                    }
                      ),
                    const SizedBox(height: 20,),
                    Column(
                      children: [
                        Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const GrievanceDetail()));
                  },child: Container(
                    height:screenHeight*0.17 ,//148
                    width: screenWidth*0.4,//172
                   
                    decoration: BoxDecoration(
                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                        color: const Color.fromRGBO(238, 245, 255, 1),
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         SvgPicture.asset(
                  "assets/icons/raising.svg",
                  width: 32,
                  height: 40,
                ),
                     const SizedBox(height: 15,),
                         Text(AppLocalizations.of(context)!.raisetick,style: const TextStyle(color: Colors.black54),textAlign: TextAlign.center,)
                      ],
                    ),
                  ),),
                   InkWell(onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const MyReports()));
                   },child: Container(
                    height: screenHeight*0.17,
                    width: screenWidth*0.4,
                 
                   decoration: BoxDecoration(
                     boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                       color: const Color.fromRGBO(238, 245, 255, 1),
                   ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                  "assets/icons/track.svg",
                  width: 32,
                  height: 40,
                ),
                     const SizedBox(height: 15,),
                         Text(AppLocalizations.of(context)!.trackurgri,style: const TextStyle(color: Colors.black54),textAlign: TextAlign.center,)
                      ],
                    ),
                  ),)
                ],
                        ),
                        const SizedBox(height: 10,),
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(onTap: (){
                        Navigator.pushNamed(context, AppPageNames.profileScreen);
                  },child: Container(
                    height: screenHeight*0.17,
                    width: screenWidth*0.4,
                  
                    decoration: BoxDecoration(
                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                         color: const Color.fromRGBO(238, 245, 255, 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                         SvgPicture.asset(
                  "assets/icons/profile.svg",
                  width: 32,
                  height: 40,
                ),
                     const SizedBox(height: 15,),
                         Text(AppLocalizations.of(context)!.profile,style: const TextStyle(color: Colors.black54),)
                      ],
                    ),
                  ),),
                   InkWell(onTap: (){
                       Navigator.pushNamed(context, AppPageNames.faqScreen);
                   },child: Container(
                    height: screenHeight*0.17,
                    width: screenWidth*0.4,
                   
                    decoration: BoxDecoration(
                       boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 1.0)],
                        color: const Color.fromRGBO(238, 245, 255, 1),
                    ),
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       SvgPicture.asset(
                  "assets/icons/faq.svg",
                  width: 32,
                  height: 40,
                ),
                     const SizedBox(height: 15,),
                        Text(AppLocalizations.of(context)!.faq,style: const TextStyle(color: Colors.black54),textAlign: TextAlign.center,)
                      ],
                    ),
                  ),)
                ],
                        )
                      ],
                    )
                  ]
                )
          ),
        ),
    );
  }
}

