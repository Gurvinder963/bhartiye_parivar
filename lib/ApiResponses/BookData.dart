class BookData {
  int id;
  String title;
  String description;
  String thumbImage;
  int cost;
  int pageCount;
  String url;
  String images;
  String publisher;
  String langCode;
  bool status;
  String displayStatus;
  String createdAt;
 // String createdBy;
  String updatedAt;
  Null updatedBy;

  BookData(
      {this.id,
        this.title,
        this.description,
        this.thumbImage,
        this.cost,
        this.pageCount,
        this.url,
        this.images,
        this.publisher,
        this.langCode,
        this.status,
        this.displayStatus,
        this.createdAt,
       // this.createdBy,
        this.updatedAt,
        this.updatedBy});

  BookData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    thumbImage = json['thumb_image'];
    cost = json['cost'];
    pageCount = json['page_count'];
    url = json['url'];
    images = json['images'];
    publisher = json['publisher'];
    langCode = json['lang_code'];
    status = json['status'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
   // createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumb_image'] = this.thumbImage;
    data['cost'] = this.cost;
    data['page_count'] = this.pageCount;
    data['url'] = this.url;
    data['images'] = this.images;
    data['publisher'] = this.publisher;
    data['lang_code'] = this.langCode;
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
   // data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}