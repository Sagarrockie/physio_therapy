class User {
  final String name;
  final String mobile;
  final String password;
  final String address;
  final String gender;
  final String age;
  final String link;

  User({
    required this.name,
    required this.mobile,
    required this.password,
    required this.address,
    required this.gender,
    required this.age,
    this.link = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'user': name,
      'mobile': mobile,
      'password': password,
      'address': address,
      'gender': gender,
      'age': age,
      'link': link,
    };
  }
}
