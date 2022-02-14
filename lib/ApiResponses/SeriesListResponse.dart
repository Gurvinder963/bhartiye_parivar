class SeriesListResponse {
  List<Series> series;

  SeriesListResponse({this.series});

  SeriesListResponse.fromJson(Map<String, dynamic> json) {
    if (json['series'] != null) {
      series = new List<Series>();
      json['series'].forEach((v) {
        series.add(new Series.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.series != null) {
      data['series'] = this.series.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Series {
  int seriesId;
  String seriesName;
  int videoId;
  String title;
  String videoUrl;
  String videoSourceType;
  String videoDuration;
  int watchedPercent;
  String videoImage;
  String channelId;
  String channel;
  String channelImage;
  String createdAt;
  int contentType;
  int isLike;
  int isSubscribed;
  bool bookmark;
  String videoCategory;

  Series(
      {this.seriesId,
        this.seriesName,
        this.videoId,
        this.title,
        this.videoUrl,
        this.videoSourceType,
        this.videoDuration,
        this.watchedPercent,
        this.videoImage,
        this.channelId,
        this.channel,
        this.channelImage,
        this.createdAt,
        this.contentType,
        this.isLike,
        this.isSubscribed,
        this.bookmark,
        this.videoCategory});

  Series.fromJson(Map<String, dynamic> json) {
    seriesId = json['series_id'];
    seriesName = json['series_name'];
    videoId = json['video_id'];
    title = json['title'];
    videoUrl = json['video_url'];
    videoSourceType = json['video_source_type'];
    videoDuration = json['video_duration'];
    watchedPercent = json['watched_percent'];
    videoImage = json['video_Image'];
    channelId = json['channel_id'];
    channel = json['channel'];
    channelImage = json['channel_image'];
    createdAt = json['created_at'];
    contentType = json['content_type'];
    isLike = json['is_like'];
    isSubscribed = json['is_subscribed'];
    bookmark = json['bookmark'];
    videoCategory = json['video_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['series_id'] = this.seriesId;
    data['series_name'] = this.seriesName;
    data['video_id'] = this.videoId;
    data['title'] = this.title;
    data['video_url'] = this.videoUrl;
    data['video_source_type'] = this.videoSourceType;
    data['video_duration'] = this.videoDuration;
    data['watched_percent'] = this.watchedPercent;
    data['video_Image'] = this.videoImage;
    data['channel_id'] = this.channelId;
    data['channel'] = this.channel;
    data['channel_image'] = this.channelImage;
    data['created_at'] = this.createdAt;
    data['content_type'] = this.contentType;
    data['is_like'] = this.isLike;
    data['is_subscribed'] = this.isSubscribed;
    data['bookmark'] = this.bookmark;
    data['video_category'] = this.videoCategory;
    return data;
  }
}