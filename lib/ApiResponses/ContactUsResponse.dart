class ContactUsResponse {
  List<Contact> data;

  ContactUsResponse({this.data});

  ContactUsResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Contact>();
      json['data'].forEach((v) {
        data.add(new Contact.fromJson(v));
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

class Contact {
  String header;
  String content1;
  String content2;
  String content3;
  String content4;

  Contact(
      {this.header,
      this.content1,
      this.content2,
      this.content3,
      this.content4});

  Contact.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    content1 = json['content1'];
    content2 = json['content2'];
    content3 = json['content3'];
    content4 = json['content4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    data['content1'] = this.content1;
    data['content2'] = this.content2;
    data['content3'] = this.content3;
    data['content4'] = this.content4;
    return data;
  }
}