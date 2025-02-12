class ZoneModel{
  final String zoneid;
  final String zonename;
  final String status;
  final String createbyuser;

  ZoneModel({
    required this.zoneid,
    required this.zonename,
    required this.status,
    required this.createbyuser,
  });

    factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      
      zoneid: json['zone_id'],
      zonename: json['zone_name'],
      status: json['status'],
      createbyuser: json['created_by_user']
    );
  }
}