import '../ApiResponses/VideoData.dart';
import '../ApiResponses/NewsData.dart';
import '../ApiResponses/BookData.dart';

class SearchResponse {
  SearchData data;

  SearchResponse({this.data});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new SearchData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class SearchData {
  List<VideoData> videos;
  List<NewsData> news;
  List<BookData> books;

  SearchData({this.videos, this.news, this.books});

  SearchData.fromJson(Map<String, dynamic> json) {
    if (json['videos'] != null) {
      videos = new List<VideoData>();
      json['videos'].forEach((v) {
        videos.add(new VideoData.fromJson(v));
      });
    }
    if (json['news'] != null) {
      news = new List<NewsData>();
      json['news'].forEach((v) {
        news.add(new NewsData.fromJson(v));
      });
    }
    if (json['books'] != null) {
      books = new List<BookData>();
      json['books'].forEach((v) {
        books.add(new BookData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videos != null) {
      data['videos'] = this.videos.map((v) => v.toJson()).toList();
    }
    if (this.news != null) {
      data['news'] = this.news.map((v) => v.toJson()).toList();
    }
    if (this.books != null) {
      data['books'] = this.books.map((v) => v.toJson()).toList();
    }
    return data;
  }
}





