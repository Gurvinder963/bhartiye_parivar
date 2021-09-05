class BookData {
  int id;
  int book_type_id;
  int content_type;
  int books_id;
  String title;
  String description;
  String thumbImage;
  String back_image;
  int cost;
  int ebook_cost;
  int actual_cost;
  int quantity;

  int pageCount;
  String url;
  List images;
  String publisher;
  String langCode;
  String lang_name;
  bool status;
  bool is_ebook_added_cart;
  bool is_printed_added_cart;
  bool is_ebook_purchased;
  bool is_printed_purchased;
  bool is_ebook_free;
  String displayStatus;
  String createdAt;
 // String createdBy;
  String updatedAt;
  Null updatedBy;

  BookData(
      {this.id,
        this.book_type_id,
        this.content_type,
        this.title,
        this.books_id,
        this.description,
        this.thumbImage,
        this.back_image,
        this.cost,
        this.ebook_cost,
        this.actual_cost,
        this.quantity,

        this.pageCount,
        this.url,
       this.images,
        this.publisher,
        this.langCode,
        this.lang_name,
        this.status,
        this.is_ebook_added_cart,
        this.is_printed_added_cart,
        this.is_ebook_purchased,
        this.is_printed_purchased,
        this.is_ebook_free,
        this.displayStatus,
        this.createdAt,
       // this.createdBy,
        this.updatedAt,
        this.updatedBy});

  BookData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    book_type_id = json['book_type_id'];
    content_type = json['content_type'];
    books_id = json['books_id'];
    title = json['title'];
    description = json['description'];
    thumbImage = json['thumb_image'];
    back_image = json['back_image'];
    cost = json['cost'];
    ebook_cost = json['ebook_cost'];
    actual_cost = json['actual_cost'];

    quantity = json['quantity'];


    pageCount = json['page_count'];
    url = json['url'];
    images = json['images'];
    publisher = json['publisher'];
    langCode = json['lang_code'];
    lang_name = json['lang_name'];
    status = json['status'];
    is_ebook_added_cart = json['is_ebook_added_cart'];
    is_printed_added_cart = json['is_printed_added_cart'];
    is_ebook_purchased = json['is_ebook_purchased'];
    is_printed_purchased = json['is_printed_purchased'];
    is_ebook_free = json['is_ebook_free'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
   // createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['book_type_id'] = this.book_type_id;
    data['content_type'] = this.content_type;
    data['books_id'] = this.books_id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumb_image'] = this.thumbImage;
    data['back_image'] = this.back_image;
    data['cost'] = this.cost;
    data['ebook_cost'] = this.ebook_cost;
    data['actual_cost'] = this.actual_cost;

    data['quantity'] = this.quantity;

    data['page_count'] = this.pageCount;
    data['url'] = this.url;
  data['images'] = this.images;
    data['publisher'] = this.publisher;
    data['lang_code'] = this.langCode;
    data['lang_name'] = this.lang_name;
    data['status'] = this.status;
    data['is_ebook_added_cart'] = this.is_ebook_added_cart;
    data['is_printed_added_cart'] = this.is_printed_added_cart;
    data['is_ebook_purchased'] = this.is_ebook_purchased;
    data['is_printed_purchased'] = this.is_printed_purchased;
    data['is_ebook_free'] = this.is_ebook_free;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
   // data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}