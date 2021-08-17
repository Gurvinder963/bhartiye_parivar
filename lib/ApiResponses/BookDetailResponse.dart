import '../ApiResponses/BookData.dart';
class BookDetailResponse {
  BookData data;

  BookDetailResponse({this.data});

  BookDetailResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new BookData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

