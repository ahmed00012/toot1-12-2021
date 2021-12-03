class Favorite {
  Favorite({
    this.id,
    this.userId,
    this.productId,
    this.vendorId,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  int? id;
  int? userId;
  int? productId;
  int? vendorId;
  String? createdAt;
  String? updatedAt;
  Product? product;

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        vendorId: json["vendor_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        product: Product.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "vendor_id": vendorId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "product": product!.toJson(),
      };
}

class Product {
  Product({
    this.id,
    this.subcategoryId,
    this.price,
    this.hasWeight,
    this.imageOne,
    this.imageTwo,
    this.imageThree,
    this.createdAt,
    this.updatedAt,
    this.isSlider,
    this.prepareTime,
    this.beforeDiscount,
    this.quantity,
    this.inFavourite,
    this.averageRate,
    this.name,
    this.description,
    this.subcategory,
    this.rates,
    this.addon,
    this.translations,
  });

  int? id;
  int? subcategoryId;
  String? price;
  int? hasWeight;
  String? imageOne;
  String? imageTwo;
  String? imageThree;
  String? createdAt;
  String? updatedAt;
  int? isSlider;
  String? prepareTime;
  String? beforeDiscount;
  String? quantity;
  int? inFavourite;
  dynamic averageRate;
  String? name;
  String? description;
  Subcategory? subcategory;
  List<dynamic>? rates;
  List<Addon>? addon;
  List<ProductTranslation>? translations;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        subcategoryId: json["subcategory_id"],
        price: json["price"],
        hasWeight: json["has_weight"],
        imageOne: json["image_one"],
        imageTwo: json["image_two"],
        imageThree: json["image_three"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        isSlider: json["is_slider"],
        prepareTime: json["prepare_time"],
        beforeDiscount: json["before_discount"],
        quantity: json["quantity"],
        inFavourite: json["in_favourite"],
        averageRate: json["average_rate"],
        name: json["name"],
        description: json["description"],
        subcategory: Subcategory.fromJson(json["subcategory"]),
        rates: List<dynamic>.from(json["rates"].map((x) => x)),
        addon: List<Addon>.from(json["addon"].map((x) => Addon.fromJson(x))),
        translations: List<ProductTranslation>.from(
            json["translations"].map((x) => ProductTranslation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subcategory_id": subcategoryId,
        "price": price,
        "has_weight": hasWeight,
        "image_one": imageOne,
        "image_two": imageTwo,
        "image_three": imageThree,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "is_slider": isSlider,
        "prepare_time": prepareTime,
        "before_discount": beforeDiscount,
        "quantity": quantity,
        "in_favourite": inFavourite,
        "average_rate": averageRate,
        "name": name,
        "description": description,
        "subcategory": subcategory!.toJson(),
        "rates": List<dynamic>.from(rates!.map((x) => x)),
        "addon": List<dynamic>.from(addon!.map((x) => x.toJson())),
        "translations":
            List<dynamic>.from(translations!.map((x) => x.toJson())),
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

class Subcategory {
  Subcategory({
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
  List<SubcategoryTranslation>? translations;

  factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
        id: json["id"],
        online: json["online"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        image: json["image"],
        name: json["name"],
        translations: List<SubcategoryTranslation>.from(json["translations"]
            .map((x) => SubcategoryTranslation.fromJson(x))),
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

class SubcategoryTranslation {
  SubcategoryTranslation({
    this.id,
    this.subcategoriesId,
    this.locale,
    this.name,
  });

  int? id;
  int? subcategoriesId;
  String? locale;
  String? name;

  factory SubcategoryTranslation.fromJson(Map<String, dynamic> json) =>
      SubcategoryTranslation(
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

class ProductTranslation {
  ProductTranslation({
    this.id,
    this.productId,
    this.locale,
    this.name,
    this.description,
  });

  int? id;
  int? productId;
  String? locale;
  String? name;
  String? description;

  factory ProductTranslation.fromJson(Map<String, dynamic> json) =>
      ProductTranslation(
        id: json["id"],
        productId: json["product_id"],
        locale: json["locale"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "locale": locale,
        "name": name,
        "description": description,
      };
}
