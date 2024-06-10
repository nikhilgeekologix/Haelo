class LoginVerificationModel {
  String? msg;
  int? result;

  LoginVerificationModel({this.msg, this.result});

  LoginVerificationModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}
