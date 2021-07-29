class OTPResponse {
  String id;
  String errorCode;
  String errorMessage;
  String jobId;
  List<MessageData> messageData;

  OTPResponse(
      {this.id,
        this.errorCode,
        this.errorMessage,
        this.jobId,
        this.messageData});

  OTPResponse.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    jobId = json['JobId'];
    if (json['MessageData'] != null) {
      messageData = new List<MessageData>();
      json['MessageData'].forEach((v) {
        messageData.add(new MessageData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    data['JobId'] = this.jobId;
    if (this.messageData != null) {
      data['MessageData'] = this.messageData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MessageData {
  String id;
  String number;
  String messageId;

  MessageData({this.id, this.number, this.messageId});

  MessageData.fromJson(Map<String, dynamic> json) {
    id = json['$id'];
    number = json['Number'];
    messageId = json['MessageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$id'] = this.id;
    data['Number'] = this.number;
    data['MessageId'] = this.messageId;
    return data;
  }
}