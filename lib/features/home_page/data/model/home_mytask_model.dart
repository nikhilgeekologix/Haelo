class HomeMyTaskModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  HomeMyTaskModel({this.data, this.isUserAllowed, this.msg, this.result});

  HomeMyTaskModel.fromJson(Map<String, dynamic> json) {
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
  int? alertCount;
  List<CauseWatchlist>? causeWatchlist;
  String? currentDate;
  String? expiryDate;
  String? heading;
  String? heading2;
  List<String>? lastDateList;
  List<Lawyerlist>? lawyerlist;
  Notice? notice;
  String? userName;
  List<Watchlist>? watchlist;
  PlanDetails? planDetails;
  var daily_file;
  var supp_file;

  Data(
      {this.alertCount,
      this.causeWatchlist,
      this.currentDate,
      this.expiryDate,
      this.heading,
      this.heading2,
      this.lastDateList,
      this.lawyerlist,
      this.notice,
      this.userName,
      this.watchlist,
      this.planDetails,
      this.daily_file,
      this.supp_file});

  Data.fromJson(Map<String, dynamic> json) {
    alertCount = json['alertCount'];
    if (json['cause_watchlist'] != null) {
      causeWatchlist = <CauseWatchlist>[];
      json['cause_watchlist'].forEach((v) {
        causeWatchlist!.add(new CauseWatchlist.fromJson(v));
      });
    }
    currentDate = json['current_date'];
    expiryDate = json['expriy_date'];
    heading = json['heading'];
    heading2 = json['heading2'];
    lastDateList = json['last_date_list'].cast<String>();
    if (json['lawyerlist'] != null) {
      lawyerlist = <Lawyerlist>[];
      json['lawyerlist'].forEach((v) {
        lawyerlist!.add(new Lawyerlist.fromJson(v));
      });
    }
    notice =
        json['notice'] != null ? new Notice.fromJson(json['notice']) : null;
    userName = json['user_name'];
    if (json['watchlist'] != null) {
      watchlist = <Watchlist>[];
      json['watchlist'].forEach((v) {
        watchlist!.add(new Watchlist.fromJson(v));
      });
    }
    planDetails = json['plan_details'] != null
        ? new PlanDetails.fromJson(json['plan_details'])
        : null;
    daily_file = json['daily_file'];
    supp_file = json['supp_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertCount'] = this.alertCount;
    if (this.causeWatchlist != null) {
      data['cause_watchlist'] =
          this.causeWatchlist!.map((v) => v.toJson()).toList();
    }
    data['current_date'] = this.currentDate;
    data['expriy_date'] = this.expiryDate;
    data['heading'] = this.heading;
    data['heading2'] = this.heading2;
    data['last_date_list'] = this.lastDateList;
    if (this.lawyerlist != null) {
      data['lawyerlist'] = this.lawyerlist!.map((v) => v.toJson()).toList();
    }
    if (this.notice != null) {
      data['notice'] = this.notice!.toJson();
    }
    data['user_name'] = this.userName;
    if (this.watchlist != null) {
      data['watchlist'] = this.watchlist!.map((v) => v.toJson()).toList();
    }
    if (this.planDetails != null) {
      data['plan_details'] = this.planDetails!.toJson();
    }
    data['daily_file'] = this.daily_file;
    data['supp_file'] = this.supp_file;
    return data;
  }
}

class CauseWatchlist {
  String? lawyerlist;
  String? watchlistName;

  CauseWatchlist({this.lawyerlist, this.watchlistName});

  CauseWatchlist.fromJson(Map<String, dynamic> json) {
    lawyerlist = json['lawyerlist'];
    watchlistName = json['watchlist_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lawyerlist'] = this.lawyerlist;
    data['watchlist_name'] = this.watchlistName;
    return data;
  }
}

class Lawyerlist {
  String? caseNo;
  int? isHighlighted;
  String? lawyer;

  Lawyerlist({this.caseNo, this.isHighlighted, this.lawyer});

  Lawyerlist.fromJson(Map<String, dynamic> json) {
    caseNo = json['case_no'];
    isHighlighted = json['isHighlighted'];
    lawyer = json['lawyer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_no'] = this.caseNo;
    data['isHighlighted'] = this.isHighlighted;
    data['lawyer'] = this.lawyer;
    return data;
  }
}

class Notice {
  String? daily;
  String? display;
  String? supplimentary;

  Notice({this.daily, this.display, this.supplimentary});

  Notice.fromJson(Map<String, dynamic> json) {
    daily = json['daily'];
    display = json['display'];
    supplimentary = json['supplimentary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['daily'] = this.daily;
    data['display'] = this.display;
    data['supplimentary'] = this.supplimentary;
    return data;
  }
}

class Watchlist {
  List<String>? caselist;
  int? isHighlighted;
  String? watchlistName;

  Watchlist({this.caselist, this.isHighlighted, this.watchlistName});

  Watchlist.fromJson(Map<String, dynamic> json) {
    caselist = json['caselist'].cast<String>();
    isHighlighted = json['isHighlighted'];
    watchlistName = json['watchlist_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caselist'] = this.caselist;
    data['isHighlighted'] = this.isHighlighted;
    data['watchlist_name'] = this.watchlistName;
    return data;
  }
}

class PlanDetails {
  int? isPrime;
  bool? isTrail;
  int? planModelId;
  String? planName;

  PlanDetails({this.isPrime, this.isTrail, this.planModelId, this.planName});

  PlanDetails.fromJson(Map<String, dynamic> json) {
    isPrime = json['is_prime'];
    isTrail = json['is_trail'];
    planModelId = json['plan_model_id'];
    planName = json['plan_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_prime'] = this.isPrime;
    data['is_trail'] = this.isTrail;
    data['plan_model_id'] = this.planModelId;
    data['plan_name'] = this.planName;
    return data;
  }
}
