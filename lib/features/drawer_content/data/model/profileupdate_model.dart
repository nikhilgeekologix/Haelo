class ProfileUpdateModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  ProfileUpdateModel({this.data, this.isUserAllowed, this.msg, this.result});

  ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    isUserAllowed = json['isUserAllowed'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['isUserAllowed'] = this.isUserAllowed;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  String? mobNo;
  String? userName;

  Data({this.mobNo, this.userName});

  Data.fromJson(Map<String, dynamic> json) {
    mobNo = json['mob_no'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mob_no'] = this.mobNo;
    data['user_name'] = this.userName;
    return data;
  }
}
