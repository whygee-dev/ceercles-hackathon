import 'UserProfile.dart';

class User {
  String id;
  String fullname;
  String email;
  UserProfile? profile;
  bool emailVerified;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.emailVerified,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullname: json['fullname'] as String,
      email: json['email'] as String,
      emailVerified: json['emailVerified'] as bool,
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
    );
  }

  setEmailVerified(bool emailVerified) {
    this.emailVerified = emailVerified;

    return emailVerified;
  }
}
