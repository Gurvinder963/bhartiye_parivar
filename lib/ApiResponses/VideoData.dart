class VideoData {
  int id;
  String title;
  String videoUrl;
  String videoCategory;
  String videoSourceType;
  String videoImage;

  String channel;
  String channel_image;
  String channel_id;
  int content_type;
  int is_like;
  String video_duration;
  String created_at;


  bool bookmark;
  int is_subscribed;


  VideoData({this.id,
    this.title,
    this.videoUrl,
    this.videoCategory,
    this.videoSourceType,
    this.videoImage,

    this.channel,
    this.channel_image,
    this.channel_id,
    this.content_type,
    this.is_like,
    this.video_duration,
    this.created_at,

    this.bookmark,
    this.is_subscribed,

   // this.createdBy,
   });

  VideoData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    videoUrl = json['video_url'];
    videoCategory = json['video_category'];
    videoSourceType = json['video_source_type'];
    videoImage = json['video_Image'];

    channel = json['channel'];
    channel_image = json['channel_image'];
    channel_id = json['channel_id'];
    content_type = json['content_type'];
    is_like = json['is_like'];
    video_duration = json['video_duration'];
    created_at = json['created_at'];

    bookmark = json['bookmark'];
    is_subscribed = json['is_subscribed'];


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
    data['created_at'] = this.created_at;

    data['channel'] = this.channel;
    data['channel_image'] = this.channel_image;
    data['channel_id'] = this.channel_id;
    data['content_type'] = this.content_type;
    data['is_like'] = this.is_like;

    data['bookmark'] = this.bookmark;
    data['is_subscribed'] = this.is_subscribed;

    return data;
  }
}