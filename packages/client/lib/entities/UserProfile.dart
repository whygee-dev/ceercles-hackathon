import 'package:enum_to_string/enum_to_string.dart';

import '../utils/Enums.dart';

class UserProfile {
  String? avatar;
  DateTime birthday;
  Gender gender;

  UserProfile({
    required this.birthday,
    required this.gender,
    this.avatar,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      birthday: DateTime.parse(json["birthday"]),
      gender: EnumToString.fromString(Gender.values, json["gender"])!,
      avatar: json["avatar"],
    );
  }
}
