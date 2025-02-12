
class CustomerModel {
  String? id;
  String? publicUserId;
  String? publicUserName;
  String? phone;
  String? email;
  String? address; // Added this field for address
  String? pincode; // Added this field for pincode
  String? loginPassword;
  String? verificationStatus;
  String? userStatus; // Added this field for user_status
  String? role;
  String? lat;
  String? lon;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CustomerModel({
    this.id,
    this.publicUserId,
    this.publicUserName,
    this.phone,
    this.email,
    this.address,
    this.pincode,
    this.loginPassword,
    this.verificationStatus,
    this.userStatus,
    this.role,
    this.lat,
    this.lon,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["_id"],
        publicUserId: json["public_user_id"],
        publicUserName: json["public_user_name"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"], // Handle address
        pincode: json["pincode"], // Handle pincode
        loginPassword: json["login_password"],
        verificationStatus: json["verification_status"],
        userStatus: json["user_status"], // Handle user_status
        role: json["role"],
        lat:json["lat"],
        lon: json["lon"],
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "public_user_id": publicUserId,
        "public_user_name": publicUserName,
        "phone": phone,
        "email": email,
        "address": address,
        "pincode": pincode,
        "login_password": loginPassword,
        "verification_status": verificationStatus,
        "user_status": userStatus,
        "role": role,
        "lat":lat,
        "lon":lon,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
