enum BodyType { SLIM, ATHLETIC, AVERAGE, CHUBBY, OVERWEIGHT }

class User {
  final String email;
  final String name;
  final String? gender;
  final String? age;
  final String? height;
  final String? bodyType;
  final String? preferredStyle;
  final String? preferredColor;
  final String? avoidStyle;

  User({
    required this.email,
    required this.name,
    this.gender,
    this.age,
    this.height,
    this.bodyType,
    this.preferredStyle,
    this.preferredColor,
    this.avoidStyle,
  });

  // JSON -> 객체
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String?,
      age: json['age'] as String?,
      height: json['height'] as String?,
      bodyType: json['bodyType'] as String?,
      preferredStyle: json['preferredStyle'] as String?,
      preferredColor: json['preferredColor'] as String?,
      avoidStyle: json['avoidStyle'] as String?,
    );
  }
  // 객체 -> JSON
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'email': email,
      'name': name,
    };
    if (gender != null)       map['gender'] = gender;
    if (age != null)          map['age'] = age;
    if (height != null)       map['height'] = height;
    if (bodyType != null)     map['bodyType'] = bodyType;
    if (preferredStyle != null)  map['preferredStyle'] = preferredStyle;
    if (preferredColor != null)  map['preferredColor'] = preferredColor;
    if (avoidStyle != null)      map['avoidStyle'] = avoidStyle;
    return map;
  }
}
