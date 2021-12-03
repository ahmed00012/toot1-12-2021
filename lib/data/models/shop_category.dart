class ShopCategory {
  ShopCategory({
    this.id,
    this.online,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.name,
    this.translations,
  });

  int? id;
  int? online;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? name;
  List<Translation>? translations;

  factory ShopCategory.fromJson(Map<String, dynamic> json) => ShopCategory(
        id: json["id"],
        online: json["online"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        image: json["image"],
        name: json["name"],
        translations: List<Translation>.from(
            json["translations"].map((x) => Translation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "online": online,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "image": image,
        "name": name,
        "translations":
            List<dynamic>.from(translations!.map((x) => x.toJson())),
      };
}

class Translation {
  Translation({
    this.id,
    this.subcategoriesId,
    this.locale,
    this.name,
  });

  int? id;
  int? subcategoriesId;
  String? locale;
  String? name;

  factory Translation.fromJson(Map<String, dynamic> json) => Translation(
        id: json["id"],
        subcategoriesId: json["subcategories_id"],
        locale: json["locale"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subcategories_id": subcategoriesId,
        "locale": locale,
        "name": name,
      };
}
