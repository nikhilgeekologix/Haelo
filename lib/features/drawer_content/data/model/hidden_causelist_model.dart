class HiddenCauseListModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  HiddenCauseListModel({this.data, this.isUserAllowed, this.msg, this.result});

  HiddenCauseListModel.fromJson(Map<String, dynamic> json) {
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
  List<Causelist>? causelist;

  Data({this.causelist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['causelist'] != null) {
      causelist = <Causelist>[];
      json['causelist'].forEach((v) {
        causelist!.add(new Causelist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.causelist != null) {
      data['causelist'] = this.causelist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Causelist {
  String? benchName;
  String? caseNo;
  int? causeId;
  String? causeListDate;
  String? causeListType;
  String? courtNo;
  String? judgeTime;
  String? judgeTime2;
  String? partyName;
  String? petitioner;
  String? respondent;
  String? sno;
  String? stage;

  Causelist(
      {this.benchName,
      this.caseNo,
      this.causeId,
      this.causeListDate,
      this.causeListType,
      this.courtNo,
      this.judgeTime,
      this.judgeTime2,
      this.partyName,
      this.petitioner,
      this.respondent,
      this.sno,
      this.stage});

  Causelist.fromJson(Map<String, dynamic> json) {
    benchName = json['Bench_name'];
    caseNo = json['case_no'];
    causeId = json['cause_id'];
    causeListDate = json['cause_list_date'];
    causeListType = json['cause_list_type'];
    courtNo = json['court_no'];
    judgeTime = json['judge_time'];
    judgeTime2 = json['judge_time2'];
    partyName = json['party_name'];
    petitioner = json['petitioner'];
    respondent = json['respondent'];
    sno = json['sno'];
    stage = json['stage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bench_name'] = this.benchName;
    data['case_no'] = this.caseNo;
    data['cause_id'] = this.causeId;
    data['cause_list_date'] = this.causeListDate;
    data['cause_list_type'] = this.causeListType;
    data['court_no'] = this.courtNo;
    data['judge_time'] = this.judgeTime;
    data['judge_time2'] = this.judgeTime2;
    data['party_name'] = this.partyName;
    data['petitioner'] = this.petitioner;
    data['respondent'] = this.respondent;
    data['sno'] = this.sno;
    data['stage'] = this.stage;
    return data;
  }
}
