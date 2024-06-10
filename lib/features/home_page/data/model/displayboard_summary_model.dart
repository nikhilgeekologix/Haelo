class DisplayBoardSummaryModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  DisplayBoardSummaryModel({this.data, this.isUserAllowed, this.msg, this.result});

  DisplayBoardSummaryModel.fromJson(Map<String, dynamic> json) {
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
  List<Summary>? summary;
 // bool isDropDownOpen=false;

  Data({this.summary});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <Summary>[];
      json['summary'].forEach((v) {
        summary!.add(new Summary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.summary != null) {
      data['summary'] = this.summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summary {
  String? benchName;
  String? judgeTime;
  String? judgeTime2;
  String? sno;
  String? stage;
  List<SumamryDetail>? sumamryDetail;
  bool isDropDownOpen=false;


  String? causeListType;
  int? courtNo;
  String? currDate;
  String? notice;



  Summary({this.benchName, this.judgeTime, this.judgeTime2, this.sno, this.stage, this.sumamryDetail,
    this.causeListType,
    this.courtNo,
    this.currDate,
    this.notice});

  Summary.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    judgeTime = json['judge_time'];
    judgeTime2 = json['judge_time2'];
    sno = json['sno'];
    stage = json['stage'];
    if (json['sumamry_detail'] != null) {
      sumamryDetail = <SumamryDetail>[];
      json['sumamry_detail'].forEach((v) {
        sumamryDetail!.add(new SumamryDetail.fromJson(v));
      });
    }
    causeListType = json['cause_list_type'];
    courtNo = json['court_no'];
    currDate = json['curr_date'];
    notice = json['notice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['judge_time'] = this.judgeTime;
    data['judge_time2'] = this.judgeTime2;
    data['sno'] = this.sno;
    data['stage'] = this.stage;
    if (this.sumamryDetail != null) {
      data['sumamry_detail'] = this.sumamryDetail!.map((v) => v.toJson()).toList();
    }
    data['cause_list_type'] = this.causeListType;
    data['court_no'] = this.courtNo;
    data['curr_date'] = this.currDate;
    data['notice'] = this.notice;
    return data;
  }
}

class SumamryDetail {
  String? caseType;
  String? sno;

  SumamryDetail({this.caseType, this.sno});

  SumamryDetail.fromJson(Map<String, dynamic> json) {
    caseType = json['case_type'];
    sno = json['sno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_type'] = this.caseType;
    data['sno'] = this.sno;
    return data;
  }
}
