class OTPCountResponse {
  int status;
  MainData data;

  OTPCountResponse({this.status, this.data});

  OTPCountResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new MainData.fromJson(json['data']) : null;
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

class MainData {
  String message;
  OTPData data;

  MainData({this.message, this.data});

  MainData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new OTPData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class OTPData {
  int id;
  String ipAddress;
  String mobile;
  int count;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  OTPData(
      {this.id,
        this.ipAddress,
        this.mobile,
        this.count,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  OTPData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ipAddress = json['ip_address'];
    mobile = json['mobile'];
    count = json['count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ip_address'] = this.ipAddress;
    data['mobile'] = this.mobile;
    data['count'] = this.count;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}