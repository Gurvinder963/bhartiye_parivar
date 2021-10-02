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
  int id;
  String orderId;
  String amount;
  Null paymentStatus;
  String createdAt;
  String createdBy;
  String updatedAt;
  Null updatedBy;

  DonateSaveData(
      {this.id,
        this.orderId,
        this.amount,
        this.paymentStatus,
        this.createdAt,
        this.createdBy,
        this.updatedAt,
        this.updatedBy});

  DonateSaveData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    amount = json['amount'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    createdBy = json['created_by'];
    updatedAt = json['updated_at'];
    updatedBy = json['updated_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['amount'] = this.amount;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['created_by'] = this.createdBy;
    data['updated_at'] = this.updatedAt;
    data['updated_by'] = this.updatedBy;
    return data;
  }
}