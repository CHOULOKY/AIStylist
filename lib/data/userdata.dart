class User {
  final String id;
  final String password;
  final String email;
  final String name;
  final String gender;
  final String age;
  final String height;
  final String bodyType;
  final String createdDay;
  final String updatedDay;
  final String preferredStyle;
  final String preferredColor;
  final String avoidStyle;

  User({
    required this.id,
    required this.password,
    required this.email,
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.bodyType,
    required this.createdDay,
    required this.updatedDay,
    required this.preferredStyle,
    required this.preferredColor,
    required this.avoidStyle,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        password: json['password'],
        email: json['email'],
        name: json['name'],
        gender: json['gender'],
        age: json['age'],
        height: json['height'],
        bodyType: json['bodyType'],
        createdDay: json['createdDay'],
        updatedDay: json['updatedDay'],
        preferredStyle: json['preferredStyle'],
        preferredColor: json['preferredColor'],
        avoidStyle: json['avoidStyle'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
    'email': email,
    'name': name,
    'gender': gender,
    'age': age,
    'height': height,
    'bodyType': bodyType,
    'createdDay': createdDay,
    'updatedDay': updatedDay,
    'preferredStyle': preferredStyle,
    'preferredColor': preferredColor,
    'avoidStyle': avoidStyle,
  };
}
