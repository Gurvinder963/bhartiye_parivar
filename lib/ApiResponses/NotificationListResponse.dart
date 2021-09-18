import '../ApiResponses/NewsData.dart';
import '../ApiResponses/BookData.dart';

class NotificationListResponse {
  int id;
  int contentType;
  int contentId;
  NewsData news;
  BookData book;

  String displayStatus;
  String displayContentType;
  String createdAt;
  String updatedAt;

  NotificationListResponse(
      {this.id,
        this.contentType,
        this.contentId,
        this.news,
        this.book,

        this.displayStatus,
        this.displayContentType,
        this.createdAt,
        this.updatedAt});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contentType = json['content_type'];
    contentId = json['content_id'];
    news = json['news'] != null ? new NewsData.fromJson(json['news']) : null;
    book = json['book'] != null ? new BookData.fromJson(json['book']) : null;
    displayStatus = json['display_status'];
    displayContentType = json['display_content_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content_type'] = this.contentType;
    data['content_id'] = this.contentId;
    if (this.news != null) {
      data['news'] = this.news.toJson();
    }
    if (this.book != null) {
      data['book'] = this.book.toJson();
    }
    data['display_status'] = this.displayStatus;
    data['display_content_type'] = this.displayContentType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

