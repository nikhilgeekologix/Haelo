class DisplayBoardModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  DisplayBoardModel({this.data, this.isUserAllowed, this.msg, this.result});

  DisplayBoardModel.fromJson(Map<String, dynamic> json) {
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
  String? date;
  List<Ticker>? ticker;
  String? time;

  Data({this.date, this.ticker, this.time});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
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
    data['date'] = this.date;
    if (this.ticker != null) {
      data['ticker'] = this.ticker!.map((v) => v.toJson()).toList();
    }
    data['time'] = this.time;
    return data;
  }
}

class Ticker {
  int? benchCount;
  List<BenchList>? benchList;
  int? courtNo;
  int? is_court_note;
  String? itemNo;
  List<String>? mycases;

  Ticker({this.benchCount, this.benchList, this.courtNo,this.is_court_note, this.itemNo, this.mycases});

  Ticker.fromJson(Map<String, dynamic> json) {
    benchCount = json['bench_count'];
    if (json['bench_list'] != null) {
      benchList = <BenchList>[];
      json['bench_list'].forEach((v) {
        benchList!.add(new BenchList.fromJson(v));
      });
    }
    courtNo = json['court_no'];
    is_court_note = json['is_court_note'];
    itemNo = json['item_no'];
    mycases = json['mycases'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bench_count'] = this.benchCount;
    if (this.benchList != null) {
      data['bench_list'] = this.benchList!.map((v) => v.toJson()).toList();
    }
    data['court_no'] = this.courtNo;
    data['is_court_note'] = this.is_court_note;
    data['item_no'] = this.itemNo;
    data['mycases'] = this.mycases;
    return data;
  }
}

class BenchList {
  String? benchName;

  BenchList({this.benchName});

  BenchList.fromJson(Map<String, dynamic> json) {
    benchName = json['Bench_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bench_name'] = this.benchName;
    return data;
  }
}
