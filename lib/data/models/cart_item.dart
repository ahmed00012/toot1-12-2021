class CartItem {
  CartItem({
    this.data,
  });

  Data? data;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      data: Data.fromJson(json["data"]),
    );
  }
  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class Data {
  Data(
      {this.id,
      this.subTotal,
      this.discount,
      this.tax,
      this.total,
      this.quantity,
      this.deliveryFee,
      this.pointsToCash,
      this.items,
      this.fastDelivery});

  int? id;
  var subTotal;
  int? discount;
  var tax;
  var total;
  int? quantity;
  String? deliveryFee;
  int? pointsToCash;
  List<Item>? items;
  String? fastDelivery;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        subTotal: json["sub_total"],
        discount: json["discount"],
        tax: json["tax"],
        total: json["total"],
        quantity: json["quantity"],
        deliveryFee: json["delivery_fee"],
        pointsToCash: json["points_to_cash"],
        fastDelivery: json["fast_delivery"].toString(),
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sub_total": subTotal,
        "discount": discount,
        "tax": tax,
        "total": total,
        "quantity": quantity,
        "delivery_fee": deliveryFee,
        "points_to_cash": pointsToCash,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.id,
    this.cartId,
    this.productId,
    this.hasGiftCard,
    this.hasPersonalName,
    this.subTotal,
    this.total,
    this.count,
    this.weightId,
    this.createdAt,
    this.updatedAt,
    this.note,
    this.vendorId,
    this.price,
    this.productName,
    this.productImage,
    this.weight,
    this.cartitemaddon,
    this.cartitemoption,
  });

  int? id;
  int? cartId;
  int? productId;
  int? hasGiftCard;
  int? hasPersonalName;
  var subTotal;
  var total;
  int? count;
  dynamic weightId;
  String? createdAt;
  String? updatedAt;
  dynamic note;
  int? vendorId;
  String? price;
  String? productName;
  String? productImage;
  dynamic weight;
  List<Cartitemaddon>? cartitemaddon;
  List<Cartitemoption>? cartitemoption;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        cartId: json["cart_id"],
        productId: json["product_id"],
        hasGiftCard: json["has_gift_card"],
        hasPersonalName: json["has_personal_name"],
        subTotal: json["sub_total"],
        total: json["total"],
        count: json["count"],
        weightId: json["weight_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        note: json["note"],
        vendorId: json["vendor_id"],
        price: json["price"],
        productName: json["product_name"],
        productImage: json["product_image"],
        weight: json["weight"],
        cartitemaddon: json["cartitemaddon"].length > 0
            ? List<Cartitemaddon>.from(
                json["cartitemaddon"].map((x) => Cartitemaddon.fromJson(x)))
            : [],
        cartitemoption: json["cartitemoption"].length > 0
            ? List<Cartitemoption>.from(
                json["cartitemoption"].map((x) => Cartitemoption.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cart_id": cartId,
        "product_id": productId,
        "has_gift_card": hasGiftCard,
        "has_personal_name": hasPersonalName,
        "sub_total": subTotal,
        "total": total,
        "count": count,
        "weight_id": weightId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "note": note,
        "vendor_id": vendorId,
        "price": price,
        "product_name": productName,
        "product_image": productImage,
        "weight": weight,
        "cartitemaddon":
            List<dynamic>.from(cartitemaddon!.map((x) => x.toJson())),
        "cartitemoption":
            List<dynamic>.from(cartitemoption!.map((x) => x.toJson())),
      };
}

class Cartitemaddon {
  Cartitemaddon({
    this.id,
    this.productId,
    this.cartItemId,
    this.addonId,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
    this.addon,
  });

  int? id;
  int? productId;
  int? cartItemId;
  int? addonId;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // dynamic deletedAt;
  Addon? addon;

  factory Cartitemaddon.fromJson(Map<String, dynamic> json) => Cartitemaddon(
      id: json["id"],
      productId: json["product_id"],
      cartItemId: json["cart_item_id"],
      addonId: json["addon_id"],
      // createdAt: DateTime.parse(json["created_at"]),
      // updatedAt: DateTime.parse(json["updated_at"]),
      // deletedAt: json["deleted_at"],
      addon: json["addon"] != null
          ? Addon.fromJson(
              json["addon"],
            )
          : Addon());

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "cart_item_id": cartItemId,
        "addon_id": addonId,
        // "created_at": createdAt!.toIso8601String(),
        // "updated_at": updatedAt!.toIso8601String(),
        // "deleted_at": deletedAt,
        "addon": addon as Map<String, dynamic>,
      };
}

class Addon {
  Addon({
    this.id,
    // this.nameEn,
    this.nameAr,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
  });

  int? id;
  // String? nameEn;
  String? nameAr;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // DateTime? deletedAt;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        id: json["id"],
        // nameEn: json["name_en"] ?? '',
        nameAr: json["name_ar"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        // deletedAt: DateTime.parse(json["deleted_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        // "name_en": nameEn ?? '',
        "name_ar": nameAr ?? '',
        // "created_at": createdAt!.toIso8601String(),
        // "updated_at": updatedAt!.toIso8601String(),
        // "deleted_at": deletedAt!.toIso8601String(),
      };
}

class Cartitemoption {
  Cartitemoption({
    this.id,
    this.productId,
    this.cartItemId,
    this.optionId,
    this.optionValueId,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
    // this.option,
    this.optionvalue,
  });

  int? id;
  int? productId;
  int? cartItemId;
  int? optionId;
  int? optionValueId;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // dynamic deletedAt;
  // Option? option;
  Optionvalue? optionvalue;

  factory Cartitemoption.fromJson(Map<String, dynamic> json) => Cartitemoption(
        id: json["id"],
        productId: json["product_id"],
        cartItemId: json["cart_item_id"],
        optionId: json["option_id"],
        optionValueId: json["option_value_id"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        // deletedAt: json["deleted_at"],
        // option: Option.fromJson(json["option"]),
        optionvalue: Optionvalue.fromJson(json["optionvalue"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "cart_item_id": cartItemId,
        "option_id": optionId,
        "option_value_id": optionValueId,
        // "created_at": createdAt!.toIso8601String(),
        // "updated_at": updatedAt!.toIso8601String(),
        // "deleted_at": deletedAt,
        // "option": option!.toJson(),
        "optionvalue": optionvalue!.toJson(),
      };
}

class Optionvalue {
  Optionvalue({
    this.id,
    this.optionId,
    // this.valueEn,
    // this.valueAr,
    // this.image,
    // this.createdAt,
    // this.updatedAt,
    // this.deletedAt,
    // this.nameEn,
    this.nameAr,
  });

  int? id;
  int? optionId;
  String? valueEn;
  String? valueAr;
  // dynamic image;
  // DateTime? createdAt;
  // DateTime? updatedAt;
  // dynamic deletedAt;
  // String? nameEn;
  String? nameAr;

  factory Optionvalue.fromJson(Map<String, dynamic> json) => Optionvalue(
        id: json["id"],
        optionId: json["option_id"],
        // valueEn: json["value_en"],
        // valueAr: json["value_ar"],
        // image: json["image"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),
        // deletedAt: json["deleted_at"],
        // nameEn: json["name_en"],
        nameAr: json["name_ar"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "option_id": optionId,
        // "value_en": valueEn,
        // "value_ar": valueAr,
        // "image": image,
        // "created_at": createdAt!.toIso8601String(),
        // "updated_at": updatedAt!.toIso8601String(),
        // "deleted_at": deletedAt,
        // "name_en": nameEn,
        "name_ar": nameAr
      };
}
