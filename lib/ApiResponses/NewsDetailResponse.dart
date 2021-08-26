import '../ApiResponses/NewsData.dart';
class NewsDetailResponse {
  NewsData data;

  NewsDetailResponse({this.data});

  NewsDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new NewsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
