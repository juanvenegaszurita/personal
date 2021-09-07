class PasswordModel {
  final String id;
  final String group;
  final String name;
  final String user;
  final String email;
  final String password;
  final String details;

  PasswordModel({
    required this.id,
    required this.group,
    required this.name,
    required this.user,
    required this.email,
    required this.password,
    required this.details,
  });

  factory PasswordModel.fromMap(Map data) {
    return PasswordModel(
      id: data['id'],
      group: data['group'],
      name: data['name'],
      user: data['user'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      details: data['details'] ?? '',
    );
  }

  PasswordModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        group = json['group'],
        name = json['name'],
        user = json['user'],
        email = json['email'],
        password = json['password'],
        details = json['details'];

  Map<String, dynamic> toJson() => {
        'group': group,
        'name': name,
        'user': user,
        'email': email,
        'password': password,
        'details': details,
      };
}
