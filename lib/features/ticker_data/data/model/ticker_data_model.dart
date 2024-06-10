class TickerDataModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  TickerDataModel({this.data, this.isUserAllowed, this.msg, this.result});

  TickerDataModel.fromJson(Map<String, dynamic> json) {
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
  List<String>? expiryList;
  List<TickerData>? tickerData;

  Data({this.expiryList, this.tickerData});

  Data.fromJson(Map<String, dynamic> json) {
    expiryList = json['expiry_list'].cast<String>();
    if (json['ticker_data'] != null) {
      tickerData = <TickerData>[];
      json['ticker_data'].forEach((v) {
        tickerData!.add(new TickerData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry_list'] = this.expiryList;
    if (this.tickerData != null) {
      data['ticker_data'] = this.tickerData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TickerData {
  String? courtNo;
  String? itemNo;
  String? startTime;
  String? time;

  TickerData({this.courtNo, this.itemNo, this.time});

  TickerData.fromJson(Map<String, dynamic> json) {
    courtNo = json['court_no'];
    itemNo = json['item_no'];
    startTime = json['start_time'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['court_no'] = this.courtNo;
    data['item_no'] = this.itemNo;
    data['start_time'] = this.startTime;
    data['time'] = this.time;
    return data;
  }
}
