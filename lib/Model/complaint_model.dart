class ComplaintModel {
  final String complaintid;
  final String complainttypetitle;
  final String deptname;
  final String tattype;
  final String tatduration;
  final String priority;
  final String escalationtype;
  final String escalationl1;
  final String rolel1;
  final String escalationl2;
  final String role2;
  final String escalationl3;
  final String role3;
  final String status;
  final String createbyUser;

  ComplaintModel({
    required this.complaintid,
    required this.complainttypetitle,
    required this.deptname,
    required this.tattype,
    required this.tatduration,
    required this.priority,
    required this.escalationtype,
    required this.escalationl1,
    required this.rolel1,
    required this.escalationl2,
    required this.role2,
    required this.escalationl3,
    required this.role3,
    required this.status,
    required this.createbyUser,
  });

    factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      complaintid: json['complaint_id'],
      complainttypetitle: json['complaint_type_title'],
      deptname: json['dept_name'],
      tattype: json['tat_type'],
      tatduration: json['tat_duration'],
      priority: json['priority'],
      escalationtype: json['escalation_type'],
      escalationl1: json['escalation_l1'],
      rolel1: json['role_l1'],
      escalationl2: json['escalation_l2'],
      role2: json['role_l2'],
      escalationl3: json['escalation_l3'],
      role3: json['role_l3'],
      status: json['status'],
      createbyUser: json['created_by_user']
      
    );
  }
}