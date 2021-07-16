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
  String firstName;
  String lastName;
  String email;
  String mobileNo;
  int age;
  String profession;
  String avatarType;
  Null avatarLocation;
  String address;
  Null passwordChangedAt;
  bool active;
  String confirmationCode;
  bool confirmed;
  int countryCode;
  String timezone;
  String lastLoginAt;
  String lastLoginIp;
  bool toBeLoggedOut;
  bool status;
  int createdBy;
  Null updatedBy;
  int isTermAccept;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String fullName;

  User(
      {this.id,
        this.uuid,
        this.firstName,
        this.lastName,
        this.email,
        this.mobileNo,
        this.age,
        this.profession,
        this.avatarType,
        this.avatarLocation,
        this.address,
        this.passwordChangedAt,
        this.active,
        this.confirmationCode,
        this.confirmed,
        this.countryCode,
        this.timezone,
        this.lastLoginAt,
        this.lastLoginIp,
        this.toBeLoggedOut,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.isTermAccept,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    age = json['age'];
    profession = json['profession'];
    avatarType = json['avatar_type'];
    avatarLocation = json['avatar_location'];
    address = json['address'];
    passwordChangedAt = json['password_changed_at'];
    active = json['active'];
    confirmationCode = json['confirmation_code'];
    confirmed = json['confirmed'];
    countryCode = json['country_code'];
    timezone = json['timezone'];
    lastLoginAt = json['last_login_at'];
    lastLoginIp = json['last_login_ip'];
    toBeLoggedOut = json['to_be_logged_out'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    isTermAccept = json['is_term_accept'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile_no'] = this.mobileNo;
    data['age'] = this.age;
    data['profession'] = this.profession;
    data['avatar_type'] = this.avatarType;
    data['avatar_location'] = this.avatarLocation;
    data['address'] = this.address;
    data['password_changed_at'] = this.passwordChangedAt;
    data['active'] = this.active;
    data['confirmation_code'] = this.confirmationCode;
    data['confirmed'] = this.confirmed;
    data['country_code'] = this.countryCode;
    data['timezone'] = this.timezone;
    data['last_login_at'] = this.lastLoginAt;
    data['last_login_ip'] = this.lastLoginIp;
    data['to_be_logged_out'] = this.toBeLoggedOut;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['is_term_accept'] = this.isTermAccept;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['full_name'] = this.fullName;
    return data;
  }
}