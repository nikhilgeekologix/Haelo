class MyAlertModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  MyAlertModel({this.data, this.isUserAllowed, this.msg, this.result});

  MyAlertModel.fromJson(Map<String, dynamic> json) {
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
  List<CauseWatchlist>? causeWatchlist;
  List<Lawyerlist>? lawyerlist;
  List<Watchlist>? watchlist;

  Data({this.causeWatchlist, this.lawyerlist, this.watchlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cause_watchlist'] != null) {
      causeWatchlist = <CauseWatchlist>[];
      json['cause_watchlist'].forEach((v) {
        causeWatchlist!.add(new CauseWatchlist.fromJson(v));
      });
    }
    if (json['lawyerlist'] != null) {
      lawyerlist = <Lawyerlist>[];
      json['lawyerlist'].forEach((v) {
        lawyerlist!.add(new Lawyerlist.fromJson(v));
      });
    }
    if (json['watchlist'] != null) {
      watchlist = <Watchlist>[];
      json['watchlist'].forEach((v) {
        watchlist!.add(new Watchlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.causeWatchlist != null) {
      data['cause_watchlist'] =
          this.causeWatchlist!.map((v) => v.toJson()).toList();
    }
    if (this.lawyerlist != null) {
      data['lawyerlist'] = this.lawyerlist!.map((v) => v.toJson()).toList();
    }
    if (this.watchlist != null) {
      data['watchlist'] = this.watchlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CauseWatchlist {
  String? lawyerlist;
  int? watchlistId;
  String? watchlistName;

  CauseWatchlist({this.lawyerlist, this.watchlistId, this.watchlistName});

  CauseWatchlist.fromJson(Map<String, dynamic> json) {
    lawyerlist = json['lawyerlist'];
    watchlistId = json['watchlist_id'];
    watchlistName = json['watchlist_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lawyerlist'] = this.lawyerlist;
    data['watchlist_id'] = this.watchlistId;
    data['watchlist_name'] = this.watchlistName;
    return data;
  }
}

class Lawyerlist {
  int? alertId;
  String? courtNo;
  String? fromDate;
  int? id;
  int? isHighlighted;
  bool? isSelected;
  String? lawyerName;
  String? selectedCaseNo;
  String? selectedCauseType;
  String? selectedJudgeName;
  String? selectedLawyerName;
  String? toDate;
  var is_default;

  Lawyerlist(
      {this.alertId,
        this.courtNo,
        this.fromDate,
        this.id,
        this.isHighlighted,
        this.isSelected,
        this.lawyerName,
        this.selectedCaseNo,
        this.selectedCauseType,
        this.selectedJudgeName,
        this.selectedLawyerName,
        this.toDate,
      this.is_default});

  Lawyerlist.fromJson(Map<String, dynamic> json) {
    alertId = json['alert_id'];
    courtNo = json['court_no'];
    fromDate = json['from_date'];
    id = json['id'];
    isHighlighted = json['isHighlighted'];
    isSelected = json['is_selected'];
    lawyerName = json['lawyer_name'];
    selectedCaseNo = json['selected_case_no'];
    selectedCauseType = json['selected_cause_type'];
    selectedJudgeName = json['selected_judge_name'];
    selectedLawyerName = json['selected_lawyer_name'];
    toDate = json['to_date'];
    is_default = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alert_id'] = this.alertId;
    data['court_no'] = this.courtNo;
    data['from_date'] = this.fromDate;
    data['id'] = this.id;
    data['isHighlighted'] = this.isHighlighted;
    data['is_selected'] = this.isSelected;
    data['lawyer_name'] = this.lawyerName;
    data['selected_case_no'] = this.selectedCaseNo;
    data['selected_cause_type'] = this.selectedCauseType;
    data['selected_judge_name'] = this.selectedJudgeName;
    data['selected_lawyer_name'] = this.selectedLawyerName;
    data['to_date'] = this.toDate;
    data['is_default'] = this.is_default;
    return data;
  }
}

class Watchlist {
  List? caselist;
  int? isHighlighted;
  int? watchlistId;
  String? watchlistName;

  Watchlist(
      {this.caselist,
        this.isHighlighted,
        this.watchlistId,
        this.watchlistName});

  Watchlist.fromJson(Map<String, dynamic> json) {
    if (json['caselist'] != null) {
      caselist = [];
      json['caselist'].forEach((v) {
        caselist!.add((v));
      });
    }
    isHighlighted = json['isHighlighted'];
    watchlistId = json['watchlist_id'];
    watchlistName = json['watchlist_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.caselist != null) {
      data['caselist'] = this.caselist!.map((v) => v).toList();
    }
    data['isHighlighted'] = this.isHighlighted;
    data['watchlist_id'] = this.watchlistId;
    data['watchlist_name'] = this.watchlistName;
    return data;
  }
}
