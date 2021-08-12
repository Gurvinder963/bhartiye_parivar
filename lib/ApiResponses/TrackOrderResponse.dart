class TrackOrderResponse {
  List<TrackData> data;
  Links links;
  Meta meta;

  TrackOrderResponse({this.data, this.links, this.meta});

  TrackOrderResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TrackData>();
      json['data'].forEach((v) {
        data.add(new TrackData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class TrackData {
  int id;
  int userId;
  String orderId;
  int total;
  String paymentResponse;
  String paymentStatus;
  List<OrderItems> orderItems;
  String createdAt;
  int createdBy;
  String updatedAt;

  TrackData(
      {this.id,
        this.userId,
        this.orderId,
        this.total,
        this.paymentResponse,
        this.paymentStatus,
        this.orderItems,
        this.createdAt,
        this.createdBy,
        this.updatedAt});

  TrackData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    total = json['total'];
    paymentResponse = json['payment_response'];
    paymentStatus = json['payment_status'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['total'] = this.total;
    data['payment_response'] = this.paymentResponse;
    data['payment_status'] = this.paymentStatus;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class OrderItems {
  int id;
  int bookId;
  String title;
  String description;
  String thumbImage;
  String backImage;
  int bookTypeId;
  String displayBookType;
  int cost;
  int ebookCost;
  int pageCount;
  Null url;
  List<String> images;
  String publisher;
  String langCode;
  bool status;
  String displayStatus;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  OrderItems(
      {this.id,
        this.bookId,
        this.title,
        this.description,
        this.thumbImage,
        this.backImage,
        this.bookTypeId,
        this.displayBookType,
        this.cost,
        this.ebookCost,
        this.pageCount,
        this.url,
        this.images,
        this.publisher,
        this.langCode,
        this.status,
        this.displayStatus,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookId = json['book_id'];
    title = json['title'];
    description = json['description'];
    thumbImage = json['thumb_image'];
    backImage = json['back_image'];
    bookTypeId = json['book_type_id'];
    displayBookType = json['display_book_type'];
    cost = json['cost'];
    ebookCost = json['ebook_cost'];
    pageCount = json['page_count'];
    url = json['url'];
    images = json['images'].cast<String>();
    publisher = json['publisher'];
    langCode = json['lang_code'];
    status = json['status'];
    displayStatus = json['display_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['book_id'] = this.bookId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['thumb_image'] = this.thumbImage;
    data['back_image'] = this.backImage;
    data['book_type_id'] = this.bookTypeId;
    data['display_book_type'] = this.displayBookType;
    data['cost'] = this.cost;
    data['ebook_cost'] = this.ebookCost;
    data['page_count'] = this.pageCount;
    data['url'] = this.url;
    data['images'] = this.images;
    data['publisher'] = this.publisher;
    data['lang_code'] = this.langCode;
    data['status'] = this.status;
    data['display_status'] = this.displayStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}

class Links {
  String first;
  String last;
  Null prev;
  String next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}