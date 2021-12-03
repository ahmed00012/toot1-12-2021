class Payment {
  Payment({
    this.id,
    this.titleEn,
    this.titleAr,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.code,
  });

  int? id;
  String? titleEn;
  String? titleAr;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? code;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json["id"],
        titleEn: json["title_en"],
        titleAr: json["title_ar"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title_en": titleEn,
        "title_ar": titleAr,
        "image": image,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "code": code,
      };
}
