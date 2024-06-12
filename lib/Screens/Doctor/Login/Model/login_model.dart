class DoctorModel {
  final String docname;
  final String docid;
  final String experience;
  final String specialization;
  final String qualification;
  final String docmobile;
  final String docusername;

  DoctorModel({
    required this.docname,
    required this.docid,
    required this.experience,
    required this.specialization,
    required this.qualification,
    required this.docmobile,
    required this.docusername,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      docname: json['docname'] ?? '',
      docid: json['docid'] ?? '',
      experience: json['experience'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      docmobile: json['docmobile'] ?? '',
      docusername: json['docusername'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docname': docname,
      'docid': docid,
      'experience': experience,
      'specialization': specialization,
      'qualification': qualification,
      'docmobile': docmobile,
      'docusername': docusername,
    };
  }
}
