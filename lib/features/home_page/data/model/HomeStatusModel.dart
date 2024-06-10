class HomeStatusModel {
  Data? data;
  String? msg;
  int? result;

  HomeStatusModel({this.data, this.msg, this.result});

  HomeStatusModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  int? id;
  String? messageBody;
  String? messageTitle;

  Data({this.id, this.messageBody, this.messageTitle});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    messageBody = json['message_body'];
    messageTitle = json['message_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message_body'] = this.messageBody;
    data['message_title'] = this.messageTitle;
    return data;
  }
}
