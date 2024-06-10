class TaskCaseNoModel {
  List<Data>? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  TaskCaseNoModel({this.data, this.isUserAllowed, this.msg, this.result});

  TaskCaseNoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    isUserAllowed = json['isUserAllowed'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['isUserAllowed'] = this.isUserAllowed;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  int? caseId;
  int? caseNo;
  String? validCaseno;

  Data({this.caseId, this.caseNo, this.validCaseno});

  Data.fromJson(Map<String, dynamic> json) {
    caseId = json['case_id'];
    caseNo = json['case_no'];
    validCaseno = json['valid_caseno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['valid_caseno'] = this.validCaseno;
    return data;
  }
}
