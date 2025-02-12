class ComplaintType {
 
  final String complaintType;
  final String createdByUser;

  ComplaintType({
   
    required this.complaintType,
    required this.createdByUser,
  });

  factory ComplaintType.fromJson(Map<String, dynamic> json) {
    return ComplaintType(
      
      complaintType: json['complaint_type'],
      createdByUser: json['created_by_user'],
    );
  }
}
