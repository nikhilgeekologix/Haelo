import 'package:flutter/cupertino.dart';

import '../../../../widgets/date_format.dart';

class OrderCommentHistoryModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  OrderCommentHistoryModel(
      {this.data, this.isUserAllowed, this.msg, this.result});

  OrderCommentHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<CaseList>? caseList;

  Data({this.caseList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['case_list'] != null) {
      caseList = <CaseList>[];
      json['case_list'].forEach((v) {
        caseList!.add(new CaseList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.caseList != null) {
      data['case_list'] = this.caseList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CaseList {
  String? benchName;
  int? caseId;
  String? caseNo;
  String? case_title;
  String? causeListDate;
  String? commentDate;
  List<CommentDetails>? commentDetails;
  String? court_date;
  String? courtNo;
  String? dateOfListing;
  String? dateOfListinng;
  String? date_type;
  String? intrim_stay;
  bool? is_disposed;
  int? is_hide;
  String? lastCauseListDate;
  String? last_comment_date;
  dynamic lastDate;
  String? commentUpdateDate;
  int? no_of_weeks;
  String? orderFile;
  String? sno;
  String? stage;
  String? userDate;
  double? cardHeight = 0;
  GlobalKey? subListgKey;
  int? index;
  bool? isdateChange;
  bool? iscourtChange;
  bool isSelected = false;

  CaseList({
    this.benchName,
    this.caseId,
    this.caseNo,
    this.case_title,
    this.causeListDate,
    this.commentDate,
    this.commentDetails,
    this.court_date,
    this.courtNo,
    this.dateOfListing,
    this.dateOfListinng,
    this.date_type,
    this.intrim_stay,
    this.is_disposed,
    this.is_hide,
    this.lastCauseListDate,
    this.last_comment_date,
    this.lastDate,
    this.commentUpdateDate,
    this.no_of_weeks,
    this.orderFile,
    this.sno,
    this.stage,
    this.userDate,
    this.cardHeight,
    this.subListgKey,
    this.index,
    this.isdateChange,
    this.iscourtChange,
  });

  CaseList.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    caseId = json['case_id'];
    caseNo = json['case_no'];
    case_title = json['case_title'];
    causeListDate = getddMMYYYY_with_splash(json['cause_list_date']);
    commentUpdateDate = json['date_of_listing'];
    commentDate = json['comment_date'];
    if (json['comment_details'] != null) {
      commentDetails = <CommentDetails>[];
      json['comment_details'].forEach((v) {
        commentDetails!.add(new CommentDetails.fromJson(v));
      });
    }
    court_date = json['court_date'];
    courtNo = json['court_no'];
    dateOfListing = json['date_of_listing'];
    dateOfListinng = json['date_of_listinng'];
    date_type = json['date_type'];
    intrim_stay = json['intrim_stay'];
    is_disposed = json['is_disposed'];
    is_hide = json['is_hide'];
    lastCauseListDate = json['last_cause_list_date'];
    last_comment_date = json['last_comment_date'];
    lastDate = json['last_list_date'];
    no_of_weeks = json['no_of_weeks'];
    orderFile = json['order_file'];
    sno = json['sno'];
    stage = json['stage'];
    userDate = json['user_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['case_title'] = this.case_title;
    data['cause_list_date'] = this.causeListDate;
    data['comment_date'] = this.commentDate;
    if (this.commentDetails != null) {
      data['comment_details'] =
          this.commentDetails!.map((v) => v.toJson()).toList();
    }
    data['court_date'] = this.court_date;
    data['court_no'] = this.courtNo;
    data['date_of_listing'] = this.dateOfListing;
    data['date_of_listinng'] = this.dateOfListinng;
    data['date_of_listing'] = this.commentUpdateDate;
    data['date_type'] = this.date_type;
    data['intrim_stay'] = this.intrim_stay;
    data['is_disposed'] = this.is_disposed;
    data['is_hide'] = this.is_hide;
    data['last_cause_list_date'] = this.lastCauseListDate;
    data['last_comment_date'] = this.last_comment_date;
    data['last_list_date'] = this.lastDate;
    data['no_of_weeks'] = this.no_of_weeks;
    data['order_file'] = this.orderFile;
    data['sno'] = this.sno;
    data['stage'] = this.stage;
    data['user_date'] = this.userDate;
    return data;
  }
}

class CommentDetails {
  int? caseId;
  String? comment;
  String? commentTime;
  int? commentId;
  String? mobNo;
  String? timestamp;
  int? userId;
  String? userName;

  CommentDetails(
      {this.caseId,
      this.comment,
      this.commentTime,
      this.commentId,
      this.mobNo,
      this.timestamp,
      this.userId,
      this.userName});

  CommentDetails.fromJson(Map<String, dynamic> json) {
    caseId = json['case_id'];
    comment = json['comment'];
    commentTime = json['commentTime'];
    commentId = json['comment_id'];
    mobNo = json['mob_no'];
    timestamp = json['timestamp'];
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_id'] = this.caseId;
    data['comment'] = this.comment;
    data['commentTime'] = this.commentTime;
    data['comment_id'] = this.commentId;
    data['mob_no'] = this.mobNo;
    data['timestamp'] = this.timestamp;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    return data;
  }
}
