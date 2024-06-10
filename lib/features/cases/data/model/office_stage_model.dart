class OfficeStageModel {
  OficeStageData? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  OfficeStageModel({this.data, this.isUserAllowed, this.msg, this.result});

  OfficeStageModel.fromJson(Map<String, dynamic> json) {
    data =
        json['data'] != null ? new OficeStageData.fromJson(json['data']) : null;
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

class OficeStageData {
  List<OfficeStage>? oficeStage;

  OficeStageData({this.oficeStage});

  OficeStageData.fromJson(Map<String, dynamic> json) {
    if (json['ofice_stage'] != null) {
      oficeStage = <OfficeStage>[];
      json['ofice_stage'].forEach((v) {
        oficeStage!.add(new OfficeStage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.oficeStage != null) {
      data['ofice_stage'] = this.oficeStage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfficeStage {
  String? stageName;
  bool? status;

  OfficeStage({this.stageName, this.status});

  OfficeStage.fromJson(Map<String, dynamic> json) {
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
