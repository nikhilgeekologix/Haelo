class DisplayBoardItemStageModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  DisplayBoardItemStageModel(
      {this.data, this.isUserAllowed, this.msg, this.result});

  DisplayBoardItemStageModel.fromJson(Map<String, dynamic> json) {
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
  List<StageListDict>? stageListDict;

  Data({this.stageListDict});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['stage_list_dict'] != null) {
      stageListDict = <StageListDict>[];
      json['stage_list_dict'].forEach((v) {
        stageListDict!.add(new StageListDict.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stageListDict != null) {
      data['stage_list_dict'] =
          this.stageListDict!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StageListDict {
  String? benchName;
  String? caseNo;
  String? caseTitle;
  List<CommentDetails>? commentDetails;
  String? courtNo;
  String? sNo;
  String? stage;
  int? caseId;

  StageListDict(
      {this.benchName,
      this.caseNo,
      this.caseTitle,
      this.commentDetails,
      this.courtNo,
      this.sNo,
      this.stage,this.caseId});

  StageListDict.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    caseNo = json['case_no'];
    caseTitle = json['case_title'];
    if (json['comment_details'] != null) {
      commentDetails = <CommentDetails>[];
      json['comment_details'].forEach((v) {
        commentDetails!.add(new CommentDetails.fromJson(v));
      });
    }
    courtNo = json['court_no'];
    sNo = json['s_no'];
    stage = json['stage'];
    caseId = json['case_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    data['case_no'] = this.caseNo;
    data['case_title'] = this.caseTitle;
    if (this.commentDetails != null) {
      data['comment_details'] =
          this.commentDetails!.map((v) => v.toJson()).toList();
    }
    data['court_no'] = this.courtNo;
    data['s_no'] = this.sNo;
    data['stage'] = this.stage;
    data['case_id'] = this.caseId;
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
