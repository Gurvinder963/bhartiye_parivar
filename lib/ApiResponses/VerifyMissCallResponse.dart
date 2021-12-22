class VerifyMissCallResponse {
  int status;
  VerifyData data;

  VerifyMissCallResponse({this.status, this.data});

  VerifyMissCallResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new VerifyData.fromJson(json['data']) : null;
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

class VerifyData {
  int verifyStatus;

  VerifyData({this.verifyStatus});

  VerifyData.fromJson(Map<String, dynamic> json) {
    verifyStatus = json['verify_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['verify_status'] = this.verifyStatus;
    return data;
  }
}