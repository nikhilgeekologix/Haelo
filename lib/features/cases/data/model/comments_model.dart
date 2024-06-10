class CasesCommentModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CasesCommentModel({this.data, this.isUserAllowed, this.msg, this.result});

  CasesCommentModel.fromJson(Map<String, dynamic> json) {
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
  List<Commentlist>? commentlist;

  Data({this.commentlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['commentlist'] != null) {
      commentlist = <Commentlist>[];
      json['commentlist'].forEach((v) {
        commentlist!.add(new Commentlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commentlist != null) {
      data['commentlist'] = this.commentlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Commentlist {
  String? comment;
  int? commentId;
  String? mobNo;
  String? timestamp;
  int? userId;
  String? userName;

  Commentlist({this.comment, this.commentId, this.mobNo, this.timestamp, this.userId, this.userName});

  Commentlist.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    commentId = json['comment_id'];
    mobNo = json['mob_no'];
    timestamp = json['timestamp'];
    userId = json['user_id'];
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['comment_id'] = this.commentId;
    data['mob_no'] = this.mobNo;
    data['timestamp'] = this.timestamp;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    return data;
  }
}
