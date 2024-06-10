class UpdateDisplayBoardModel {
  UpdateData? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  UpdateDisplayBoardModel(
      {this.data, this.isUserAllowed, this.msg, this.result});

  UpdateDisplayBoardModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new UpdateData.fromJson(json['data']) : null;
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

class UpdateData {
  Data? data;

  UpdateData({this.data});

  UpdateData.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Ticker>? ticker;
  String? time;

  Data({this.ticker, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['ticker'] != null) {
      ticker = <Ticker>[];
      json['ticker'].forEach((v) {
        ticker!.add(new Ticker.fromJson(v));
      });
    }
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ticker != null) {
      data['ticker'] = this.ticker!.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    return data;
  }
}

class Ticker {
  int? courtNo;
  String? itemNo;

  Ticker({this.courtNo, this.itemNo});

  Ticker.fromJson(Map<String, dynamic> json) {
    courtNo = json['court_no'];
    itemNo = json['item_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['court_no'] = this.courtNo;
    data['item_no'] = this.itemNo;
    return data;
  }
}
