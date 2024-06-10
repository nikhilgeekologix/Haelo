class ReassignMyTaskModel {
  bool? isUserAllowed;
  String? msg;
  int? result;

  ReassignMyTaskModel({this.isUserAllowed, this.msg, this.result});

  ReassignMyTaskModel.fromJson(Map<String, dynamic> json) {
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
