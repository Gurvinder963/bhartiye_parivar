class FaqDataResponse {
  List<Faqs> faqs;

  FaqDataResponse({this.faqs});

  FaqDataResponse.fromJson(Map<String, dynamic> json) {
    if (json['faqs'] != null) {
      faqs = new List<Faqs>();
      json['faqs'].forEach((v) {
        faqs.add(new Faqs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.faqs != null) {
      data['faqs'] = this.faqs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Faqs {
  String question;
  String answer;

  Faqs({this.question, this.answer});

  Faqs.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}