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
  List<CommentDetails>? commentDetails;
  String? courtNo;
  String? dateOfListinng;
  String? orderFile;
  String? sno;
  String? stage;
  String? userDate;
  String? intrim_stay;
  bool? is_disposed;
  int? is_hide;
  String? commentUpdateDate;
  String? last_comment_date;
  String? commentDate;
  String? lastCauseListDate;
  String? date_type;
  String? court_date;
  int? no_of_weeks;
  double? cardHeight = 0;
  GlobalKey? subListgKey;
  int? index;
  bool? isdateChange;
  bool? iscourtChange;
  bool isSelected = false;

  CaseList(
      {this.benchName,
      this.caseId,
      this.caseNo,
      this.case_title,
      this.causeListDate,
      this.commentDetails,
      this.courtNo,
      this.dateOfListinng,
      this.orderFile,
      this.sno,
      this.stage,
      this.userDate,
      this.intrim_stay,
      this.is_disposed,
      this.is_hide,
      this.commentUpdateDate,
      this.last_comment_date,
      this.lastCauseListDate,
      this.commentDate,
      this.date_type,
      this.court_date,
      this.no_of_weeks,
      this.cardHeight,
      this.subListgKey,
      this.index,
      this.isdateChange,
      this.iscourtChange});

  CaseList.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    caseId = json['case_id'];
    caseNo = json['case_no'];
    case_title = json['case_title'];
    causeListDate = getddMMYYYY_with_splash(json['cause_list_date']);
    if (json['comment_details'] != null) {
      commentDetails = <CommentDetails>[];
      json['comment_details'].forEach((v) {
        commentDetails!.add(CommentDetails.fromJson(v));
      });

      if (commentDetails!.length > 0) {
        print("Found comment date ${json['comment_date']}");
      }
    }
    courtNo = json['court_no'];
    dateOfListinng = json['date_of_listinng'];
    orderFile = json['order_file'];
    sno = json['sno'];
    stage = json['stage'];
    userDate = json['user_date'];
    intrim_stay = json['intrim_stay'];
    is_disposed = json['is_disposed'];
    is_hide = json['is_hide'];
    commentUpdateDate = json['date_of_listing'];
    last_comment_date = json['last_comment_date'];
    lastCauseListDate = json['last_cause_list_date'];
    commentDate = json['comment_date'];
    date_type = json['date_type'];
    court_date = json['court_date'];
    no_of_weeks = json['no_of_weeks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['case_title'] = this.case_title;
    data['cause_list_date'] = this.causeListDate;
    if (this.commentDetails != null) {
      data['comment_details'] =
          this.commentDetails!.map((v) => v.toJson()).toList();
    }
    data['court_no'] = this.courtNo;
    data['date_of_listinng'] = this.dateOfListinng;
    data['order_file'] = this.orderFile;
    data['sno'] = this.sno;
    data['stage'] = this.stage;
    data['user_date'] = this.userDate;
    data['intrim_stay'] = this.intrim_stay;
    data['is_disposed'] = this.is_disposed;
    data['is_hide'] = this.is_hide;
    data['date_of_listing'] = this.commentUpdateDate;
    data['last_comment_date'] = this.last_comment_date;
    data['last_cause_list_date'] = this.lastCauseListDate;
    data['comment_date'] = this.commentDate;
    data['date_type'] = this.date_type;
    data['court_date'] = this.court_date;
    data['no_of_weeks'] = this.no_of_weeks;
    return data;
  }
}

class CommentDetails {
  int? caseId;
  String? comment;
  int? commentId;
  String? mobNo;
  String? timestamp;
  int? userId;
  String? userName;

  CommentDetails(
      {this.caseId,
      this.comment,
      this.commentId,
      this.mobNo,
      this.timestamp,
      this.userId,
      this.userName});

  CommentDetails.fromJson(Map<String, dynamic> json) {
    caseId = json['case_id'];
    comment = json['comment'];
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
    data['comment_id'] = this.commentId;
    data['mob_no'] = this.mobNo;
    data['timestamp'] = this.timestamp;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    return data;
  }
}
