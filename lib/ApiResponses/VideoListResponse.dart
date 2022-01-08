import '../ApiResponses/VideoData.dart';
class VideoListResponse {
  List<VideoData> data;
  Live live;

  VideoListResponse({this.data, this.live});

  VideoListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<VideoData>();
      json['data'].forEach((v) {
        data.add(new VideoData.fromJson(v));
      });
    }
    live = json['live'] != null ? new Live.fromJson(json['live']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.live != null) {
      data['live'] = this.live.toJson();
    }
    return data;
  }
}



class Live {
  String liveStatus;
  int liveId;
  String liveTitle;
  String liveVideoUrl;
  String liveVideoSourceType;
  String liveVideoImage;
  String liveChannelId;
  String liveChannel;
  String liveChannelImage;
  String liveScheduledAt;

  Live(
      {this.liveStatus,
        this.liveId,
        this.liveTitle,
        this.liveVideoUrl,
        this.liveVideoSourceType,
        this.liveVideoImage,
        this.liveChannelId,
        this.liveChannel,
        this.liveChannelImage,
        this.liveScheduledAt});

  Live.fromJson(Map<String, dynamic> json) {
    liveStatus = json['live_status'];
    liveId = json['live_id'];
    liveTitle = json['live_title'];
    liveVideoUrl = json['live_video_url'];
    liveVideoSourceType = json['live_video_source_type'];
    liveVideoImage = json['live_video_Image'];
    liveChannelId = json['live_channel_id'];
    liveChannel = json['live_channel'];
    liveChannelImage = json['live_channel_image'];
    liveScheduledAt = json['live_scheduled_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['live_status'] = this.liveStatus;
    data['live_id'] = this.liveId;
    data['live_title'] = this.liveTitle;
    data['live_video_url'] = this.liveVideoUrl;
    data['live_video_source_type'] = this.liveVideoSourceType;
    data['live_video_Image'] = this.liveVideoImage;
    data['live_channel_id'] = this.liveChannelId;
    data['live_channel'] = this.liveChannel;
    data['live_channel_image'] = this.liveChannelImage;
    data['live_scheduled_at'] = this.liveScheduledAt;
    return data;
  }
}