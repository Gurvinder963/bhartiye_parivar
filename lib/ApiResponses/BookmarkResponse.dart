import '../ApiResponses/VideoData.dart';
import '../ApiResponses/NewsData.dart';

class BookmarkListResponse {
  int status;
  List<Data> data;

  BookmarkListResponse({this.status, this.data});

  BookmarkListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  int contentType;
  int contentId;
  VideoData video;
  NewsData news;
  bool status;
  String displayStatus;
  Null userId;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
        this.contentType,
        this.contentId,
        this.video,
        this.news,
        this.status,
        this.displayStatus,
        this.userId,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentType = json['content_type'];
    contentId = json['content_id'];
    video = json['video'] != null ? new VideoData.fromJson(json['video']) : null;
    news = json['news'] != null ? new NewsData.fromJson(json['news']) : null;
    status = json['status'];
    displayStatus = json['display_status'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_type'] = this.contentType;
    data['content_id'] = this.contentId;
    if (this.video != null) {
      data['video'] = this.video.toJson();
    }
    if (this.news != null) {
      data['news'] = this.news.toJson();
    }
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}


