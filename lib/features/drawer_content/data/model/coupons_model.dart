class CouponsModel {
  List<Data>? data;
  String? msg;
  int? result;

  CouponsModel({this.data, this.msg, this.result});

  CouponsModel.fromJson(Map<String, dynamic> json) {
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
  String? expiryDate;
  String? planName;
  String? promocode;
  int? validity;

  Data({this.expiryDate, this.planName, this.promocode, this.validity});

  Data.fromJson(Map<String, dynamic> json) {
    expiryDate = json['expiry_date'];
    planName = json['plan_name'];
    promocode = json['promocode'];
    validity = json['validity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry_date'] = this.expiryDate;
    data['plan_name'] = this.planName;
    data['promocode'] = this.promocode;
    data['validity'] = this.validity;
    return data;
  }
}
