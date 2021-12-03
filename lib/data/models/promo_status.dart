class PromoStatus {
  PromoStatus({
    this.success,
    this.message,
    this.cart,
  });

  String? success;
  String? message;
  PricesAfterPromo? cart;

  factory PromoStatus.fromJson(Map<String, dynamic> json) => PromoStatus(
        success: json["success"],
        message: json["message"],
        cart: PricesAfterPromo.fromJson(json["cart"]),
      );

  factory PromoStatus.fromJson1(Map<String, dynamic> json) => PromoStatus(
        success: json["success"],
        message: json["message"],
        // cart: PricesAfterPromo.fromJson(json["cart"]),
      );
  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "cart": cart!.toJson(),
      };
}

class PricesAfterPromo {
  PricesAfterPromo({
    this.discount,
    this.subTotal,
    this.total,
  });

  int? discount;
  double? subTotal;
  double? total;

  factory PricesAfterPromo.fromJson(Map<String, dynamic> json) =>
      PricesAfterPromo(
        discount: json["discount"],
        subTotal: json["sub_total"].toDouble(),
        total: json["total"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "discount": discount,
        "sub_total": subTotal,
        "total": total,
      };
}
