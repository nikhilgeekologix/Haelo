class CaseTaskListModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CaseTaskListModel({this.data, this.isUserAllowed, this.msg, this.result});

  CaseTaskListModel.fromJson(Map<String, dynamic> json) {
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
  List<TaskList>? taskList;

  Data({this.taskList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['task_list'] != null) {
      taskList = <TaskList>[];
      json['task_list'].forEach((v) {
        taskList!.add(new TaskList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.taskList != null) {
      data['task_list'] = this.taskList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskList {
  String? adminFile;
  String? assignerName;
  int? caseId;
  String? caseNo;
  String? creatorMobNo;
  String? creatorName;
  String? taskAssign;
  bool? taskClosure;
  int? taskCreator;
  String? taskDate;
  String? taskDesc;
  int? taskId;
  int? taskPriority;
  String? taskStatus;
  String? taskTitle;
  String? teamFile;
  String? teamReply;

  TaskList(
      {this.adminFile,
      this.assignerName,
      this.caseId,
      this.caseNo,
      this.creatorMobNo,
      this.creatorName,
      this.taskAssign,
      this.taskClosure,
      this.taskCreator,
      this.taskDate,
      this.taskDesc,
      this.taskId,
      this.taskPriority,
      this.taskStatus,
      this.taskTitle,
      this.teamFile,
      this.teamReply});

  TaskList.fromJson(Map<String, dynamic> json) {
    adminFile = json['admin_file'];
    assignerName = json['assigner_name'];
    caseId = json['case_id'];
    caseNo = json['case_no'];
    creatorMobNo = json['creator_mob_no'];
    creatorName = json['creator_name'];
    taskAssign = json['task_assign'];
    taskClosure = json['task_closure'];
    taskCreator = json['task_creator'];
    taskDate = json['task_date'];
    taskDesc = json['task_desc'];
    taskId = json['task_id'];
    taskPriority = json['task_priority'];
    taskStatus = json['task_status'];
    taskTitle = json['task_title'];
    teamFile = json['team_file'];
    teamReply = json['team_reply'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['admin_file'] = this.adminFile;
    data['assigner_name'] = this.assignerName;
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['creator_mob_no'] = this.creatorMobNo;
    data['creator_name'] = this.creatorName;
    data['task_assign'] = this.taskAssign;
    data['task_closure'] = this.taskClosure;
    data['task_creator'] = this.taskCreator;
    data['task_date'] = this.taskDate;
    data['task_desc'] = this.taskDesc;
    data['task_id'] = this.taskId;
    data['task_priority'] = this.taskPriority;
    data['task_status'] = this.taskStatus;
    data['task_title'] = this.taskTitle;
    data['team_file'] = this.teamFile;
    data['team_reply'] = this.teamReply;
    return data;
  }
}
