class MobileEmailUpdateModel {
  bool? isUserAllowed;
  String? msg;
  int? result;

  MobileEmailUpdateModel({this.isUserAllowed, this.msg, this.result});

  MobileEmailUpdateModel.fromJson(Map<String, dynamic> json) {
    isUserAllowed = json['isUserAllowed'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isUserAllowed'] = this.isUserAllowed;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}
