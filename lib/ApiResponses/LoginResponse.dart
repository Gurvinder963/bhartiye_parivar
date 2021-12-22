class LoginResponse {
  int status;

  Data data;

  LoginResponse({this.status, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  String message;
  String token;
  User user;

  Data({this.message, this.token, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String uuid;


  String mobileNo;
  int age;
  int country_code;
  String profession;


  String address;






  String fullName;

  User(
      {this.id,
        this.uuid,
        this.country_code,

        this.mobileNo,
        this.age,
        this.profession,

        this.address,




        this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    country_code = json['country_code'];

    mobileNo = json['mobile_no'];
    age = json['age'];
    profession = json['profession'];

    address = json['address'];




    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;

    data['mobile_no'] = this.mobileNo;
    data['country_code'] = this.country_code;
    data['age'] = this.age;
    data['profession'] = this.profession;

    data['address'] = this.address;




    data['full_name'] = this.fullName;
    return data;
  }
}