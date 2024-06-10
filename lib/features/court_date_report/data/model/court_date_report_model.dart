class CourtDateReportModel {
  List<Data>? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CourtDateReportModel({data, isUserAllowed, msg, result});

  CourtDateReportModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    isUserAllowed = json['isUserAllowed'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['isUserAllowed'] = isUserAllowed;
    data['msg'] = msg;
    data['result'] = result;
    return data;
  }
}

class Data {
  String? caseDesion;
  int? caseId;
  String? caseName;
  int? caseNo;
  String? caseTitle;
  String? date;
  String? interim;
  bool? isDisposed;
  int? isHide;
  int? isReaded;
  String? itmo;
  String? subCategory;

  Data(
      {caseDesion,
        caseId,
        caseName,
        caseNo,
        caseTitle,
        date,
        interim,
        isDisposed,
        isHide,
        isReaded,
        itmo,
        subCategory});

  Data.fromJson(Map<String, dynamic> json) {
    caseDesion = json['case_desion'];
    caseId = json['case_id'];
    caseName = json['case_name'];
    caseNo = json['case_no'];
    caseTitle = json['case_title'];
    date = json['date'];
    interim = json['interim'];
    isDisposed = json['is_disposed'];
    isHide = json['is_hide'];
    isReaded = json['is_readed'];
    itmo = json['itmo'];
    subCategory = json['sub_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['case_desion'] = caseDesion;
    data['case_id'] = caseId;
    data['case_name'] = caseName;
    data['case_no'] = caseNo;
    data['case_title'] = caseTitle;
    data['date'] = date;
    data['interim'] = interim;
    data['is_disposed'] = isDisposed;
    data['is_hide'] = isHide;
    data['is_readed'] = isReaded;
    data['itmo'] = itmo;
    data['sub_category'] = subCategory;
    return data;
  }
}
