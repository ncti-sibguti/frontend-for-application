import 'dart:convert';

class User {
  int id;
  String firstname;
  String lastname;
  String surname;
  String email;
  String? chat;

  List<Map<String, dynamic>> role;

  User(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.surname,
      required this.email,
      required this.chat,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        surname: json['surname'],
        email: json['email'],
        chat: json['chat'],
        role: List<Map<String, dynamic>>.from(json['role']));
  }
}

List<User> parseUsers(String jsonString) {
  final jsonData = json.decode(jsonString).cast<Map<String, dynamic>>();
  return jsonData.map<User>((json) => User.fromJson(json)).toList();
}
