class ChatGroupResponse {
  List<Chat> chat;

  ChatGroupResponse({this.chat});

  ChatGroupResponse.fromJson(Map<String, dynamic> json) {
    if (json['chat'] != null) {
      chat = new List<Chat>();
      json['chat'].forEach((v) {
        chat.add(new Chat.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chat != null) {
      data['chat'] = this.chat.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chat {
  int chatGroupId;
  String chatGroupTitle;
  String chatGroupPic;
  String chatGroupDis;
  String chatGroupLink;
  String appName;
  String chatGroupLanguage;

  Chat(
      {this.chatGroupId,
        this.chatGroupTitle,
        this.chatGroupPic,
        this.chatGroupDis,
        this.chatGroupLink,
        this.appName,
        this.chatGroupLanguage});

  Chat.fromJson(Map<String, dynamic> json) {
    chatGroupId = json['chat_group_id'];
    chatGroupTitle = json['chat_group_title'];
    chatGroupPic = json['chat_group_pic'];
    chatGroupDis = json['chat_group_dis'];
    chatGroupLink = json['chat_group_link'];
    appName = json['app_name'];
    chatGroupLanguage = json['chat_group_language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chat_group_id'] = this.chatGroupId;
    data['chat_group_title'] = this.chatGroupTitle;
    data['chat_group_pic'] = this.chatGroupPic;
    data['chat_group_dis'] = this.chatGroupDis;
    data['chat_group_link'] = this.chatGroupLink;
    data['app_name'] = this.appName;
    data['chat_group_language'] = this.chatGroupLanguage;
    return data;
  }
}