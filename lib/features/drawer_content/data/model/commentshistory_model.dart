class CommentsHistoryModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;
  //DownloadFileData? downloadFileData;

  CommentsHistoryModel({this.data, this.isUserAllowed, this.msg, this.result,
    });

  CommentsHistoryModel.fromJson(Map<String, dynamic> json) {
    //data = json['data'] != null ? new Data.fromJson(json['data']) : null;


    if (json['data'] != null) {
      data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    }

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
  List<CommentDetails>? commentDetails;
  String? downloadFile;

  Data({this.commentDetails, this.downloadFile});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['comment_details'] != null) {
      commentDetails = <CommentDetails>[];
      json['comment_details'].forEach((v) {
        commentDetails!.add(new CommentDetails.fromJson(v));
      });
    }
    if(json['download_file'] != null){
      downloadFile=json['download_file'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commentDetails != null) {
      data['comment_details'] =
          this.commentDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentDetails {
  int? caseId;
  String? caseName;
  String? caseTitle;
  String? comment;
  String? courtNo;
  String? dateOfListing;
  String? sno;
  String? timestamp;
  String? user;

  CommentDetails(
      {this.caseId,
        this.caseName,
        this.caseTitle,
        this.comment,
        this.courtNo,
        this.dateOfListing,
        this.sno,
        this.timestamp,
        this.user});

  CommentDetails.fromJson(Map<String, dynamic> json) {
    caseId = json['case_id'];
    caseName = json['case_name'];
    caseTitle = json['case_title'];
    comment = json['comment'];
    courtNo = json['court_no'];
    dateOfListing = json['date_of_listing'];
    sno = json['sno'];
    timestamp = json['timestamp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_id'] = this.caseId;
    data['case_name'] = this.caseName;
    data['case_title'] = this.caseTitle;
    data['comment'] = this.comment;
    data['court_no'] = this.courtNo;
    data['date_of_listing'] = this.dateOfListing;
    data['sno'] = this.sno;
    data['timestamp'] = this.timestamp;
    data['user'] = this.user;
    return data;
  }
}

class DownloadFileData {
  String? downloadFile;

  DownloadFileData({this.downloadFile});

  DownloadFileData.fromJson(Map<String, String> json) {
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
