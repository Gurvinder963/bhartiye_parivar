class VideoListResponse {
  List<Data> data;
  Links links;
  Meta meta;

  VideoListResponse({this.data, this.links, this.meta});

  VideoListResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String title;
  String videoUrl;
  String videoCategory;
  String videoSourceType;
  String videoImage;
  String publisher;
  String channel;
  int channel_id;
  String video_duration;
  String lang;
  bool status;
  String displayStatus;
  String createdAt;
  String createdBy;
  String updatedAt;
  Null updatedBy;

  Data(
      {this.id,
        this.title,
        this.videoUrl,
        this.videoCategory,
        this.videoSourceType,
        this.videoImage,
        this.publisher,
        this.channel,
        this.channel_id,
        this.video_duration,
        this.lang,
        this.status,
        this.displayStatus,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    videoUrl = json['video_url'];
    videoCategory = json['video_category'];
    videoSourceType = json['video_source_type'];
    videoImage = json['video_Image'];
    publisher = json['publisher'];
    channel = json['channel'];
    channel_id = json['channel_id'];
    video_duration = json['video_duration'];
    lang = json['lang'];
    status = json['status'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
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
    data['lang'] = this.lang;
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}

class Links {
  String first;
  String last;
  String prev;
  String next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}