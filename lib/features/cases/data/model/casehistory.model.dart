class CaseHistoryModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CaseHistoryModel({this.data, this.isUserAllowed, this.msg, this.result});

  CaseHistoryModel.fromJson(Map<String, dynamic> json) {
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
  CaseCounsel? caseCounsel;
  List<CaseList>? caseList;
  String? dateOfListing; //previous not used now
  String? date_type;
  String? court_date;
  int? no_of_weeks;
  List<OfficeStages>? officeStages;

  Data(
      {this.caseCounsel,
      this.caseList,
      this.dateOfListing,
      this.date_type,
      this.court_date,
      this.no_of_weeks,
      this.officeStages});

  Data.fromJson(Map<String, dynamic> json) {
    caseCounsel = json['case_counsel'] != null
        ? new CaseCounsel.fromJson(json['case_counsel'])
        : null;
    if (json['case_list'] != null) {
      caseList = <CaseList>[];
      json['case_list'].forEach((v) {
        caseList!.add(new CaseList.fromJson(v));
      });
    }
    dateOfListing = json['date_of_listing'];
    date_type = json['date_type'];
    court_date = json['court_date'];
    no_of_weeks = json['no_of_weeks'];
    if (json['office_stages'] != null) {
      officeStages = <OfficeStages>[];
      json['office_stages'].forEach((v) {
        officeStages!.add(new OfficeStages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.caseCounsel != null) {
      data['case_counsel'] = this.caseCounsel!.toJson();
    }
    if (this.caseList != null) {
      data['case_list'] = this.caseList!.map((v) => v.toJson()).toList();
    }
    data['date_of_listing'] = this.dateOfListing;
    data['date_type'] = this.date_type;
    data['court_date'] = this.court_date;
    data['no_of_weeks'] = this.no_of_weeks;
    if (this.officeStages != null) {
      data['office_stages'] =
          this.officeStages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CaseCounsel {
  String? interimCol;
  bool? interimStay;
  String? officeStage;
  bool? seniorCounselEngaged;

  CaseCounsel(
      {this.interimCol,
      this.interimStay,
      this.officeStage,
      this.seniorCounselEngaged});

  CaseCounsel.fromJson(Map<String, dynamic> json) {
    interimCol = json['interim_col'];
    interimStay = json['interim_stay'];
    officeStage = json['office_stage'];
    seniorCounselEngaged = json['senior_counsel_engaged'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['interim_col'] = this.interimCol;
    data['interim_stay'] = this.interimStay;
    data['office_stage'] = this.officeStage;
    data['senior_counsel_engaged'] = this.seniorCounselEngaged;
    return data;
  }
}

class CaseList {
  String? benchName;
  List<CommentDetails>? commentDetails;
  String? courtNo;
  String? dateOfListing;
  String? officeStage;
  String? orderFile;
  String? sno;
  String? stage;
  List<TaskListing>? taskListing;
  bool isCommentViewMore = false;
  bool isTaskViewMore = false;

  CaseList(
      {this.benchName,
      this.commentDetails,
      this.courtNo,
      this.dateOfListing,
      this.officeStage,
      this.orderFile,
      this.sno,
      this.stage,
      this.taskListing,
      this.isCommentViewMore = false,
      this.isTaskViewMore = false});

  CaseList.fromJson(Map<String, dynamic> json) {
    benchName = json['bench_name'];
    if (json['comment_details'] != null) {
      commentDetails = <CommentDetails>[];
      json['comment_details'].forEach((v) {
        commentDetails!.add(new CommentDetails.fromJson(v));
      });
    }
    courtNo = json['court_no'];
    dateOfListing = json['date_of_listing'];
    officeStage = json['office_stage'];
    orderFile = json['order_file'];
    sno = json['sno'];
    stage = json['stage'];
    if (json['task_listing'] != null) {
      taskListing = <TaskListing>[];
      json['task_listing'].forEach((v) {
        taskListing!.add(new TaskListing.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_name'] = this.benchName;
    if (this.commentDetails != null) {
      data['comment_details'] =
          this.commentDetails!.map((v) => v.toJson()).toList();
    }
    data['court_no'] = this.courtNo;
    data['date_of_listing'] = this.dateOfListing;
    data['office_stage'] = this.officeStage;
    data['order_file'] = this.orderFile;
    data['sno'] = this.sno;
    data['stage'] = this.stage;
    if (this.taskListing != null) {
      data['task_listing'] = this.taskListing!.map((v) => v.toJson()).toList();
    }
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

class TaskListing {
  String? taskDate;
  String? taskDesc;
  int? taskId;
  int? taskPriority;
  String? taskStatus;
  String? taskTitle;

  TaskListing(
      {this.taskDate,
      this.taskDesc,
      this.taskId,
      this.taskPriority,
      this.taskStatus,
      this.taskTitle});

  TaskListing.fromJson(Map<String, dynamic> json) {
    taskDate = json['task_date'];
    taskDesc = json['task_desc'];
    taskId = json['task_id'];
    taskPriority = json['task_priority'];
    taskStatus = json['task_status'];
    taskTitle = json['task_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['task_date'] = this.taskDate;
    data['task_desc'] = this.taskDesc;
    data['task_id'] = this.taskId;
    data['task_priority'] = this.taskPriority;
    data['task_status'] = this.taskStatus;
    data['task_title'] = this.taskTitle;
    return data;
  }
}

class OfficeStages {
  String? stageName;
  bool? status;

  OfficeStages({this.stageName, this.status});

  OfficeStages.fromJson(Map<String, dynamic> json) {
    stageName = json['stage_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stage_name'] = this.stageName;
    data['status'] = this.status;
    return data;
  }
}
