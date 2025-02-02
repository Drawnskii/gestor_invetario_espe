import 'dart:convert';

KeeperName keeperNameFromJson(String str) => KeeperName.fromJson(json.decode(str));

String keeperNameToJson(KeeperName data) => json.encode(data.toJson());

class KeeperName {
  int id;
  String firstName;
  String lastName;

  KeeperName({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  factory KeeperName.fromJson(Map<String, dynamic> json) => KeeperName(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
  };
}
