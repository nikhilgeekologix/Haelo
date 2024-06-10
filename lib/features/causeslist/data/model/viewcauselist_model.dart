class ViewCauseListModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  ViewCauseListModel({this.data, this.isUserAllowed, this.msg, this.result});

  ViewCauseListModel.fromJson(Map<String, dynamic> json) {
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
  Response? response;
  String? excel_url;
  String? pdf_url;

  Data({this.causelist, this.response, this.excel_url, this.pdf_url});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['causelist'] != null) {
      causelist = <Causelist>[];
      json['causelist'].forEach((v) {
        causelist!.add(new Causelist.fromJson(v));
      });
    }
    // response = json['response'] != null ? new Response.fromJson(json['response']) : null;
    if (json['excel_url'] != null) {
      excel_url = json['excel_url'];
    }
    if (json['pdf_url'] != null) {
      excel_url =
          json['pdf_url']; // used same param for a reason,  not accidentally
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.causelist != null) {
      data['causelist'] = this.causelist!.map((v) => v.toJson()).toList();
    }
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    return data;
  }
}

class Causelist {
  String? benchName;
  String? bottomNo;
  int? caseId;
  String? caseNo;
  String? causeListDate;
  String? causeListType;
  String? courtNo;
  String? intrimStay;
  String? partyName;
  String? petitioner;
  String? respondent;
  String? sno;
  String? snoWith;
  String? stage;
  bool? is_disposed;
  int? is_hide;
  String? bench_info;
  bool? isHideExpanded;
  bool? isHideExpandedForBlue;
  bool? isdateChange;
  bool? iscourtChange;

  Causelist(
      {this.benchName,
      this.bottomNo,
      this.caseId,
      this.caseNo,
      this.causeListDate,
      this.causeListType,
      this.courtNo,
      this.intrimStay,
      this.partyName,
      this.petitioner,
      this.respondent,
      this.sno,
      this.snoWith,
      this.stage,
      this.is_disposed,
      this.is_hide,
      this.bench_info,
      this.isHideExpanded = false,
      this.isHideExpandedForBlue = false,
      this.isdateChange});

  Causelist.fromJson(Map<String, dynamic> json) {
    benchName = json['Bench_name'];
    bottomNo = json['bottom_no'];
    caseId = json['case_id'];
    caseNo = json['case_no'];
    causeListDate = json['cause_list_date'];
    causeListType = json['cause_list_type'];
    courtNo = json['court_no'];
    intrimStay = json['intrim_stay'];
    partyName = json['party_name'];
    petitioner = json['petitioner'];
    respondent = json['respondent'];
    sno = json['sno'];
    snoWith = json['sno_with'];
    stage = json['stage'];
    is_disposed = json['is_disposed'];
    is_hide = json['is_hide'];
    bench_info = json['bench_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bench_name'] = this.benchName;
    data['bottom_no'] = this.bottomNo;
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['cause_list_date'] = this.causeListDate;
    data['cause_list_type'] = this.causeListType;
    data['court_no'] = this.courtNo;
    data['intrim_stay'] = this.intrimStay;
    data['party_name'] = this.partyName;
    data['petitioner'] = this.petitioner;
    data['respondent'] = this.respondent;
    data['sno'] = this.sno;
    data['sno_with'] = this.snoWith;
    data['stage'] = this.stage;
    data['is_disposed'] = this.is_disposed;
    data['is_hide'] = this.is_hide;
    data['bench_info'] = this.bench_info;
    return data;
  }
}

class Response {
  String? benchName;
  var caseNo;
  String? causeListType;
  String? courtNo;
  String? dateFrom;
  String? dateTo;
  String? lawyerName;
  String? partyName;
  int? userId;

  Response(
      {this.benchName,
      this.caseNo,
      this.causeListType,
      this.courtNo,
      this.dateFrom,
      this.dateTo,
      this.lawyerName,
      this.partyName,
      this.userId});

  Response.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    caseNo = json['case_no'];
    causeListType = json['cause_list_type'];
    courtNo = json['court_no'];
    dateFrom = json['date_from'];
    dateTo = json['date_to'];
    lawyerName = json['lawyer_name'];
    partyName = json['party_name'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['case_no'] = this.caseNo;
    data['cause_list_type'] = this.causeListType;
    data['court_no'] = this.courtNo;
    data['date_from'] = this.dateFrom;
    data['date_to'] = this.dateTo;
    data['lawyer_name'] = this.lawyerName;
    data['party_name'] = this.partyName;
    data['user_id'] = this.userId;
    return data;
  }
}
