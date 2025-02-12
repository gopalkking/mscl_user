
import 'dart:convert';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Model/customer.dart';

class RememberUserPrefs {
   

   static Future<void> saveRememberUser(CustomerModel userInfo) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonDate = jsonEncode(userInfo.toJson());
    await preferences.setString("currentUser", userJsonDate);
  }

  static Future<CustomerModel?> readUser() async
  {
    CustomerModel? currentUserInfo;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userInfo = preferences.getString("currentUser");
    //print("$userInfo");
    if(userInfo != null){
      Map<String, dynamic> userDataMap = jsonDecode(userInfo);
      currentUserInfo = CustomerModel.fromJson(userDataMap);
    }
    return currentUserInfo;
  }


  static Future<void> removeUserInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("currentUser");
  }

}
