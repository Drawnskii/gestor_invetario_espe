import 'goods.dart';

class GoodsResponse {
  int count;
  String? next;
  String? previous;
  List<Goods> results;

  GoodsResponse({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  factory GoodsResponse.fromJson(Map<String, dynamic> json) => GoodsResponse(
        count: json["count"],
        next: json["next"],
        previous: json["previous"],
        results: List<Goods>.from(
            json["results"].map((x) => Goods.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}
