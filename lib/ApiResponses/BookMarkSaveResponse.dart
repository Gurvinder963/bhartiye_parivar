class BookMarkSaveResponse {
  int bookmarkType;

  BookMarkSaveResponse({this.bookmarkType});

  BookMarkSaveResponse.fromJson(Map<String, dynamic> json) {
    bookmarkType = json['bookmark_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookmark_type'] = this.bookmarkType;
    return data;
  }
}