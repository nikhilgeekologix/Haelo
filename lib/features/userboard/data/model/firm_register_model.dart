class FirmRegisterModel {
  Data? data;
  String? msg;
  int? result;

  FirmRegisterModel({this.data, this.msg, this.result});

  FirmRegisterModel.fromJson(Map<String, dynamic> json) {
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
  String? accessToke;
  String? firmId;
  String? mobileNo;
  int? userType;
  int? userId;
  PlanDetails? planDetails;

  Data({this.accessToke, this.firmId, this.mobileNo, this.userType, this.userId,
    this.planDetails,});

  Data.fromJson(Map<String, dynamic> json) {
    accessToke = json['access_toke'];
    firmId = json['firm_id'];
    mobileNo = json['mobile_no'];
    userType = json['userType'];
    userId = json['user_id']; planDetails = json['plan_details'] != null
        ? new PlanDetails.fromJson(json['plan_details'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_toke'] = this.accessToke;
    data['firm_id'] = this.firmId;
    data['mobile_no'] = this.mobileNo;
    data['userType'] = this.userType;
    data['user_id'] = this.userId;
    if (this.planDetails != null) {
      data['plan_details'] = this.planDetails!.toJson();
    }
    return data;
  }
}

class PlanDetails {
  int? isPrime;
  int? planModelId;
  String? planName;

  PlanDetails({this.isPrime, this.planModelId, this.planName});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    isPrime = json['is_prime'];
    planModelId = json['plan_model_id'];
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_prime'] = this.isPrime;
    data['plan_model_id'] = this.planModelId;
    data['plan_name'] = this.planName;
    return data;
  }
}
