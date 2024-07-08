class User {
  String? id;
  String? name;
  String? email;
  String? image;
  String? password;
  String? gender;
  String? token;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.gender,
    this.token,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handling the nested user object
    final userJson = json['user'] ?? json;

    return User(
      id: userJson['_id'] as String?,
      name: userJson['name'] as String?,
      email: userJson['email'] as String?,
      password: userJson['password'] as String?,
      image: userJson['image'] as String?,

      token: json['token'] as String?,
      gender: userJson['gender'] as String?, // Token is at the root level
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id, // Include id if you want to save it
      'name': name,
      'email': email,
      'password': password,
      'image': image,
      'token': token,
      'gender': gender
    };
  }
}
