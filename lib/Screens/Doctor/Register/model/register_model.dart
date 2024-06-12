// models/doctor.dart
class Doctor {
  final String name;
  final String qualification;
  final String experience;
  final String mobile;
  final String specialization;
  final String userName;
  final String password;

  Doctor({
    required this.name,
    required this.qualification,
    required this.experience,
    required this.mobile,
    required this.specialization,
    required this.userName,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'qualification': qualification,
      'experience': experience,
      'mobile': mobile,
      'specialization': specialization,
      'userName': userName,
      'password': password,
    };
  }
}
