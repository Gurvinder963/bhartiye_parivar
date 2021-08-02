class AddToCartResponse {
  int status;


  AddToCartResponse({this.status});

  AddToCartResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;

    return data;
  }
}

