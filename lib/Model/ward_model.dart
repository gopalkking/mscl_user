class WardModel{
  final String wardid;
  final String status;
  final String zoneid;
  final String zonename;
  final String wardname;
  final String createbyuser;

  WardModel({
    required this.wardid,
    required this.status,
    required this.zoneid,
    required this.zonename,
    required this.wardname,
    required this.createbyuser,
  });

    factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      wardid: json['ward_id'],
      status: json['status'],
      zoneid: json['zone_id'],
      zonename: json['zone_name'],
      wardname: json['ward_name'],
      createbyuser: json['created_by_user']
    );
  }
}