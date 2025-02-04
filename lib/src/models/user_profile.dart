import 'dart:convert';

UserProfile UserProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String UserProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    String firstName;
    String lastName;
    String username;

    UserProfile({
        required this.firstName,
        required this.lastName,
        required this.username,
    });

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
    };
}
