class PlanDetailsData {
  List<Data>? data;
  String? msg;
  int? result;

  PlanDetailsData({this.data, this.msg, this.result});

  PlanDetailsData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  List<String>? planData;
  String? planName;

  Data({this.planData, this.planName});

  Data.fromJson(Map<String, dynamic> json) {
    planData = json['plan_data'].cast<String>();
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plan_data'] = this.planData;
    data['plan_name'] = this.planName;
    return data;
  }
}
