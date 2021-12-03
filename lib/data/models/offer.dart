class Offer {
  Offer({
    this.id,
    this.title,
    this.description,
    this.image,
    this.orderId,
  });

  int? id;
  String? title;
  String? description;
  String? image;
  dynamic orderId;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        orderId: json["order_id"],
      );
}
