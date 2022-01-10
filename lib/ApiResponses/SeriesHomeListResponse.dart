class SeriesHomeListResponse {
  List<Series> series;

  SeriesHomeListResponse({this.series});

  SeriesHomeListResponse.fromJson(Map<String, dynamic> json) {
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
  String channelId;
  String seriesTitle;
  String seriesThumbnail;
  int totalVideos;
  String appIcon;
  String appName;

  Series(
      {this.seriesId,
        this.channelId,
        this.seriesTitle,
        this.seriesThumbnail,
        this.totalVideos,
        this.appIcon,
        this.appName});

  Series.fromJson(Map<String, dynamic> json) {
    seriesId = json['series_id'];
    channelId = json['channel_id'];
    seriesTitle = json['series_title'];
    seriesThumbnail = json['series_thumbnail'];
    totalVideos = json['total_videos'];
    appIcon = json['app_icon'];
    appName = json['app_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['series_id'] = this.seriesId;
    data['channel_id'] = this.channelId;
    data['series_title'] = this.seriesTitle;
    data['series_thumbnail'] = this.seriesThumbnail;
    data['total_videos'] = this.totalVideos;
    data['app_icon'] = this.appIcon;
    data['app_name'] = this.appName;
    return data;
  }
}