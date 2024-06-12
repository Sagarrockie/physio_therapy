class Doctor {
  final String docId;
  final String docName;
  final String qualification;
  final String experience;
  final String docMobile;
  final String specialization;
  final String docUsername;
  final String password;
  final String status;
  final String rate; // <-- Added rate attribute

  Doctor({
    required this.docId,
    required this.docName,
    required this.qualification,
    required this.experience,
    required this.docMobile,
    required this.specialization,
    required this.docUsername,
    required this.password,
    required this.status,
    required this.rate, // <-- Initializing the rate attribute
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      docId: json['docid'],
      docName: json['docname'],
      qualification: json['qualification'],
      experience: json['experience'],
      docMobile: json['docmobile'],
      specialization: json['specialization'],
      docUsername: json['docusername'],
      password: json['password'],
      status: json['status'],
      rate: json['rate'], // <-- Getting the rate attribute from JSON
    );
  }
}
