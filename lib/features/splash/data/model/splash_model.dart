class SplashModel {
  Data? data;
  int? result;

  SplashModel({this.data, this.result});

  SplashModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['result'] = this.result;
    return data;
  }
}

class Data {
  int? appStatus;
  String? appVersion;
  bool? isMandatory;

  Data({this.appStatus, this.appVersion, this.isMandatory});

  Data.fromJson(Map<String, dynamic> json) {
    appStatus = json['app_status'];
    appVersion = json['app_version'];
    isMandatory = json['is_mandatory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_status'] = this.appStatus;
    data['app_version'] = this.appVersion;
    data['is_mandatory'] = this.isMandatory;
    return data;
  }
}
