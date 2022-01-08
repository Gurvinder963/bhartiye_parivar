class SideBarApiResponse {
  int status;
  String notificationButtonStatus;
  String sideBarOTP;

  SideBarApiResponse(
      {this.status, this.notificationButtonStatus, this.sideBarOTP});

  SideBarApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notificationButtonStatus = json['notificationButtonStatus'];
    sideBarOTP = json['sideBarOTP'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['notificationButtonStatus'] = this.notificationButtonStatus;
    data['sideBarOTP'] = this.sideBarOTP;
    return data;
  }
}