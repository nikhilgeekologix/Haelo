class OrderHistoryModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  OrderHistoryModel({this.data, this.isUserAllowed, this.msg, this.result});

  OrderHistoryModel.fromJson(Map<String, dynamic> json) {
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
  List<OrderDetails>? orderDetails;
  String? downloadFile;

  Data({this.orderDetails,  this.downloadFile});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['order_details'] != null) {
      orderDetails = <OrderDetails>[];
      json['order_details'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
    if(json['download_file'] != null){
      downloadFile=json['download_file'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  int? caseId;
  String? date;
  String? message;

  OrderDetails({this.caseId, this.date, this.message});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    caseId = json['case_id'];
    date = json['date'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_id'] = this.caseId;
    data['date'] = this.date;
    data['message'] = this.message;
    return data;
  }
}
