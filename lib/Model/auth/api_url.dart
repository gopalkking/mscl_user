// ignore_for_file: prefer_interpolation_to_compose_strings

//String get url => 'http://192.168.67.5:4000/';
 //String get url => 'http://3.101.126.126:4000/';


//  String get url => 'http://13.60.180.9:4000/';
 String get url => 'https://api.maduraismartcity.com/';

  //String get url => 'http://192.168.31.18:4000/';
// String get url => 'http://192.168.158.177:4000/';

class ApiUrl {
  static String getuserdat(String userId) => url + "public-user/getbyid?public_user_id=$userId";
  static String getgriev(String userId) => url + "new-grievance/getbyuserid?public_user_id=$userId";
  static String getgrievclosed(String userId) => url + "new-grievance/getbyidstatus?public_user_id=$userId";
  static String changepass(String phone) => url + "public-user/changePassword?phone=$phone";
  static String forgetpass(String phone) => url + "public-user/forgotPassword?phone=$phone";
  static String deleteacc(String userId) => url + "public-user/delete?public_user_id=$userId";
  static String editprof(String userId) => url + "public-user/update?public_user_id=$userId";
  static String editaddresslatlon(String userId) => url + "public-user/updatelonlat?public_user_id=$userId";
  static String imgget(String grievId) => url + "new-grievance-attachment/getattachments?grievance_id=$grievId";
  static String getfile(String filename) => url + "new-grievance-attachment/file/$filename";
  static String updatestatus(String grievId) => url + "new-grievance/updatestatus?grievance_id=$grievId";
  static String get grievanceLog => url + "grievance-log/post";
  static String get signup => url + "public-user/post";
   static String get signupapp => url + "public-user/postapp";
  static String get loginweb => url + "public-user/loginweb";
  static String get grievattach => url + "new-grievance-attachment/post";
  static String get complaintType => url + "complainttype/get";
  static String get department => url + "department/get";
  static String get complaint => url + "complaint/get";
  static String get zone => url + "zone/get";
  static String get ward => url + "ward/get";
  static String get street => url + "street/get";
  static String get grievance => url + "new-grievance/post";
  static String grievanceattchment(String grievanceId) => url + "grievance-worksheet-attachment/getattachments?grievance_id=$grievanceId";
  static String grievanceWorksheet(String filename) => url +"grievance-worksheet-attachment/file/$filename";
  static String reopen(String grievanceId) => url +"new-grievance/reopen?grievance_id=$grievanceId";

}

