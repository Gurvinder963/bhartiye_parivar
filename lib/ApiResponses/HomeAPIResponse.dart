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
  String remainder_date;
  int Amount;
  int cartCount;
  bool notification;

  HomeData({this.message,this.remainder_date,this.Amount, this.cartCount,this.notification});

  HomeData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    Amount = json['Amount'];
    remainder_date = json['remainder_date'];
    cartCount = json['cart-count'];
    notification = json['notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['Amount'] = this.Amount;
    data['remainder_date'] = this.remainder_date;
    data['cart-count'] = this.cartCount;
    data['notification'] = this.notification;
    return data;
  }
}