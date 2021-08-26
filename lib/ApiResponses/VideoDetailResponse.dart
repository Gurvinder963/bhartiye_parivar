import '../ApiResponses/VideoData.dart';
class VideoDetailResponse {
  VideoData data;

  VideoDetailResponse({this.data});

  VideoDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new VideoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

