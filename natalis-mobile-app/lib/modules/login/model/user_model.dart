// lib/features/auth/models/user_model.dart

enum Role { MOTHER, ADMIN, DOCTOR }

class UserModel {
  final String id;
  final String email;
  final Role role;

  const UserModel({
    required this.id,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      role: Role.values.firstWhere(
            (e) => e.name == json['role'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "role": role.name,
    };
  }
}
