class CreateTaskModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CreateTaskModel({this.data, this.isUserAllowed, this.msg, this.result});

  CreateTaskModel.fromJson(Map<String, dynamic> json) {
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
  int? creatorId;
  String? uploadedFile;

  Data({this.creatorId, this.uploadedFile});

  Data.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    uploadedFile = json['uploaded_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creator_id'] = this.creatorId;
    data['uploaded_file'] = this.uploadedFile;
    return data;
  }
}
