class GetProfileResponse {
  int id;
  String fullName;
  int age;
  String profession;
  String address;
  int countryCode;
  String mobileNo;

  GetProfileResponse(
      {this.id,
        this.fullName,
        this.age,
        this.profession,
        this.address,
        this.countryCode,
        this.mobileNo});

  GetProfileResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    age = json['age'];
    profession = json['profession'];
    address = json['address'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['age'] = this.age;
    data['profession'] = this.profession;
    data['address'] = this.address;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    return data;
  }
}