class SocialMediaResponse {
  String facebook;
  String twitter;
  String youtube;
  String telegram;
  String koo;
  String instagram;

  SocialMediaResponse(
      {this.facebook,
        this.twitter,
        this.youtube,
        this.telegram,
        this.koo,
        this.instagram});

  SocialMediaResponse.fromJson(Map<String, dynamic> json) {
    facebook = json['facebook'];
    twitter = json['twitter'];
    youtube = json['youtube'];
    telegram = json['telegram'];
    koo = json['koo'];
    instagram = json['instagram'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['youtube'] = this.youtube;
    data['telegram'] = this.telegram;
    data['koo'] = this.koo;
    data['instagram'] = this.instagram;
    return data;
  }
}