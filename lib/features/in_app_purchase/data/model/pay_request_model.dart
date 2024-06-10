class PayRequestModel {
  List<PromoData>? promoData;
  Data? data;
  String? msg;
  int? result;

  PayRequestModel({this.promoData, this.data, this.msg, this.result});

  PayRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['promoData'] != null) {
      promoData = <PromoData>[];
      json['promoData'].forEach((v) {
        promoData!.add(new PromoData.fromJson(v));
      });
    }
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.promoData != null) {
      data['promoData'] = this.promoData!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  Response? response;

  Data({this.response});

  Data.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Response {
  int? isPrime;
  int? plan_model_id;
  String? planName;
  List<String>? promocode;

  Response({this.isPrime, this.plan_model_id, this.planName});

  Response.fromJson(Map<String, dynamic> json) {
    isPrime = json['is_prime'];
    planName = json['plan_name'];
    plan_model_id = json['plan_model_id'];
    promocode = json['promocode']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_prime'] = this.isPrime;
    data['plan_model_id'] = this.plan_model_id;
    data['plan_name'] = this.planName;
    data['promocode'] = this.promocode;
    return data;
  }
}

class PromoData {
  String? planName;
  String? expiryDate;
  String? promocode;
  int? validity;

  PromoData({this.planName, this.expiryDate, this.promocode, this.validity});

  PromoData.fromJson(Map<String, dynamic> json) {
    planName = json['Plan_name'];
    expiryDate = json['expiry_date'];
    promocode = json['promocode'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Plan_name'] = this.planName;
    data['expiry_date'] = this.expiryDate;
    data['promocode'] = this.promocode;
    data['validity'] = this.validity;
    return data;
  }
}
