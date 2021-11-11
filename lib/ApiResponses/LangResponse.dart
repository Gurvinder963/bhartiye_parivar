class LangResponse {
  LangData data;

  LangResponse({this.data});

  LangResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new LangData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class LangData {
  int id;
  String uniqueId;
  String appUniqueCode;
  String appLanguage;
  String contentLangauges;
  bool status;
  int createdBy;
  int updatedBy;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String displayStatus;

  LangData(
      {this.id,
        this.uniqueId,
        this.appUniqueCode,
        this.appLanguage,
        this.contentLangauges,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.displayStatus});

  LangData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uniqueId = json['unique_id'];
    appUniqueCode = json['app_unique_code'];
    appLanguage = json['app_language'];
    contentLangauges = json['content_langauges'];
    status = json['status'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    displayStatus = json['display_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unique_id'] = this.uniqueId;
    data['app_unique_code'] = this.appUniqueCode;
    data['app_language'] = this.appLanguage;
    data['content_langauges'] = this.contentLangauges;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['display_status'] = this.displayStatus;
    return data;
  }
}