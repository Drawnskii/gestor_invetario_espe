import 'dart:convert';

List<Goods> goodsFromJson(String str) => List<Goods>.from(json.decode(str).map((x) => Goods.fromJson(x)));

String goodsToJson(List<Goods> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Goods {
    String code;
    String description;
    Keeper keeper;
    Location location;
    Type type;

    Goods({
        required this.code,
        required this.description,
        required this.keeper,
        required this.location,
        required this.type,
    });

    factory Goods.fromJson(Map<String, dynamic> json) => Goods(
        code: json["code"],
        description: json["description"],
        keeper: Keeper.fromJson(json["keeper"]),
        location: Location.fromJson(json["location"]),
        type: Type.fromJson(json["type"]),
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "description": description,
        "keeper": keeper.toJson(),
        "location": location.toJson(),
        "type": type.toJson(),
    };
}

class Keeper {
    int id;
    String firstName;
    String lastName;

    Keeper({
        required this.id,
        required this.firstName,
        required this.lastName,
    });

    factory Keeper.fromJson(Map<String, dynamic> json) => Keeper(
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

class Location {
    int id;
    String name;
    String locationType;

    Location({
        required this.id,
        required this.name,
        required this.locationType,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
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

class Type {
    int id;
    String name;

    Type({
        required this.id,
        required this.name,
    });

    factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
