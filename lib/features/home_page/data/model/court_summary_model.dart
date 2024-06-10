class CourtSummaryModel {
  List<Data>? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CourtSummaryModel({this.data, this.isUserAllowed, this.msg, this.result});

  CourtSummaryModel.fromJson(Map<String, dynamic> json) {
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
  String? benchName;
  String? courtNo;
  String? heading;
  String? judgeTime;
  String? judgeTime1;
  String? sno;

  Data({this.benchName, this.courtNo, this.heading, this.judgeTime, this.judgeTime1, this.sno});

  Data.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    courtNo = json['court_no'];
    heading = json['heading'];
    judgeTime = json['judge_time'];
    judgeTime1 = json['judge_time1'];
    sno = json['sno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['court_no'] = this.courtNo;
    data['heading'] = this.heading;
    data['judge_time'] = this.judgeTime;
    data['judge_time1'] = this.judgeTime1;
    data['sno'] = this.sno;
    return data;
  }
}
