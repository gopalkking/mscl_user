class StreetModel{
  final String streetid;
  final String streetname;
  final String wardid;
  final String status;
  final String wardname;
  final String zoneid;
  final String zonename;
   String? createbyuser;

  StreetModel({
    required this.streetid,
    required this.streetname,
    required this.wardid,
    required this.status,
    required this.wardname,
    required this.zoneid,
    required this.zonename,
     this.createbyuser,
  });

  factory StreetModel.fromJson(Map<String, dynamic> json) {
    return StreetModel(
      streetid: json['street_id'],
      streetname: json['street_name'],
      wardid: json['ward_id'],
      status: json['status'],
      wardname: json['ward_name'],
      zoneid: json['zone_id'],
      zonename: json['zone_name'], 
      createbyuser: json['created_by_user']
    );
  }
}