class CheckDonateResponse {
  List<CheckData> data;

  CheckDonateResponse({this.data});

  CheckDonateResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<CheckData>();
      json['data'].forEach((v) {
        data.add(new CheckData.fromJson(v));
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

class CheckData {
  String channelId;
  String channelImage;
  String channelName;

  CheckData({this.channelId, this.channelImage, this.channelName});

  CheckData.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    channelImage = json['channel_image'];
    channelName = json['channel_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['channel_image'] = this.channelImage;
    data['channel_name'] = this.channelName;
    return data;
  }
}