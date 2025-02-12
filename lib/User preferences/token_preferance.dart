import 'package:shared_preferences/shared_preferences.dart';

class RememberUserPre {
  // Existing methods ...

  // Method to save the token to shared preferences
  static Future<void> saveToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("authToken", token);
  }

  // Method to read the token from shared preferences
  static Future<String?> readToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("authToken");
  }

  // Method to remove the token from shared preferences
  static Future<void> removeToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("authToken");
  }

  // Existing methods ...
}
