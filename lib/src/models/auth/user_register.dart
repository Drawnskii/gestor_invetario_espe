import 'dart:convert';

UserRegister userRegisterFromJson(String str) => UserRegister.fromJson(json.decode(str));

String userRegisterToJson(UserRegister data) => json.encode(data.toJson());

class UserRegister {
    String username;
    String firstName;
    String lastName;
    String email;
    String password;

    UserRegister({
        required this.username,
        required this.firstName,
        required this.lastName,
        required this.email,
        required this.password,
    });

    factory UserRegister.fromJson(Map<String, dynamic> json) => UserRegister(
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
    };
}
