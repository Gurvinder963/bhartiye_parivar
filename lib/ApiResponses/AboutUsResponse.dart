class AboutUsResponse {
  List<Data> data;

  AboutUsResponse({this.data});

  AboutUsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String header;
  List<Content> content;

  Data({this.header, this.content});

  Data.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    if (json['content'] != null) {
      content = new List<Content>();
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  String subHeader;
  String paraText;
  String fullPictureTop;
  String fullPictureTopCaption;
  String leftPictureTop;
  String leftPictureTopCaption;
  String rightPictureTop;
  String rightPictureTopCaption;
  String videoUrlTop;
  String fullPictureBottom;
  String fullPictureBottomCaption;
  String leftPictureBottom;
  String leftPictureBottomCaption;
  String rightPictureBottom;
  String rightPictureBottomCaption;
  String videoUrlBottom;

  Content(
      {this.subHeader,
      this.paraText,
      this.fullPictureTop,
      this.fullPictureTopCaption,
      this.leftPictureTop,
      this.leftPictureTopCaption,
      this.rightPictureTop,
      this.rightPictureTopCaption,
      this.videoUrlTop,
      this.fullPictureBottom,
      this.fullPictureBottomCaption,
      this.leftPictureBottom,
      this.leftPictureBottomCaption,
      this.rightPictureBottom,
      this.rightPictureBottomCaption,
      this.videoUrlBottom});

  Content.fromJson(Map<String, dynamic> json) {
    subHeader = json['sub_header'];
    paraText = json['para_text'];
    fullPictureTop = json['full_picture_top'];
    fullPictureTopCaption = json['full_picture_top_caption'];
    leftPictureTop = json['left_picture_top'];
    leftPictureTopCaption = json['left_picture_top_caption'];
    rightPictureTop = json['right_picture_top'];
    rightPictureTopCaption = json['right_picture_top_caption'];
    videoUrlTop = json['video_url_top'];
    fullPictureBottom = json['full_picture_bottom'];
    fullPictureBottomCaption = json['full_picture_bottom_caption'];
    leftPictureBottom = json['left_picture_bottom'];
    leftPictureBottomCaption = json['left_picture_bottom_caption'];
    rightPictureBottom = json['right_picture_bottom'];
    rightPictureBottomCaption = json['right_picture_bottom_caption'];
    videoUrlBottom = json['video_url_bottom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_header'] = this.subHeader;
    data['para_text'] = this.paraText;
    data['full_picture_top'] = this.fullPictureTop;
    data['full_picture_top_caption'] = this.fullPictureTopCaption;
    data['left_picture_top'] = this.leftPictureTop;
    data['left_picture_top_caption'] = this.leftPictureTopCaption;
    data['right_picture_top'] = this.rightPictureTop;
    data['right_picture_top_caption'] = this.rightPictureTopCaption;
    data['video_url_top'] = this.videoUrlTop;
    data['full_picture_bottom'] = this.fullPictureBottom;
    data['full_picture_bottom_caption'] = this.fullPictureBottomCaption;
    data['left_picture_bottom'] = this.leftPictureBottom;
    data['left_picture_bottom_caption'] = this.leftPictureBottomCaption;
    data['right_picture_bottom'] = this.rightPictureBottom;
    data['right_picture_bottom_caption'] = this.rightPictureBottomCaption;
    data['video_url_bottom'] = this.videoUrlBottom;
    return data;
  }
}