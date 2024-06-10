class CreateWatchlistModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CreateWatchlistModel({this.data, this.isUserAllowed, this.msg, this.result});

  CreateWatchlistModel.fromJson(Map<String, dynamic> json) {
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
  int? watchlistId;

  Data({this.watchlistId});

  Data.fromJson(Map<String, dynamic> json) {
    watchlistId = json['watchlist_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['watchlist_id'] = this.watchlistId;
    return data;
  }
}
