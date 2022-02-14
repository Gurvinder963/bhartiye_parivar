class JoinUsNewResponse {
  List<JoinData> data;

  JoinUsNewResponse({this.data});

  JoinUsNewResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<JoinData>();
      json['data'].forEach((v) {
        data.add(new JoinData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JoinData {
  String appCode;
  String userid;
  String channelId;
  String socialMedia;
  String timeLevel;
  String donationFrequency;
  String amount;
  String promiseDate;
  String contentMultiple;

  JoinData(
      {this.appCode,
        this.userid,
        this.channelId,
        this.socialMedia,
        this.timeLevel,
        this.donationFrequency,
        this.amount,
        this.promiseDate,
        this.contentMultiple});

  JoinData.fromJson(Map<String, dynamic> json) {
    appCode = json['app_code'];
    userid = json['userid'];
    channelId = json['channel_id'];
    socialMedia = json['social_media'];
    timeLevel = json['time_level'];
    donationFrequency = json['donation_frequency'];
    amount = json['amount'];
    promiseDate = json['promise_date'];
    contentMultiple = json['content_multiple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_code'] = this.appCode;
    data['userid'] = this.userid;
    data['channel_id'] = this.channelId;
    data['social_media'] = this.socialMedia;
    data['time_level'] = this.timeLevel;
    data['donation_frequency'] = this.donationFrequency;
    data['amount'] = this.amount;
    data['promise_date'] = this.promiseDate;
    data['content_multiple'] = this.contentMultiple;
    return data;
  }
}