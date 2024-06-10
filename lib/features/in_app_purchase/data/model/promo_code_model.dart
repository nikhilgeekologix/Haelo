import 'package:in_app_purchase/in_app_purchase.dart';

class PromoCodesModel {
  Data? data;
  String? msg;
  int? result;

  PromoCodesModel({this.data, this.msg, this.result});

  PromoCodesModel.fromJson(Map<String, dynamic> json) {
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
  List<PromoCodeMonthData>? l12Month;
  List<PromoCodeMonthData>? l1Month;
  List<PromoCodeMonthData>? l6Month;

  Data({this.l12Month, this.l1Month, this.l6Month});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['12_month'] != null) {
      l12Month = <PromoCodeMonthData>[];
      json['12_month'].forEach((v) {
        l12Month!.add(new PromoCodeMonthData.fromJson(v));
      });
    }
    if (json['1_month'] != null) {
      l1Month = <PromoCodeMonthData>[];
      json['1_month'].forEach((v) {
        l1Month!.add(new PromoCodeMonthData.fromJson(v));
      });
    }
    if (json['6_month'] != null) {
      l6Month = <PromoCodeMonthData>[];
      json['6_month'].forEach((v) {
        l6Month!.add(new PromoCodeMonthData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.l12Month != null) {
      data['12_month'] = this.l12Month!.map((v) => v.toJson()).toList();
    }
    if (this.l1Month != null) {
      data['1_month'] = this.l1Month!.map((v) => v.toJson()).toList();
    }
    if (this.l6Month != null) {
      data['6_month'] = this.l6Month!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromoCodeMonthData {
  String? oldAmount;
  String? planAmount;
  String? planDesc;
  int? planId;
  int? planModelId;
  String? planName;
  int? planPeriod;
  String? planTitle;
  int? promocodeCount;
  String? inAppPrice;
  ProductDetails? productDetails;

  PromoCodeMonthData(
      {this.oldAmount,
      this.planAmount,
      this.planDesc,
      this.planId,
      this.planModelId,
      this.planName,
      this.planPeriod,
      this.planTitle,
      this.promocodeCount,
      this.inAppPrice,
      this.productDetails});

  PromoCodeMonthData.fromJson(Map<String, dynamic> json) {
    oldAmount = json['old_amount'];
    planAmount = json['plan_amount'];
    planDesc = json['plan_desc'];
    planId = json['plan_id'];
    planModelId = json['plan_model_id'];
    planName = json['plan_name'];
    planPeriod = json['plan_period'];
    planTitle = json['plan_title'];
    promocodeCount = json['promocode_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_amount'] = this.oldAmount;
    data['plan_amount'] = this.planAmount;
    data['plan_desc'] = this.planDesc;
    data['plan_id'] = this.planId;
    data['plan_model_id'] = this.planModelId;
    data['plan_name'] = this.planName;
    data['plan_period'] = this.planPeriod;
    data['plan_title'] = this.planTitle;
    data['promocode_count'] = this.promocodeCount;
    return data;
  }
}
