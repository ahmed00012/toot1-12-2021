class ItemDetails {
  ItemDetails(
      {this.id,
      this.name,
      this.description,
      this.imageOne,
      this.imageTwo,
      this.imageThree,
      this.price,
      this.beforeDiscount,
      this.inFavourite,
      this.unit,
      this.options,
      this.addon,
      this.vendorID});

  int? id;
  String? name;
  String? description;
  String? imageOne;
  String? imageTwo;
  String? imageThree;
  String? price;
  String? beforeDiscount;
  int? inFavourite;
  String? unit;
  List<Option>? options;
  List<Addon>? addon;
  int? vendorID;

  factory ItemDetails.fromJson(Map<String, dynamic> json) => ItemDetails(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imageOne: json["image_one"],
        imageTwo: json["image_two"],
        imageThree: json["image_three"],
        price: json["price"],
        beforeDiscount: json["before_discount"],
        inFavourite: json["in_favourite"],
        unit: json["unit"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        addon: List<Addon>.from(json["addon"].map((x) => Addon.fromJson(x))),
      );
  factory ItemDetails.fromJson2(Map<String, dynamic> json) => ItemDetails(
        id: json["id"],
        name: json["name"],
        // description: json["description"],
        imageOne: json["image_one"],
        // vendorID: json['vendor_id'],

        // imageTwo: json["image_two"],
        // imageThree: json["image_three"],
        // price: json["price"],
        // beforeDiscount: json["before_discount"],
        // inFavourite: json["in_favourite"],
        // unit: json["unit"],
        // options:  List<Option>.from(json["options"].map((x) => Option.fromJson(x)))
        //     ,
        // addon: List<Addon>.from(json["addon"].map((x) => Addon.fromJson(x)))
        //     ,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image_one": imageOne,
        "image_two": imageTwo,
        "image_three": imageThree,
        "price": price,
        "before_discount": beforeDiscount,
        "in_favourite": inFavourite,
        "unit": unit,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
        "addon": List<dynamic>.from(addon!.map((x) => x.toJson())),
      };
}

class Addon {
  Addon({
    this.id,
    this.nameEn,
    this.nameAr,
    this.price,
    this.image,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.pivot,
  });

  int? id;
  String? nameEn;
  String? nameAr;
  String? price;
  dynamic image;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  Pivot? pivot;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json["id"],
        nameEn: json["name_en"],
        nameAr: json["name_ar"],
        price: json["price"],
        image: json["image"],
        isActive: json["is_active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name_en": nameEn,
        "name_ar": nameAr,
        "price": price,
        "image": image,
        "is_active": isActive,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deleted_at": deletedAt,
        "pivot": pivot!.toJson(),
      };
}

class Pivot {
  Pivot({
    this.productId,
    this.addonId,
    this.createdAt,
    this.updatedAt,
  });

  int? productId;
  int? addonId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        productId: json["product_id"],
        addonId: json["addon_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "addon_id": addonId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Option {
  Option({
    this.id,
    this.textEn,
    this.textAr,
    this.price,
  });

  int? id;
  String? textEn;
  String? textAr;
  String? price;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        textEn: json["text_en"],
        textAr: json["text_ar"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_en": textEn,
        "text_ar": textAr,
        "price": price,
      };
}
