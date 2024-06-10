class AddEventModel {
  String? msg;
  int? result;

  AddEventModel({this.msg, this.result});

  AddEventModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class DeleteWatchlistModel {
  String? msg;
  int? result;

  DeleteWatchlistModel({this.msg, this.result});

  DeleteWatchlistModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}


class EditWatchlistModel {
  String? msg;
  int? result;

  EditWatchlistModel({this.msg, this.result});

  EditWatchlistModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}