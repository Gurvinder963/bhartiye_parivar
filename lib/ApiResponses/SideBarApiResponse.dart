class SideBarApiResponse {
  int status;
  String notificationButtonStatus;
  String sideBarOTP;
   String join;
    String donate;

  SideBarApiResponse(
      {this.status, this.notificationButtonStatus, this.sideBarOTP});

  SideBarApiResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    notificationButtonStatus = json['notificationButtonStatus'];
    sideBarOTP = json['sideBarOTP'];
    join = json['join'];
    donate = json['donate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['notificationButtonStatus'] = this.notificationButtonStatus;
    data['join'] = this.join;
    data['donate'] = this.donate;
    return data;
  }
}