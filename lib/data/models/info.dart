class Info {
  Info({
    this.success,
    this.dates,
    this.times,
  });

  String? success;
  List<DateTime>? dates;
  List<Time>? times;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        success: json["success"],
        dates: List<DateTime>.from(json["dates"].map((x) => DateTime.parse(x))),
        times: List<Time>.from(json["times"].map((x) => Time.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "dates": List<dynamic>.from(dates!.map((x) =>
            "${x.year.toString().padLeft(4, '0')}-${x.month.toString().padLeft(2, '0')}-${x.day.toString().padLeft(2, '0')}")),
        "times": List<dynamic>.from(times!.map((x) => x.toJson())),
      };
}

class Time {
  Time({
    this.id,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
    this.duration,
  });

  int? id;
  String? startTime;
  String? endTime;
  String? createdAt;
  String? updatedAt;
  String? duration;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        id: json["id"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_time": startTime,
        "end_time": endTime,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "duration": duration,
      };
}
