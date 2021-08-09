class PinCodeResponse {
  int status;
  PinData data;

  PinCodeResponse({this.status, this.data});

  PinCodeResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new PinData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class PinData {
  String message;
  Address address;

  PinData({this.message, this.address});

  PinData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    return data;
  }
}

class Address {
  int id;
  String pinCode;
  String postOffice;
  String district;
  String region;
  String createdAt;
  Null updatedAt;
  Null deletedAt;

  Address(
      {this.id,
        this.pinCode,
        this.postOffice,
        this.district,
        this.region,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pinCode = json['pin_code'];
    postOffice = json['post_office'];
    district = json['district'];
    region = json['region'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pin_code'] = this.pinCode;
    data['post_office'] = this.postOffice;
    data['district'] = this.district;
    data['region'] = this.region;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}