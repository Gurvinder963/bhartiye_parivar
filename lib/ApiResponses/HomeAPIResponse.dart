class HomeAPIResponse {
  int status;
  HomeData data;

  HomeAPIResponse({this.status, this.data});

  HomeAPIResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new HomeData.fromJson(json['data']) : null;
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

class HomeData {
  String message;
  int cartCount;

  HomeData({this.message, this.cartCount});

  HomeData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    cartCount = json['cart-count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['cart-count'] = this.cartCount;
    return data;
  }
}