class Grievance {
  final String id;
  final String grievanceId;
  final String grievanceMode; 
  final String complaintTypeTitle;
  final String deptName;
  final String zoneName;
  final String wardName;
  final String streetName;
  final String pincode;
  final String complaint;
  final String complaintDetails;
  final String publicUserId;
  final String publicUserName;
  final String phone;
  final String status;
  final String statusflow;
  final String priority;
  final String createdAt;
  final String updatedAt;
  final int version;
  final String assign;
  final String assignnumber;  
  String? worksheetJE;

  Grievance({
    required this.id,
    required this.grievanceId,
    required this.grievanceMode, // New field
    required this.complaintTypeTitle,
    required this.deptName,
    required this.zoneName,
    required this.wardName,
    required this.streetName,
    required this.pincode,
    required this.complaint,
    required this.complaintDetails,
    required this.publicUserId,
    required this.publicUserName,
    required this.phone,
    required this.status,
    required this.statusflow,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.assign,
    required this.assignnumber,
    this.worksheetJE

  });
}