import 'dart:convert';

GoodType goodTypeFromJson(String str) => GoodType.fromJson(json.decode(str));

String goodTypeToJson(GoodType data) => json.encode(data.toJson());

class GoodType {
    int id;
    String name;

    GoodType({
        required this.id,
        required this.name,
    });

    factory GoodType.fromJson(Map<String, dynamic> json) => GoodType(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
