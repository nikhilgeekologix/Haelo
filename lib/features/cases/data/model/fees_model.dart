class FeesModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  FeesModel({this.data, this.isUserAllowed, this.msg, this.result});

  FeesModel.fromJson(Map<String, dynamic> json) {
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
  List<CaseList>? caseList;

  Data({this.caseList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['case_list'] != null) {
      caseList = <CaseList>[];
      json['case_list'].forEach((v) {
        caseList!.add(new CaseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.caseList != null) {
      data['case_list'] = this.caseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CaseList {
  String? amount;
  String? date;
  String? description;
  int? id;

  CaseList({this.amount, this.date, this.description, this.id});

  CaseList.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    date = json['date'];
    description = json['description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['date'] = this.date;
    data['description'] = this.description;
    data['id'] = this.id;
    return data;
  }
}
