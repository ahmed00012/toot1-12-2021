class Address {
  Address({
    this.id,
    this.userId,
    this.cityId,
    this.regionId,
    this.address,
    this.buildingNo,
    this.floorNo,
    this.flatNo,
    this.street,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
    this.block,
    this.district,
    this.company,
    this.extra,
    this.linkToGoogleMap,
    this.city,
    this.region,
  });

  int? id;
  int? userId;
  int? cityId;
  int? regionId;
  String? address;
  dynamic buildingNo;
  dynamic floorNo;
  dynamic flatNo;
  dynamic street;
  String? lat;
  String? lng;
  String? createdAt;
  String? updatedAt;
  dynamic block;
  String? district;
  dynamic company;
  dynamic extra;
  String? linkToGoogleMap;
  dynamic city;
  dynamic region;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        userId: json["user_id"],
        cityId: json["city_id"],
        regionId: json["region_id"],
        address: json["address"],
        buildingNo: json["building_no"],
        floorNo: json["floor_no"],
        flatNo: json["flat_no"],
        street: json["street"],
        lat: json["lat"],
        lng: json["lng"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        block: json["block"],
        district: json["district"],
        company: json["company"],
        extra: json["extra"],
        linkToGoogleMap: json["link_to_google_map"],
        city: json["city"],
        region: json["region"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "city_id": cityId,
        "region_id": regionId,
        "address": address,
        "building_no": buildingNo,
        "floor_no": floorNo,
        "flat_no": flatNo,
        "street": street,
        "lat": lat,
        "lng": lng,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "block": block,
        "district": district,
        "company": company,
        "extra": extra,
        "link_to_google_map": linkToGoogleMap,
        "city": city,
        "region": region,
      };
}
