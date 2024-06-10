class AddCaseTypeModel {
  Data? data;
  String? msg;
  int? result;

  AddCaseTypeModel({this.data, this.msg, this.result});

  AddCaseTypeModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  List<String>? civil;
  List<String>? criminal;
  List<String>? writ;

  Data({this.civil, this.criminal, this.writ});

  Data.fromJson(Map<String, dynamic> json) {
    civil = json['Civil'].cast<String>();
    criminal = json['Criminal'].cast<String>();
    writ = json['Writ'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Civil'] = this.civil;
    data['Criminal'] = this.criminal;
    data['Writ'] = this.writ;
    return data;
  }
}
