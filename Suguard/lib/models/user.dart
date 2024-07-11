class User {
  final int id;
  final String username;
  final String? password;  // password는 서버 응답에서 누락될 수 있으므로 nullable로 설정
  final String name;
  final String email;
  final String gender;

  User({
    required this.id,
    required this.username,
    this.password,
    required this.name,
    required this.email,
    required this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'] as String?,  // nullable로 변경
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'email': email,
      'gender': gender,
    };
  }
}
