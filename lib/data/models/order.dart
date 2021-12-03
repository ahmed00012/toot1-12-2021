class Order {
  int? id;
  String? expectedTime;
  int? orderMethodId;
  List<StatusHistories>? statusHistories;

  Order({this.id, this.expectedTime, this.orderMethodId, this.statusHistories});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['order']['id'];
    expectedTime = json['order']['expected_time'];
    orderMethodId = json['order']['order_method_id'];
    if (json['order']['status_histories'] != null) {
      statusHistories = [];
      json['order']['status_histories'].forEach((v) {
        statusHistories!.add(new StatusHistories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order']['id'] = this.id;
    data['order']['expected_time'] = this.expectedTime;
    data['order']['order_method_id'] = this.orderMethodId;
    if (this.statusHistories != null) {
      data['order']['status_histories'] =
          this.statusHistories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusHistories {
  Status? status;

  StatusHistories({this.status});

  StatusHistories.fromJson(Map<String, dynamic> json) {
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.status != null) {
      data['status'] = this.status!.toJson();
    }
    return data;
  }
}

class Status {
  int? id;
  String? name;
  String? nameEn;
  String? createdAt;
  String? updatedAt;
  String? image;
  String? orderMethodId;

  Status(
      {this.id,
      this.name,
      this.nameEn,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.orderMethodId});

  Status.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nameEn = json['name_en'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
    orderMethodId = json['order_method_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['name_en'] = this.nameEn;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image'] = this.image;
    data['order_method_id'] = this.orderMethodId;
    return data;
  }
}
