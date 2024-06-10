import 'package:flutter/cupertino.dart';

class PendingOrderReportModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  PendingOrderReportModel(
      {this.data, this.isUserAllowed, this.msg, this.result});

  PendingOrderReportModel.fromJson(Map<String, dynamic> json) {
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
  String? benchName;
  int? caseId;
  String? caseNo;
  String? caseTitle;
  String? causeListDate;
  String? courtNo;
  String? dateOfListinng;
  String? dateType;
  String? intrimStay;
  bool? isDisposed;
  int? isHide;
  String? sno;
  String? stage;
  String? userDate;
  double? cardHeight = 0;
  GlobalKey? subListgKey;
  int? index;
  bool? iscourtChange;
  bool? isdateChange;
  bool isSelected = false;

  CaseList(
      {this.benchName,
      this.caseId,
      this.caseNo,
      this.caseTitle,
      this.causeListDate,
      this.courtNo,
      this.dateOfListinng,
      this.dateType,
      this.intrimStay,
      this.isDisposed,
      this.isHide,
      this.sno,
      this.stage,
      this.userDate,
      this.cardHeight,
      this.subListgKey,
      this.index,
      this.iscourtChange,
      this.isdateChange});

  CaseList.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    caseId = json['case_id'];
    caseNo = json['case_no'];
    caseTitle = json['case_title'];
    causeListDate = json['cause_list_date'];
    courtNo = json['court_no'];
    dateOfListinng = json['date_of_listinng'];
    dateType = json['date_type'];
    intrimStay = json['intrim_stay'];
    isDisposed = json['is_disposed'];
    isHide = json['is_hide'];
    sno = json['sno'];
    stage = json['stage'];
    userDate = json['user_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['case_title'] = this.caseTitle;
    data['cause_list_date'] = this.causeListDate;
    data['court_no'] = this.courtNo;
    data['date_of_listinng'] = this.dateOfListinng;
    data['date_type'] = this.dateType;
    data['intrim_stay'] = this.intrimStay;
    data['is_disposed'] = this.isDisposed;
    data['is_hide'] = this.isHide;
    data['sno'] = this.sno;
    data['stage'] = this.stage;
    data['user_date'] = this.userDate;
    return data;
  }
}
