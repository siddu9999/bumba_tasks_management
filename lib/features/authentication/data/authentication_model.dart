class UserModel {
  final int? id; // id can be nullable for new users
  final String email;
  final String password;

  UserModel({this.id, required this.email, required this.password});

  // Convert the UserModel to a Map
  Map<String, dynamic> toMap() {
    final map = {
      'email': email,
      'password': password,
    };
    if (id != null) {
      map['id'] = id as String; // Include id only if it's not null
    }
    return map;
  }

  // Create a UserModel from a Map
  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?, // Ensure id is cast as an int
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
