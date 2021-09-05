class VideoData {
  int id;
  String title;
  String videoUrl;
  String videoCategory;
  String videoSourceType;
  String videoImage;
  String publisher;
  String channel;
  int channel_id;
  int content_type;
  String video_duration;
  String lang;
  bool status;
  bool bookmark;
  String displayStatus;
  String createdAt;
//  String createdBy;
  String updatedAt;
  Null updatedBy;

  VideoData({this.id,
    this.title,
    this.videoUrl,
    this.videoCategory,
    this.videoSourceType,
    this.videoImage,
    this.publisher,
    this.channel,
    this.channel_id,
    this.content_type,
    this.video_duration,
    this.lang,
    this.status,
    this.bookmark,
    this.displayStatus,
    this.createdAt,
   // this.createdBy,
    this.updatedAt,
    this.updatedBy});

  VideoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    videoUrl = json['video_url'];
    videoCategory = json['video_category'];
    videoSourceType = json['video_source_type'];
    videoImage = json['video_Image'];
    publisher = json['publisher'];
    channel = json['channel'];
    channel_id = json['channel_id'];
    content_type = json['content_type'];
    video_duration = json['video_duration'];
    lang = json['lang'];
    status = json['status'];
    bookmark = json['bookmark'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
  //  createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['video_url'] = this.videoUrl;
    data['video_category'] = this.videoCategory;
    data['video_source_type'] = this.videoSourceType;
    data['video_Image'] = this.videoImage;
    data['video_duration'] = this.video_duration;
    data['publisher'] = this.publisher;
    data['channel'] = this.channel;
    data['channel_id'] = this.channel_id;
    data['content_type'] = this.content_type;
    data['lang'] = this.lang;
    data['status'] = this.status;
    data['bookmark'] = this.bookmark;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
   // data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}