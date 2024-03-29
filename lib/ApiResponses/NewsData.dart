
class NewsData {
  int id;
  int content_type;
  String title;
  int newsType;
  int is_like;
  String description;
  List<EmbedUrls> embedUrls;
  List<Answers> answers;
  bool status;
  bool bookmark;
  String displayStatus;
  String display_news_type;
  String createdAt;
  String updatedAt;

  NewsData(
      {this.id,
      this.content_type,
        this.title,
        this.newsType,
       this.is_like,
        this.description,
        this.embedUrls,
        this.answers,
        this.status,
        this.bookmark,
        this.displayStatus,
        this.display_news_type,
        this.createdAt,
        this.updatedAt});

  NewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content_type = json['content_type'];
    title = json['title'];
    newsType = json['news_type'];
    is_like = json['is_like'];
    description = json['description'];
    if (json['embed_urls'] != null) {
      embedUrls = new List<EmbedUrls>();
      json['embed_urls'].forEach((v) {
        embedUrls.add(new EmbedUrls.fromJson(v));
      });
    }

    if (json['answers'] != null) {
      answers = new List<Answers>();
      json['answers'].forEach((v) {
        answers.add(new Answers.fromJson(v));
      });
    }
    status = json['status'];
    bookmark = json['bookmark'];
    displayStatus = json['display_status'];
    display_news_type = json['display_news_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_type'] = this.content_type;
    data['title'] = this.title;
    data['news_type'] = this.newsType;
    data['is_like'] = this.is_like;
    data['description'] = this.description;
    if (this.embedUrls != null) {
      data['embed_urls'] = this.embedUrls.map((v) => v.toJson()).toList();
    }

    if (this.answers != null) {
      data['answers'] = this.answers.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['bookmark'] = this.bookmark;
    data['display_status'] = this.displayStatus;
    data['display_news_type'] = this.display_news_type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
class Answers {
  int id;
  int newsId;
  String url;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  Answers(
      {this.id,
        this.newsId,
        this.url,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  Answers.fromJson(Map<String, dynamic> json) {
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