class ShowWatchlistModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  ShowWatchlistModel({this.data, this.isUserAllowed, this.msg, this.result});

  ShowWatchlistModel.fromJson(Map<String, dynamic> json) {
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
  List<CauseWatchlist>? causeWatchlist;
  List<CauseWatchlist>? watchlist;

  Data({this.causeWatchlist, this.watchlist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cause_watchlist'] != null) {
      causeWatchlist = <CauseWatchlist>[];
      json['cause_watchlist'].forEach((v) {
        causeWatchlist!.add(new CauseWatchlist.fromJson(v));
      });
    }
    if (json['watchlist'] != null) {
      watchlist = <CauseWatchlist>[];
      json['watchlist'].forEach((v) {
        watchlist!.add(new CauseWatchlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.causeWatchlist != null) {
      data['cause_watchlist'] = this.causeWatchlist!.map((v) => v.toJson()).toList();
    }
    if (this.watchlist != null) {
      data['watchlist'] = this.watchlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CauseWatchlist {
  int? watchlistId;
  String? watchlistName;

  CauseWatchlist({this.watchlistId, this.watchlistName});

  CauseWatchlist.fromJson(Map<String, dynamic> json) {
    watchlistId = json['watchlist_id'];
    watchlistName = json['watchlist_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['watchlist_id'] = this.watchlistId;
    data['watchlist_name'] = this.watchlistName;
    return data;
  }
}
