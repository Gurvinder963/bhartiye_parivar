class JoinUsResponse {
  int status;
  Data data;

  JoinUsResponse({this.status, this.data});

  JoinUsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String content;
  String contentMultiple;

  Data({this.content, this.contentMultiple});

  Data.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    contentMultiple = json['content_multiple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['content_multiple'] = this.contentMultiple;
    return data;
  }
}