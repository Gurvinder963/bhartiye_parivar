class DonateOrderSaveResponse {
  DonateSaveData data;

  DonateOrderSaveResponse({this.data});

  DonateOrderSaveResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new DonateSaveData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class DonateSaveData {
 
  String orderId;
  String trxntoken;


  DonateSaveData(
      {
        this.orderId,
        this.trxntoken,
     });

  DonateSaveData.fromJson(Map<String, dynamic> json) {
  
    orderId = json['order_id'];
    trxntoken = json['trxntoken'];
 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
   
    data['order_id'] = this.orderId;
    data['trxntoken'] = this.trxntoken;
 
    return data;
  }
}