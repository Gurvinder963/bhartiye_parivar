class ShippingAddressResponse {
  List<ShippingData> data;
  Links links;
  Meta meta;

  ShippingAddressResponse({this.data, this.links, this.meta});

  ShippingAddressResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<ShippingData>();
      json['data'].forEach((v) {
        data.add(new ShippingData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class ShippingData {
  int id;
  String fullName;
  String buildingName;
  String village;
  String landmark;
  String city;
  String tehsil;
  String pincode;
  String state;
  String phoneNumber;
  bool status;
  String displayStatus;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  ShippingData(
      {this.id,
        this.fullName,
        this.buildingName,
        this.village,
        this.landmark,
        this.city,
        this.tehsil,
        this.pincode,
        this.state,
        this.phoneNumber,
        this.status,
        this.displayStatus,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy});

  ShippingData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    buildingName = json['building_name'];
    village = json['village'];
    landmark = json['landmark'];
    city = json['city'];
    tehsil = json['tehsil'];
    pincode = json['pincode'];
    state = json['state'];
    phoneNumber = json['phone_number'];
    status = json['status'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['building_name'] = this.buildingName;
    data['village'] = this.village;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['tehsil'] = this.tehsil;
    data['pincode'] = this.pincode;
    data['state'] = this.state;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}

class Links {
  String first;
  String last;
  Null prev;
  Null next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}