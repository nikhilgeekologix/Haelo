class MySubscriptionModel {
  Data? data;
  String? msg;
  int? result;

  MySubscriptionModel({this.data, this.msg, this.result});

  MySubscriptionModel.fromJson(Map<String, dynamic> json) {
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
  List<ActivePlans>? activePlans;
  List<ActivePlans>? expirePlans;

  Data({this.activePlans, this.expirePlans});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['active_plans'] != null) {
      activePlans = <ActivePlans>[];
      json['active_plans'].forEach((v) {
        activePlans!.add(new ActivePlans.fromJson(v));
      });
    }
    if (json['expire_plans'] != null) {
      expirePlans = <ActivePlans>[];
      json['expire_plans'].forEach((v) {
        expirePlans!.add(new ActivePlans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.activePlans != null) {
      data['active_plans'] = this.activePlans!.map((v) => v.toJson()).toList();
    }
    if (this.expirePlans != null) {
      data['expire_plans'] = this.expirePlans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActivePlans {
  String? endDate;
  String? orderCustomId;
  String? planCode;
  int? planModelId;
  String? planName;
  int? planPeriod;
  String? startDate;

  ActivePlans(
      {this.endDate,
        this.orderCustomId,
        this.planCode,
        this.planModelId,
        this.planName,
        this.planPeriod,
        this.startDate});

  ActivePlans.fromJson(Map<String, dynamic> json) {
    endDate = json['end_date'];
    orderCustomId = json['order_custom_id'];
    planCode = json['plan_code'];
    planModelId = json['plan_model_id'];
    planName = json['plan_name'];
    planPeriod = json['plan_period'];
    startDate = json['start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['end_date'] = this.endDate;
    data['order_custom_id'] = this.orderCustomId;
    data['plan_code'] = this.planCode;
    data['plan_model_id'] = this.planModelId;
    data['plan_name'] = this.planName;
    data['plan_period'] = this.planPeriod;
    data['start_date'] = this.startDate;
    return data;
  }
}
