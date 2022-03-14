class DonateHomePageResponse {
  List<DonateHome> data;

  DonateHomePageResponse({this.data});

  DonateHomePageResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<DonateHome>();
      json['data'].forEach((v) {
        data.add(new DonateHome.fromJson(v));
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

class DonateHome {
  String onlinePayment;
  String accountDeposit;
  String donateUsLink;
  String donateUsVideo;
  String paytmKey;
  String paytmPass;
  String accountName;
  String accountNumber;
  String accountType;
  String ifsc;
  String bankName;
  String upiId;
  String upiButton;
  String mid;
  String gateway;

  DonateHome(
      {this.onlinePayment,
      this.accountDeposit,
      this.donateUsLink,
      this.donateUsVideo,
      this.paytmKey,
      this.paytmPass,
      this.accountName,
      this.accountNumber,
      this.accountType,
      this.ifsc,
      this.bankName,
      this.upiId,
      this.upiButton,
      this.mid,
      this.gateway
      
      });

  DonateHome.fromJson(Map<String, dynamic> json) {
    onlinePayment = json['online_payment'];
    accountDeposit = json['account_deposit'];
    donateUsLink = json['donate_us_link'];
    donateUsVideo = json['donate_us_video'];
    paytmKey = json['paytm_key'];
    paytmPass = json['paytm_pass'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    accountType = json['account_type'];
    ifsc = json['ifsc'];
    bankName = json['bank_name'];
    upiId = json['upi_id'];
    upiButton = json['upi_button'];

    mid = json['mid'];
    gateway = json['gateway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['online_payment'] = this.onlinePayment;
    data['account_deposit'] = this.accountDeposit;
    data['donate_us_link'] = this.donateUsLink;
    data['donate_us_video'] = this.donateUsVideo;
    data['paytm_key'] = this.paytmKey;
    data['paytm_pass'] = this.paytmPass;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['account_type'] = this.accountType;
    data['ifsc'] = this.ifsc;
    data['bank_name'] = this.bankName;
    data['upi_id'] = this.upiId;
    data['upi_button'] = this.upiButton;

    data['mid'] = this.mid;
    data['gateway'] = this.gateway;
    return data;
  }
}