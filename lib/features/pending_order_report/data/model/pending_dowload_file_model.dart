class PendingDownloadFileModel {
  Data? data;
  String? msg;
  int? result;

  PendingDownloadFileModel({this.data, this.msg, this.result});

  PendingDownloadFileModel.fromJson(Map<String, dynamic> json) {
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
  String? downloadFile;

  Data({this.downloadFile});

  Data.fromJson(Map<String, dynamic> json) {
    downloadFile = json['download_file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['download_file'] = this.downloadFile;
    return data;
  }
}
