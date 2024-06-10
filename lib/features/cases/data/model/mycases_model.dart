class MyCasesModel {
  List<Data>? data;
  bool? isUserAllowed;
  String? msg;
  int? result;
  DownloadFileData? downloadFileData;

  MyCasesModel(
      {this.data,
      this.isUserAllowed,
      this.msg,
      this.result,
      this.downloadFileData});

  MyCasesModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      if (json['data'] is List) {
        data = <Data>[];
        json['data'].forEach((v) {
          data!.add(Data.fromJson(v));
        });
      } else {
        downloadFileData = DownloadFileData.fromJson(json['data']);
      }
    }
    isUserAllowed = json['isUserAllowed'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['isUserAllowed'] = this.isUserAllowed;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  String? caseDesion;
  int? caseId;
  String? caseName;
  int? caseNo;
  String? caseTitle;
  String? date;
  String? interim;
  int? isReaded;
  String? itmo;
  String? lastCauselistDate;
  String? officeStage;
  String? subCategory;
  bool? is_disposed;
  int? is_hide;
  String? stage;

  Data(
      {this.caseDesion,
      this.caseId,
      this.caseName,
      this.caseNo,
      this.caseTitle,
      this.date,
      this.interim,
      this.isReaded,
      this.itmo,
      this.lastCauselistDate,
      this.officeStage,
      this.subCategory,
      this.is_disposed,
      this.is_hide,
      this.stage});

  @override
  String toString() {
    return 'Data{caseDesion: $caseDesion, caseId: $caseId, caseName: $caseName, caseNo: $caseNo, caseTitle: $caseTitle, date: $date, interim: $interim, isReaded: $isReaded, itmo: $itmo, subCategory: $subCategory, is_disposed: $is_disposed}';
  }

  Data.fromJson(Map<String, dynamic> json) {
    caseDesion = json['case_desion'];
    caseId = json['case_id'];
    caseName = json['case_name'];
    caseNo = json['case_no'];
    caseTitle = json['case_title'];
    date = json['date'];
    interim = json['interim'];
    isReaded = json['is_readed'];
    itmo = json['itmo'];
    lastCauselistDate = json['last_causelist_date'];
    officeStage = json['office_stage'];
    subCategory = json['sub_category'];
    is_disposed = json['is_disposed'];
    is_hide = json['is_hide'];
    stage = json['stage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_desion'] = this.caseDesion;
    data['case_id'] = this.caseId;
    data['case_name'] = this.caseName;
    data['case_no'] = this.caseNo;
    data['case_title'] = this.caseTitle;
    data['date'] = this.date;
    data['interim'] = this.interim;
    data['is_readed'] = this.isReaded;
    data['itmo'] = this.itmo;
    data['last_causelist_date'] = this.lastCauselistDate;
    data['office_stage'] = this.officeStage;
    data['sub_category'] = this.subCategory;
    data['is_disposed'] = this.is_disposed;
    data['is_hide'] = this.is_hide;
    data['stage'] = this.stage;
    return data;
  }
}

class DownloadFileData {
  String? downloadFile;

  DownloadFileData({this.downloadFile});

  DownloadFileData.fromJson(Map<String, dynamic> json) {
    print("calling fromjson downloadfile");
    print("calling fromjson value ${json['download_file']}");
    downloadFile = json['download_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['download_file'] = this.downloadFile;
    return data;
  }
}
