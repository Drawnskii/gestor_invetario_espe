import 'dart:convert';

class Good {
  String? code;
  String? name;
  int? keeper;
  String? brand;

  Good({
    this.code,
    this.name,
    this.keeper,
    this.brand,
  });

  Good copyWith({
    String? code,
    String? name,
    int? keeper,
    String? brand,
  }) {
    return Good(
      code: code ?? this.code,
      name: name ?? this.name,
      keeper: keeper ?? this.keeper,
      brand: brand ?? this.brand,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'name': name,
      'keeper': keeper,
      'brand': brand,
    };
  }

  Good query(List<Good> goods, code) {
    return goods.firstWhere((good) => good.code == code, orElse: () => Good(code: code));
  }

  factory Good.fromMap(Map<String, dynamic> map) {
    return Good(
      code: map['code'] as String,
      name: map['name'] as String,
      keeper: map['keeper'] as int,
      brand: map['brand'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Good.fromJson(String source) => Good.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Good(code: $code, name: $name, keeper: $keeper, brand: $brand)';
  }

  @override
  bool operator ==(covariant Good other) {
    if (identical(this, other)) return true;
  
    return 
      other.code == code &&
      other.name == name &&
      other.keeper == keeper &&
      other.brand == brand;
  }

  @override
  int get hashCode {
    return code.hashCode ^
      name.hashCode ^
      keeper.hashCode ^
      brand.hashCode;
  }
}
