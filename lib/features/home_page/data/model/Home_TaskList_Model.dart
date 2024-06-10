class HomeTaskListModel {
  int? count;
  List<TaskData>? data;
  bool? isUserAllowed;
  int? limit;
  String? msg;
  int? pages;
  int? result;
  int? start;

  HomeTaskListModel(
      {this.count, this.data, this.isUserAllowed, this.limit, this.msg, this.pages, this.result, this.start});

  HomeTaskListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['data'] != null) {
      data = <TaskData>[];
      json['data'].forEach((v) {
        data!.add(new TaskData.fromJson(v));
      });
    }
    isUserAllowed = json['isUserAllowed'];
    limit = json['limit'];
    msg = json['msg'];
    pages = json['pages'];
    result = json['result'];
    start = json['start'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['isUserAllowed'] = this.isUserAllowed;
    data['limit'] = this.limit;
    data['msg'] = this.msg;
    data['pages'] = this.pages;
    data['result'] = this.result;
    data['start'] = this.start;
    return data;
  }
}

class TaskData {
  String? taskDate;
  String? taskDesc;
  int? taskId;
  int? taskPriority;
  String? taskStatus;
  String? taskTitle;

  TaskData({this.taskDate, this.taskDesc, this.taskId, this.taskPriority, this.taskStatus, this.taskTitle});

  TaskData.fromJson(Map<String, dynamic> json) {
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
