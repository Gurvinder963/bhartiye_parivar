class BookData {
  int id;
  String title;
  String description;
  String thumbImage;
  String thumbnail_image;
  int cost;
  String qty='1';
  int totalCost;
  int pageCount;
  String url;
 // String images;
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
        this.thumbnail_image,
        this.cost,
        this.qty,
        this.totalCost,
        this.pageCount,
        this.url,
      //  this.images,
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
    thumbnail_image = json['thumbnail_image'];
    cost = json['cost'];
    totalCost = json['cost'];


    pageCount = json['page_count'];
    url = json['url'];
   // images = json['images'];
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
    data['thumbnail_image'] = this.thumbnail_image;
    data['cost'] = this.cost;
    data['totalCost'] = this.cost;
    data['qty'] = this.qty;
    data['totalCost'] = this.totalCost;
    data['page_count'] = this.pageCount;
    data['url'] = this.url;
   // data['images'] = this.images;
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