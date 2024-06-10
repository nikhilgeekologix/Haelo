class TaskSelectTeamModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  TaskSelectTeamModel({this.data, this.isUserAllowed, this.msg, this.result});

  TaskSelectTeamModel.fromJson(Map<String, dynamic> json) {
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
  String? firmId;
  List<Team>? team;

  Data({this.firmId, this.team});

  Data.fromJson(Map<String, dynamic> json) {
    firmId = json['firm_id'];
    if (json['team'] != null) {
      team = <Team>[];
      json['team'].forEach((v) {
        team!.add(new Team.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firm_id'] = this.firmId;
    if (this.team != null) {
      data['team'] = this.team!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Team {
  int? memberId;
  String? mobileNo;
  String? userName;

  Team({this.memberId, this.mobileNo, this.userName});

  Team.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    mobileNo = json['mobile_no'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['mobile_no'] = this.mobileNo;
    data['user_name'] = this.userName;
    return data;
  }
}
