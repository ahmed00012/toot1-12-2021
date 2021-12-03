class LastOrder {
  LastOrder(
      {this.id,
      this.uuId,
      this.userId,
      this.cartId,
      this.statusId,
      this.createdAt,
      this.updatedAt,
      this.driverId,
      this.expectedTime,
      this.mailSent,
      this.canDelete,
      this.cart,
      this.driver,
      this.status});

  int? id;
  String? uuId;
  int? userId;
  int? cartId;
  int? statusId;
  String? createdAt;
  String? updatedAt;
  String? driverId;
  dynamic expectedTime;
  int? mailSent;
  bool? canDelete;
  Cart? cart;
  LastOrderStatus? status;
  dynamic driver;

  factory LastOrder.fromJson(Map<String, dynamic> json) => LastOrder(
        id: json["id"],
        uuId: json["uuId"],
        userId: json["user_id"],
        cartId: json["cart_id"],
        statusId: json["status_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        driverId: json["driver_id"],
        expectedTime: json["expected_time"],
        mailSent: json["mail_sent"],
        canDelete: json["can_delete"],
        cart: Cart.fromJson(json["cart"]),
        status: LastOrderStatus.fromJson(json["status"]),
        driver: json["driver"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuId": uuId,
        "user_id": userId,
        "cart_id": cartId,
        "status_id": statusId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "driver_id": driverId,
        "expected_time": expectedTime,
        "mail_sent": mailSent,
        "can_delete": canDelete,
        "status": status!.toJson(),
        "cart": cart!.toJson(),
        "driver": driver,
      };
}

class Cart {
  Cart({
    this.id,
    this.token,
    this.userId,
    this.vendorId,
    this.statusId,
    this.subTotal,
    this.discount,
    this.tax,
    this.total,
    this.quantity,
    this.couponId,
    this.addressId,
    this.paymentType,
    this.deliveryDate,
    this.timeId,
    this.points,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.discountType,
    this.orderMethod,
    this.carId,
    this.branchId,
    this.deliveryFee,
    this.pointsToCash,
    this.items,
    this.coupon,
    this.status,
    this.car,
    this.branch,
  });

  int? id;
  String? token;
  int? userId;
  int? vendorId;
  int? statusId;
  String? subTotal;
  dynamic discount;
  String? tax;
  String? total;
  int? quantity;
  dynamic couponId;
  int? addressId;
  String? paymentType;
  DateTime? deliveryDate;
  int? timeId;
  int? points;
  dynamic comment;
  String? createdAt;
  String? updatedAt;
  String? discountType;
  String? orderMethod;
  dynamic carId;
  dynamic branchId;
  String? deliveryFee;
  int? pointsToCash;
  List<Item>? items;
  dynamic coupon;
  CartStatus? status;
  dynamic car;
  dynamic branch;

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        id: json["id"],
        token: json["token"],
        userId: json["user_id"],
        vendorId: json["vendor_id"],
        statusId: json["status_id"],
        subTotal: json["sub_total"].toString(),
        discount: json["discount"],
        tax: json["tax"].toString(),
        total: json["total"].toString(),
        quantity: json["quantity"],
        couponId: json["coupon_id"],
        addressId: json["address_id"],
        paymentType: json["payment_type"],
        timeId: json["time_id"],
        points: json["points"],
        comment: json["comment"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        discountType: json["discount_type"],
        orderMethod: json["order_method"],
        carId: json["car_id"],
        branchId: json["branch_id"],
        deliveryFee: json["delivery_fee"],
        pointsToCash: json["points_to_cash"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        coupon: json["coupon"],
        status: CartStatus.fromJson(json["status"]),
        car: json["car"],
        branch: json["branch"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "user_id": userId,
        "vendor_id": vendorId,
        "status_id": statusId,
        "sub_total": subTotal,
        "discount": discount,
        "tax": tax,
        "total": total,
        "quantity": quantity,
        "coupon_id": couponId,
        "address_id": addressId,
        "payment_type": paymentType,
        "delivery_date":
            "${deliveryDate!.year.toString().padLeft(4, '0')}-${deliveryDate!.month.toString().padLeft(2, '0')}-${deliveryDate!.day.toString().padLeft(2, '0')}",
        "time_id": timeId,
        "points": points,
        "comment": comment,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "discount_type": discountType,
        "order_method": orderMethod,
        "car_id": carId,
        "branch_id": branchId,
        "delivery_fee": deliveryFee,
        "points_to_cash": pointsToCash,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
        "coupon": coupon,
        "status": status!.toJson(),
        "car": car,
        "branch": branch,
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
  });

  int? id;
  int? cartId;
  int? productId;
  int? hasGiftCard;
  int? hasPersonalName;
  int? subTotal;
  int? total;
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

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        cartId: json["cart_id"],
        productId: json["product_id"],
        hasGiftCard: json["has_gift_card"],
        hasPersonalName: json["has_personal_name"],
        subTotal: json["sub_total"].toInt(),
        total: json["total"].toInt(),
        count: json["count"],
        weightId: json["weight_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        note: json["note"],
        vendorId: json["vendor_id"],
        price: json["price"].toString(),
        productName: json["product_name"],
        productImage: json["product_image"],
        weight: json["weight"],
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
      };
}

class LastOrderStatus {
  LastOrderStatus({
    this.id,
    this.name,
    this.nameEn,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.orderMethodId,
  });

  int? id;
  String? name;
  String? nameEn;
  String? createdAt;
  DateTime? updatedAt;
  String? image;
  String? orderMethodId;

  factory LastOrderStatus.fromJson(Map<String, dynamic> json) =>
      LastOrderStatus(
        id: json["id"],
        name: json["name"],
        nameEn: json["name_en"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        orderMethodId: json["order_method_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_en": nameEn,
        "created_at": createdAt,
        "updated_at": updatedAt!.toIso8601String(),
        "image": image,
        "order_method_id": orderMethodId,
      };
}

class StatusClass {
  StatusClass({
    this.id,
    this.name,
    this.nameEn,
    this.createdAt,
    this.updatedAt,
    this.image,
    this.orderMethodId,
  });

  int? id;
  String? name;
  String? nameEn;
  String? createdAt;
  DateTime? updatedAt;
  String? image;
  String? orderMethodId;

  factory StatusClass.fromJson(Map<String, dynamic> json) => StatusClass(
        id: json["id"],
        name: json["name"],
        nameEn: json["name_en"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
        image: json["image"],
        orderMethodId: json["order_method_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name_en": nameEn,
        "created_at": createdAt,
        "updated_at": updatedAt!.toIso8601String(),
        "image": image,
        "order_method_id": orderMethodId,
      };
}

class CartStatus {
  CartStatus({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory CartStatus.fromJson(Map<String, dynamic> json) => CartStatus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
