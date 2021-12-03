class Points {
  Points({
    this.success,
    this.totalPoints,
    this.pointsLimit,
    this.balance,
    this.points,
  });

  String? success;
  int? totalPoints;
  int? pointsLimit;
  int? balance;
  List<Point>? points;

  factory Points.fromJson(Map<String, dynamic> json) => Points(
        success: json["success"],
        totalPoints: json["total_points"],
        pointsLimit: json["points_limit"],
        balance: json["points_to_cash"],
        points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "total_points": totalPoints,
        "points_limit": pointsLimit,
        "balance": balance,
        "points": List<dynamic>.from(points!.map((x) => x.toJson())),
      };
}

class Point {
  Point({
    this.id,
    this.orderId,
    this.points,
    this.expireAt,
    this.converted,
  });

  int? id;
  int? orderId;
  int? points;
  DateTime? expireAt;
  int? converted;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        id: json["id"],
        orderId: json["order_id"],
        points: json["points"],
        expireAt: DateTime.parse(json["expire_at"]),
        converted: json["converted"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "points": points,
        "expire_at":
            "${expireAt!.year.toString().padLeft(4, '0')}-${expireAt!.month.toString().padLeft(2, '0')}-${expireAt!.day.toString().padLeft(2, '0')}",
        "converted": converted,
      };
}
