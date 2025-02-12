class Department {
  final String deptid;
  final String deptname;
  final String orgname;
  final String status;
  final String createbyUser;

  Department({
    required this.deptid,
    required this.deptname,
    required this.orgname,
    required this.status,
    required this.createbyUser,
  });
  
  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      deptid: json['dept_id'],
      deptname: json['dept_name'],
      orgname: json['org_name'],
      status: json['status'],
      createbyUser: json['created_by_user']
      
    );
  }

}