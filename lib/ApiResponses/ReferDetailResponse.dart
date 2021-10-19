class ReferDetailResponse {
  int status;
  ReferDetailData data;

  ReferDetailResponse({this.status, this.data});

  ReferDetailResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new ReferDetailData.fromJson(json['data']) : null;
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

class ReferDetailData {
  int todayInstall;
  int todayReferred;
  int yesterdayInstall;
  int yesterdayReferred;
  int weekInstall;
  int weekReferred;
  int monthInstall;
  int monthReferred;
  int totalReferred;
  int totalInstall;
  ReferDetailData(
      {this.todayInstall,
        this.todayReferred,
        this.yesterdayInstall,
        this.yesterdayReferred,
        this.weekInstall,
        this.weekReferred,
        this.monthInstall,
        this.monthReferred,
        this.totalInstall,
        this.totalReferred,
      });

  ReferDetailData.fromJson(Map<String, dynamic> json) {
    todayInstall = json['today_install'];
    todayReferred = json['today_referred'];
    yesterdayInstall = json['yesterday_install'];
    yesterdayReferred = json['yesterday_referred'];
    weekInstall = json['week_install'];
    weekReferred = json['week_referred'];
    monthInstall = json['month_install'];
    monthReferred = json['month_referred'];
    totalInstall = json['total_install'];
    totalReferred = json['total_referred'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['today_install'] = this.todayInstall;
    data['today_referred'] = this.todayReferred;
    data['yesterday_install'] = this.yesterdayInstall;
    data['yesterday_referred'] = this.yesterdayReferred;
    data['week_install'] = this.weekInstall;
    data['week_referred'] = this.weekReferred;
    data['month_install'] = this.monthInstall;
    data['month_referred'] = this.monthReferred;
    data['total_install'] = this.totalInstall;
    data['total_referred'] = this.totalReferred;
    return data;
  }
}