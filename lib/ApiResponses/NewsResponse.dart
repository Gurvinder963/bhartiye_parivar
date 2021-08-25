class NewsResponse {
  List<NewsData> data;
  Links links;
  Meta meta;

  NewsResponse({this.data, this.links, this.meta});

  NewsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<NewsData>();
      json['data'].forEach((v) {
        data.add(new NewsData.fromJson(v));
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

class NewsData {
  int id;
  String title;
  int newsType;
  String description;
  List<EmbedUrls> embedUrls;
  bool status;
  String displayStatus;
  String createdAt;
  String updatedAt;

  NewsData(
      {this.id,
        this.title,
        this.newsType,
        this.description,
        this.embedUrls,
        this.status,
        this.displayStatus,
        this.createdAt,
        this.updatedAt});

  NewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    newsType = json['news_type'];
    description = json['description'];
    if (json['embed_urls'] != null) {
      embedUrls = new List<EmbedUrls>();
      json['embed_urls'].forEach((v) {
        embedUrls.add(new EmbedUrls.fromJson(v));
      });
    }
    status = json['status'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['news_type'] = this.newsType;
    data['description'] = this.description;
    if (this.embedUrls != null) {
      data['embed_urls'] = this.embedUrls.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class EmbedUrls {
  int id;
  int newsId;
  String url;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  EmbedUrls(
      {this.id,
        this.newsId,
        this.url,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  EmbedUrls.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    newsId = json['news_id'];
    url = json['url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['news_id'] = this.newsId;
    data['url'] = this.url;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Links {
  String first;
  String last;
  Null prev;
  Null next;

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