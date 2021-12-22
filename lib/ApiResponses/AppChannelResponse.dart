class AppChannelResponse {
  List<AppData> data;
  Links links;
  Meta meta;

  AppChannelResponse({this.data, this.links, this.meta});

  AppChannelResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AppData>();
      json['data'].forEach((v) {
        data.add(new AppData.fromJson(v));
      });
    }
    links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}

class AppData {
  int id;
  String appOrChannelUniqueCode;
  String channelImage;
  String appOrChannelNameHindi;
  String appOrChannelNameEnglish;
  String appOrChannelNamePunjabi;
  String appOrChannelNameOdia;
  String appOrChannelNameGujarati;
  String appOrChannelNameMarathi;
  String appOrChannelNameBangla;
  String appOrChannelNameTamil;
  String appOrChannelNameTelugu;
  String appOrChannelNameKannada;
  String appOrChannelNameMalyalam;
  String appOrChannelNameAssamese;
  String appOrChannelNameManipuri;
  String validityTill;
  String appOrChannelStatus;
  String appOrChannelType;
  int appSubscribers;
  int channelSubscribers;
  int subscriptionSquareRoot;
  String ownerUniqueId;
  String associatedNumber;
  String password;
  String ownerName;
  String donationAccountName;
  String donationAccountNumber;
  String donationAccountIfsc;
  String isOrgRegistered;
  String orgRegistrationId;
  String twitterPageLink;
  String kooPageLink;
  String facebookPageLink;
  String instagramPageLink;
  String telegramPageLink;
  String mainPageOrderBy;
  String channelHomeRating;
  String channelHomeBlockedRating;
  String channelTotalHomeRating;
  String channelNewsRating;
  String channelNewsBlockedRating;
  String channelTotalNewsRating;
  String createdAt;
  String updatedAt;

  AppData(
      {this.id,
        this.appOrChannelUniqueCode,
        this.channelImage,
        this.appOrChannelNameHindi,
        this.appOrChannelNameEnglish,
        this.appOrChannelNamePunjabi,
        this.appOrChannelNameOdia,
        this.appOrChannelNameGujarati,
        this.appOrChannelNameMarathi,
        this.appOrChannelNameBangla,
        this.appOrChannelNameTamil,
        this.appOrChannelNameTelugu,
        this.appOrChannelNameKannada,
        this.appOrChannelNameMalyalam,
        this.appOrChannelNameAssamese,
        this.appOrChannelNameManipuri,
        this.validityTill,
        this.appOrChannelStatus,
        this.appOrChannelType,
        this.appSubscribers,
        this.channelSubscribers,
        this.subscriptionSquareRoot,
        this.ownerUniqueId,
        this.associatedNumber,
        this.password,
        this.ownerName,
        this.donationAccountName,
        this.donationAccountNumber,
        this.donationAccountIfsc,
        this.isOrgRegistered,
        this.orgRegistrationId,
        this.twitterPageLink,
        this.kooPageLink,
        this.facebookPageLink,
        this.instagramPageLink,
        this.telegramPageLink,
        this.mainPageOrderBy,
        this.channelHomeRating,
        this.channelHomeBlockedRating,
        this.channelTotalHomeRating,
        this.channelNewsRating,
        this.channelNewsBlockedRating,
        this.channelTotalNewsRating,
        this.createdAt,
        this.updatedAt});

  AppData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appOrChannelUniqueCode = json['app_or_channel_unique_code'];
    channelImage = json['channel_image'];
    appOrChannelNameHindi = json['app_or_channel_name_hindi'];
    appOrChannelNameEnglish = json['app_or_channel_name_english'];
    appOrChannelNamePunjabi = json['app_or_channel_name_punjabi'];
    appOrChannelNameOdia = json['app_or_channel_name_odia'];
    appOrChannelNameGujarati = json['app_or_channel_name_gujarati'];
    appOrChannelNameMarathi = json['app_or_channel_name_marathi'];
    appOrChannelNameBangla = json['app_or_channel_name_bangla'];
    appOrChannelNameTamil = json['app_or_channel_name_tamil'];
    appOrChannelNameTelugu = json['app_or_channel_name_telugu'];
    appOrChannelNameKannada = json['app_or_channel_name_kannada'];
    appOrChannelNameMalyalam = json['app_or_channel_name_malyalam'];
    appOrChannelNameAssamese = json['app_or_channel_name_assamese'];
    appOrChannelNameManipuri = json['app_or_channel_name_manipuri'];
    validityTill = json['validity_till'];
    appOrChannelStatus = json['app_or_channel_status'];
    appOrChannelType = json['app_or_channel_type'];
    appSubscribers = json['app_subscribers'];
    channelSubscribers = json['channel_subscribers'];
    subscriptionSquareRoot = json['subscription_square_root'];
    ownerUniqueId = json['owner_unique_id'];
    associatedNumber = json['associated_number'];
    password = json['password'];
    ownerName = json['owner_name'];
    donationAccountName = json['donation_account_name'];
    donationAccountNumber = json['donation_account_number'];
    donationAccountIfsc = json['donation_account_ifsc'];
    isOrgRegistered = json['is_org_registered'];
    orgRegistrationId = json['org_registration_id'];
    twitterPageLink = json['twitter_page_link'];
    kooPageLink = json['koo_page_link'];
    facebookPageLink = json['facebook_page_link'];
    instagramPageLink = json['instagram_page_link'];
    telegramPageLink = json['telegram_page_link'];
    mainPageOrderBy = json['main_page_order_by'];
    channelHomeRating = json['channel_home_rating'];
    channelHomeBlockedRating = json['channel_home_blocked_rating'];
    channelTotalHomeRating = json['channel_total_home_rating'];
    channelNewsRating = json['channel_news_rating'];
    channelNewsBlockedRating = json['channel_news_blocked_rating'];
    channelTotalNewsRating = json['channel_total_news_rating'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['app_or_channel_unique_code'] = this.appOrChannelUniqueCode;
    data['channel_image'] = this.channelImage;
    data['app_or_channel_name_hindi'] = this.appOrChannelNameHindi;
    data['app_or_channel_name_english'] = this.appOrChannelNameEnglish;
    data['app_or_channel_name_punjabi'] = this.appOrChannelNamePunjabi;
    data['app_or_channel_name_odia'] = this.appOrChannelNameOdia;
    data['app_or_channel_name_gujarati'] = this.appOrChannelNameGujarati;
    data['app_or_channel_name_marathi'] = this.appOrChannelNameMarathi;
    data['app_or_channel_name_bangla'] = this.appOrChannelNameBangla;
    data['app_or_channel_name_tamil'] = this.appOrChannelNameTamil;
    data['app_or_channel_name_telugu'] = this.appOrChannelNameTelugu;
    data['app_or_channel_name_kannada'] = this.appOrChannelNameKannada;
    data['app_or_channel_name_malyalam'] = this.appOrChannelNameMalyalam;
    data['app_or_channel_name_assamese'] = this.appOrChannelNameAssamese;
    data['app_or_channel_name_manipuri'] = this.appOrChannelNameManipuri;
    data['validity_till'] = this.validityTill;
    data['app_or_channel_status'] = this.appOrChannelStatus;
    data['app_or_channel_type'] = this.appOrChannelType;
    data['app_subscribers'] = this.appSubscribers;
    data['channel_subscribers'] = this.channelSubscribers;
    data['subscription_square_root'] = this.subscriptionSquareRoot;
    data['owner_unique_id'] = this.ownerUniqueId;
    data['associated_number'] = this.associatedNumber;
    data['password'] = this.password;
    data['owner_name'] = this.ownerName;
    data['donation_account_name'] = this.donationAccountName;
    data['donation_account_number'] = this.donationAccountNumber;
    data['donation_account_ifsc'] = this.donationAccountIfsc;
    data['is_org_registered'] = this.isOrgRegistered;
    data['org_registration_id'] = this.orgRegistrationId;
    data['twitter_page_link'] = this.twitterPageLink;
    data['koo_page_link'] = this.kooPageLink;
    data['facebook_page_link'] = this.facebookPageLink;
    data['instagram_page_link'] = this.instagramPageLink;
    data['telegram_page_link'] = this.telegramPageLink;
    data['main_page_order_by'] = this.mainPageOrderBy;
    data['channel_home_rating'] = this.channelHomeRating;
    data['channel_home_blocked_rating'] = this.channelHomeBlockedRating;
    data['channel_total_home_rating'] = this.channelTotalHomeRating;
    data['channel_news_rating'] = this.channelNewsRating;
    data['channel_news_blocked_rating'] = this.channelNewsBlockedRating;
    data['channel_total_news_rating'] = this.channelTotalNewsRating;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Links {
  String first;
  String last;
  Null prev;
  Null next;

  Links({this.first, this.last, this.prev, this.next});

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    prev = json['prev'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['prev'] = this.prev;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int currentPage;
  int from;
  int lastPage;
  String path;
  int perPage;
  int to;
  int total;

  Meta(
      {this.currentPage,
        this.from,
        this.lastPage,
        this.path,
        this.perPage,
        this.to,
        this.total});

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}