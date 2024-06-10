class ProfileModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  ProfileModel({this.data, this.isUserAllowed, this.msg, this.result});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  UserList? userList;

  Data({this.userList});

  Data.fromJson(Map<String, dynamic> json) {
    userList = json['user_list'] != null ? new UserList.fromJson(json['user_list']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userList != null) {
      data['user_list'] = this.userList!.toJson();
    }
    return data;
  }
}

class UserList {
  String? firmId;
  String? firmName;
  String? mobNo;
  String? userName;
  String? userPic;

  UserList({this.firmId, this.firmName, this.mobNo, this.userName, this.userPic});

  UserList.fromJson(Map<String, dynamic> json) {
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    mobNo = json['mob_no'];
    userName = json['user_name'];
    userPic = json['user_pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['mob_no'] = this.mobNo;
    data['user_name'] = this.userName;
    data['user_pic'] = this.userPic;
    return data;
  }
}
