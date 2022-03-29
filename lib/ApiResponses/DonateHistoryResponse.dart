class DonateHistoryResponse {
  List<DonateHistoryData> data;
 

  DonateHistoryResponse({this.data});

  DonateHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DonateHistoryData>();
      json['data'].forEach((v) {
        data.add(new DonateHistoryData.fromJson(v));
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

class DonateHistoryData {
 
  String orderId;
  String amount;
  String paymentStatus;
  String createdAt;
  String url;
  String paid_to;


  DonateHistoryData(
      {
        this.orderId,
        this.amount,
        this.paymentStatus,
        this.createdAt,
        this.url,
        this.paid_to
     });

  DonateHistoryData.fromJson(Map<String, dynamic> json) {

    orderId = json['order_id'];
    amount = json['amount'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    url = json['url'];
     paid_to = json['paid_to'];
 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
  
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['url'] = this.url;
    data['paid_to'] = this.paid_to;

    return data;
  }
}


