class Category {
  Category({
    this.categoryName,
    this.image,
    this.markets,
  });

  String? categoryName;
  List<Market>? markets;
  String? image;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
      categoryName: json["category_name"],
      markets:
          List<Market>.from(json["markets"].map((x) => Market.fromJson(x))),
      image: json["image"]);
}

class Market {
  Market({this.id, this.image, this.name, this.isReciving});

  int? id;
  String? image;
  String? name;
  int? isReciving;

  factory Market.fromJson(Map<String, dynamic> json) => Market(
        id: json["id"],
        image: json["image"] == null ? null : json["image"],
        name: json["name"],
        isReciving: json["is_reciving"],
      );
}
