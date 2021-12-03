class Item {
  Item(
      {this.id,
      this.name,
      this.image,
      this.price,
      this.inFavourite,
      this.beforeDiscount,
      this.inCart,
      this.count});

  int? id;
  String? name;
  String? image;
  String? price;
  String? beforeDiscount;
  bool? inFavourite;
  bool? inCart;
  int? count;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        beforeDiscount: json["before_discount"],
        price: json["price"],
        inFavourite: json["in_favourite"] == 1 ? true : false,
        inCart: json["in_cart"] == 1 ? true : false,
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "price": price,
        "in_favourite": inFavourite,
        "before_discount": beforeDiscount
      };
}
