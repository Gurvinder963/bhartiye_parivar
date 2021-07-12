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
  int board_id;
  int class_id;
  int points_earned;
  int points_available;
  int points_for_use;
  String uuid;
  String firstName;
  String lastName;
  String email;
  String contact_number;
  String avatarType;
  String avatarLocation;
  String passwordChangedAt;
  bool active;
  String confirmationCode;
  bool confirmed;
  String timezone;
  String lastLoginAt;
  String lastLoginIp;
  bool toBeLoggedOut;
  bool status;
  String createdBy;
  String updatedBy;
  int isTermAccept;
  String createdAt;
  String updatedAt;
  String deletedAt;
  String fullName;
  String board;
  String class_name;
  String referral_code;

  User(
      {this.id,
      this.board_id,
      this.class_id,
        this.points_earned,
        this.points_available,
        this.points_for_use,
        this.uuid,
        this.firstName,
        this.lastName,
        this.email,
        this.contact_number,
        this.avatarType,
        this.avatarLocation,
        this.passwordChangedAt,
        this.active,
        this.confirmationCode,
        this.confirmed,
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
        this.fullName,
      this.class_name,
        this.board,
        this.referral_code
      });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    board_id = json['board_id'];
    class_id = json['class_id'];
    points_earned = json['points_earned'];
    points_available = json['points_available'];
    points_for_use = json['points_for_use'];
    uuid = json['uuid'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    contact_number = json['contact_number'];
    avatarType = json['avatar_type'];
    avatarLocation = json['avatar_location'];
    passwordChangedAt = json['password_changed_at'];
    active = json['active'];
    confirmationCode = json['confirmation_code'];
    confirmed = json['confirmed'];
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
    class_name = json['class'];
    board = json['board'];
    referral_code = json['referral_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['board_id'] = this.board_id;
    data['class_id'] = this.class_id;
    data['points_earned'] = this.points_earned;
    data['points_available'] = this.points_available;
    data['points_for_use'] = this.points_for_use;
    data['uuid'] = this.uuid;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['contact_number'] = this.contact_number;
    data['avatar_type'] = this.avatarType;
    data['avatar_location'] = this.avatarLocation;
    data['password_changed_at'] = this.passwordChangedAt;
    data['active'] = this.active;
    data['confirmation_code'] = this.confirmationCode;
    data['confirmed'] = this.confirmed;
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
    data['class_name'] = this.class_name;
    data['board'] = this.board;
    data['referral_code'] = this.referral_code;
    return data;
  }
}