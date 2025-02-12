// ignore_for_file: empty_catches, avoid_print

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mscl_user/Model/auth/api_url.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;

// class UserController extends GetxController {
 
//   var isLoading = true.obs;
//   var itemCount = 0.obs;
//    var statusCount = 0.obs; 
//   var closedCount = 0.obs; 
//  final CustomerCurrentUser _customerController =
//       Get.put(CustomerCurrentUser());

//   Future<void> fetchUserData() async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('authToken');
//   final customer = _customerController.customer;
//   try {
//     final response = await http.get(
//       Uri.parse(ApiUrl.getgriev(customer.publicUserId!)),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);

//       final key = encrypt.Key.fromBase16('9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
//       final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

//       final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

//       try {
//         final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
//         final decryptedData = encrypter.decrypt(encryptedData, iv: iv);
//           final decryptedJson = jsonDecode(decryptedData);
          
      
//           int count;
//           if (decryptedJson is List) {
//             count = decryptedJson.length; 
//           } else if (decryptedJson is Map) {
//             count = decryptedJson.length; 
//           } else {
//             count = 1; 
//           }

//           itemCount.value = count;
          
//           // Initialize status counter
//           int totalCount = 0;

//           // Count the number of items with specific statuses
//           if (decryptedJson is List) {
//             for (var item in decryptedJson) {
//               if (item['status'] == 'new' || 
//                   item['status'] == 'onhold' || 
//                   item['status'] == 'inprogress' || 
//                   item['status'] == 'resolved' || 
//                   item['status'] == 'closed') {
//                 totalCount++;
//               }
//             }
//           } else if (decryptedJson is Map) {
//             if (decryptedJson['status'] == 'new' || 
//                 decryptedJson['status'] == 'onhold' || 
//                 decryptedJson['status'] == 'inprogress' || 
//                 decryptedJson['status'] == 'resolved' || 
//                 decryptedJson['status'] == 'closed') {
//               totalCount = 1;
//             }
//           }

//           statusCount.value = totalCount;
//            int closedItemsCount = 0;

//           if (decryptedJson is List) {
//             for (var item in decryptedJson) {
//               if (item['status'] == 'closed') {
//                 closedItemsCount++;
//               }
//             }
//           } else if (decryptedJson is Map) {
//             if (decryptedJson['status'] == 'closed') {
//               closedItemsCount = 1;
//             }
//           }


//           closedCount.value = closedItemsCount;
//       } catch (e) {
//       }

//     } else {
//     }
//   } catch (e) {
//   }
// }
  
// }

class UserController {
  bool isLoading = true;
  int itemCount = 0;
  int statusCount = 0;
  int closedCount = 0;

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final userid = prefs.getString('userId');
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.getgriev(userid!)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        final key = encrypt.Key.fromBase16('9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
        final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

        final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

        try {
          final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
          final decryptedData = encrypter.decrypt(encryptedData, iv: iv);
          final decryptedJson = jsonDecode(decryptedData);

          int count;
          if (decryptedJson is List) {
            count = decryptedJson.length;
          } else if (decryptedJson is Map) {
            count = 1; // Assuming Map contains a single item
          } else {
            count = 1; // Assuming other cases
          }

          itemCount = count;
          print("Successfully fetched item count: $itemCount");

          // Initialize status counter
          int totalCount = 0;

          // Count the number of items with specific statuses
          if (decryptedJson is List) {
            for (var item in decryptedJson) {
              if (item['status'] == 'processing' || 
                  item['status'] == 'onhold' || 
                  item['status'] == 'inprogress' || 
                  item['status'] == 'resolved' || 
                  item['status'] == 'closed') {
                totalCount++;
              }
            }
          } else if (decryptedJson is Map) {
            if (decryptedJson['status'] == 'processing' || 
                decryptedJson['status'] == 'onhold' || 
                decryptedJson['status'] == 'inprogress' || 
                decryptedJson['status'] == 'resolved') {
              totalCount = 1;
            }
          }

          statusCount = totalCount;

          // int closedItemsCount = 0;

          // if (decryptedJson is List) {
          //   for (var item in decryptedJson) {
          //     if (item['status'] == 'closed') {
          //       closedItemsCount++;
          //     }
          //   }
          // } else if (decryptedJson is Map) {
          //   if (decryptedJson['status'] == 'closed') {
          //     closedItemsCount = 1;
          //   }
          // }

          // closedCount = closedItemsCount;
        } catch (e) {
          print("Decryption or parsing error: $e");
        }
      } else {
        print("Error fetching user data: ${response.statusCode}");
      }
    } catch (e) {
      print("Request error: $e");
    }
  }
    
  Future<void> fetchUserDataclosed() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    final userid = prefs.getString('userId');
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.getgrievclosed(userid!)),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        final key = encrypt.Key.fromBase16('9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
        final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

        final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

        try {
          final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
          final decryptedData = encrypter.decrypt(encryptedData, iv: iv);
          final decryptedJson = jsonDecode(decryptedData);

          // int count;
          // if (decryptedJson is List) {
          //   count = decryptedJson.length;
          // } else if (decryptedJson is Map) {
          //   count = 1; // Assuming Map contains a single item
          // } else {
          //   count = 1; // Assuming other cases
          // }

          // itemCount = count;
          // print("Successfully fetched item count: $itemCount");

          // // Initialize status counter
          // int totalCount = 0;

          // // Count the number of items with specific statuses
          // if (decryptedJson is List) {
          //   for (var item in decryptedJson) {
          //     if (item['status'] == 'new' || 
          //         item['status'] == 'onhold' || 
          //         item['status'] == 'inprogress' || 
          //         item['status'] == 'resolved' || 
          //         item['status'] == 'closed') {
          //       totalCount++;
          //     }
          //   }
          // } else if (decryptedJson is Map) {
          //   if (decryptedJson['status'] == 'new' || 
          //       decryptedJson['status'] == 'onhold' || 
          //       decryptedJson['status'] == 'inprogress' || 
          //       decryptedJson['status'] == 'resolved') {
          //     totalCount = 1;
          //   }
          // }

          // statusCount = totalCount;

          int closedItemsCount = 0;

          if (decryptedJson is List) {
            for (var item in decryptedJson) {
              if (item['status'] == 'closed') {
                closedItemsCount++;
              }
            }
          } else if (decryptedJson is Map) {
            if (decryptedJson['status'] == 'closed') {
              closedItemsCount = 1;
            }
          }

          closedCount = closedItemsCount;
        } catch (e) {
          print("Decryption or parsing error: $e");
        }
      } else {
        print("Error fetching user data: ${response.statusCode}");
      }
    } catch (e) {
      print("Request error: $e");
    }
  }
}
