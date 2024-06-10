class AdminUserModel {
  Data? data;
  String? msg;
  int? result;

  AdminUserModel({this.data, this.msg, this.result});

  AdminUserModel.fromJson(Map<String, dynamic> json) {
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
  List<AdminUsers>? adminUsers;
  String? teamInfo;
  String? userInfo;


  Data({this.adminUsers, this.teamInfo, this.userInfo});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['admin_users'] != null) {
      adminUsers = <AdminUsers>[];
      json['admin_users'].forEach((v) {
        adminUsers!.add(new AdminUsers.fromJson(v));
      });
    }
    teamInfo = json['team_info'];
    userInfo = json['user_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.adminUsers != null) {
      data['admin_users'] = this.adminUsers!.map((v) => v.toJson()).toList();
    }
    data['team_info'] = this.teamInfo;
    data['user_info'] = this.userInfo;
    return data;
  }
}

class AdminUsers {
  String? firmId;
  String? firmName;
  String? mobileNo;
  String? userName;

  AdminUsers({this.firmId, this.firmName, this.mobileNo, this.userName});

  AdminUsers.fromJson(Map<String, dynamic> json) {
    firmId = json['firm_id'];
    firmName = json['firm_name'];
    mobileNo = json['mobile_no'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firm_id'] = this.firmId;
    data['firm_name'] = this.firmName;
    data['mobile_no'] = this.mobileNo;
    data['user_name'] = this.userName;
    return data;
  }
}
