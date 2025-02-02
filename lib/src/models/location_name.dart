import 'dart:convert';

LocationName locationNameFromJson(String str) => LocationName.fromJson(json.decode(str));

String locationNameToJson(LocationName data) => json.encode(data.toJson());

class LocationName {
  int id;
  String name;
  String locationType;

  LocationName({
    required this.id,
    required this.name,
    required this.locationType,
  });

  factory LocationName.fromJson(Map<String, dynamic> json) => LocationName(
    id: json["id"],
    name: json["name"],
    locationType: json["location_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "location_type": locationType,
  };
}
