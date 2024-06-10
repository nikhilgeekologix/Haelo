class MainCauseListDataModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  MainCauseListDataModel({this.data, this.isUserAllowed, this.msg, this.result});

  MainCauseListDataModel.fromJson(Map<String, dynamic> json) {
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
  List<BenchName>? benchName;
  List<CaseNo>? caseNo;
  List<CauseListType>? causeListType;
  List<CourtNo>? courtNo;
  List<String>? judgeTime;
  List<LawyerName>? lawyerName;
  List<PartyName>? partyName;
  String? cause_date;
  int? lawyer_count;

  Data(
      {this.benchName, this.caseNo, this.causeListType, this.courtNo,
        this.judgeTime, this.lawyerName, this.partyName, this.cause_date});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['bench_name'] != null) {
      benchName = <BenchName>[];
      json['bench_name'].forEach((v) {
        benchName!.add(new BenchName.fromJson(v));
      });
    }
    if (json['case_no'] != null) {
      caseNo = <CaseNo>[];
      json['case_no'].forEach((v) {
        caseNo!.add(new CaseNo.fromJson(v));
      });
    }
    if (json['cause_list_type'] != null) {
      causeListType = <CauseListType>[];
      json['cause_list_type'].forEach((v) {
        causeListType!.add(new CauseListType.fromJson(v));
      });
    }
    if (json['court_no'] != null) {
      courtNo = <CourtNo>[];
      json['court_no'].forEach((v) {
        courtNo!.add(new CourtNo.fromJson(v));
      });
    }
    judgeTime = json['judge_time'].cast<String>();
    if (json['lawyer_name'] != null) {
      lawyerName = <LawyerName>[];
      json['lawyer_name'].forEach((v) {
        lawyerName!.add(new LawyerName.fromJson(v));
      });
    }
    if (json['party_name'] != null) {
      partyName = <PartyName>[];
      json['party_name'].forEach((v) {
        partyName!.add(new PartyName.fromJson(v));
      });
    }
    cause_date=json['cause_date'];
    lawyer_count=json['lawyer_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.benchName != null) {
      data['bench_name'] = this.benchName!.map((v) => v.toJson()).toList();
    }
    if (this.caseNo != null) {
      data['case_no'] = this.caseNo!.map((v) => v.toJson()).toList();
    }
    if (this.causeListType != null) {
      data['cause_list_type'] = this.causeListType!.map((v) => v.toJson()).toList();
    }
    if (this.courtNo != null) {
      data['court_no'] = this.courtNo!.map((v) => v.toJson()).toList();
    }
    data['judge_time'] = this.judgeTime;
    if (this.lawyerName != null) {
      data['lawyer_name'] = this.lawyerName!.map((v) => v.toJson()).toList();
    }
    if (this.partyName != null) {
      data['party_name'] = this.partyName!.map((v) => v.toJson()).toList();
    }
    data['cause_date']=cause_date;
    data['lawyer_count']=lawyer_count;
    return data;
  }
}

class BenchName {
  String? benchName;

  BenchName({this.benchName});

  BenchName.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    return data;
  }
}

class CaseNo {
  String? caseNo;

  CaseNo({this.caseNo});

  CaseNo.fromJson(Map<String, dynamic> json) {
    caseNo = json['case_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_no'] = this.caseNo;
    return data;
  }
}

class CauseListType {
  String? causeListType;

  CauseListType({this.causeListType});

  CauseListType.fromJson(Map<String, dynamic> json) {
    causeListType = json['cause_list_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cause_list_type'] = this.causeListType;
    return data;
  }
}

class CourtNo {
  String? courtNo;

  CourtNo({this.courtNo});

  CourtNo.fromJson(Map<String, dynamic> json) {
    courtNo = json['court_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['court_no'] = this.courtNo;
    return data;
  }
}

class LawyerName {
  String? lawyerName;

  LawyerName({this.lawyerName});

  LawyerName.fromJson(Map<String, dynamic> json) {
    lawyerName = json['lawyer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lawyer_name'] = this.lawyerName;
    return data;
  }
}

class PartyName {
  String? partyName;

  PartyName({this.partyName});

  PartyName.fromJson(Map<String, dynamic> json) {
    partyName = json['party_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['party_name'] = this.partyName;
    return data;
  }
}
