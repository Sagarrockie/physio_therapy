class User {
  final String uid;
  final String username;
  final String age;
  final String address;
  final String mobile;
  final String gender;
  final String doclink;

  User({
    required this.uid,
    required this.username,
    required this.age,
    required this.address,
    required this.mobile,
    required this.gender,
    required this.doclink,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      username: json['username'],
      age: json['age'],
      address: json['address'],
      mobile: json['mobile'],
      gender: json['gender'],
      doclink: json['doclink'],
    );
  }
}
