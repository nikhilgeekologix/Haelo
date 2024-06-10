class PaperDetailModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  PaperDetailModel({this.data, this.isUserAllowed, this.msg, this.result});

  PaperDetailModel.fromJson(Map<String, dynamic> json) {
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
  int? caseId;
  List<PaperDetail>? paperDetail;

  Data({this.caseId, this.paperDetail});

  Data.fromJson(Map<String, dynamic> json) {
    caseId = json['case_id']!=null ? int.parse(json['case_id'].toString()):null;
    if (json['paper_detail'] != null) {
      paperDetail = <PaperDetail>[];
      json['paper_detail'].forEach((v) {
        paperDetail!.add(new PaperDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_id'] = this.caseId;
    if (this.paperDetail != null) {
      data['paper_detail'] = this.paperDetail!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaperDetail {
  String? advocate;
  String? association;
  String? date;
  String? fees;
  String? no;
  String? type;

  PaperDetail({this.advocate, this.association, this.date, this.fees, this.no, this.type});

  PaperDetail.fromJson(Map<String, dynamic> json) {
    advocate = json['advocate'];
    association = json['association'];
    date = json['date'];
    fees = json['fees'];
    no = json['no'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advocate'] = this.advocate;
    data['association'] = this.association;
    data['date'] = this.date;
    data['fees'] = this.fees;
    data['no'] = this.no;
    data['type'] = this.type;
    return data;
  }
}
