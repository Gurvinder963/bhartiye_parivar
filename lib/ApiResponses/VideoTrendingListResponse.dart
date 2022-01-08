import '../ApiResponses/VideoData.dart';
class VideoTrendingListResponse {
  List<VideoData> data;


  VideoTrendingListResponse({this.data});

  VideoTrendingListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<VideoData>();
      json['data'].forEach((v) {
        data.add(new VideoData.fromJson(v));
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




