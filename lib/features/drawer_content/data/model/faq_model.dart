class FAQModel {
  List<Data>? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  FAQModel({this.data, this.isUserAllowed, this.msg, this.result});

  FAQModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    isUserAllowed = json['isUserAllowed'];
    msg = json['msg'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['isUserAllowed'] = this.isUserAllowed;
    data['msg'] = this.msg;
    data['result'] = this.result;
    return data;
  }
}

class Data {
  String? answer;
  String? question;
  String? youtudeLink;

  Data({this.answer, this.question, this.youtudeLink});

  Data.fromJson(Map<String, dynamic> json) {
    answer = json['answer'];
    question = json['question'];
    youtudeLink = json['youtude_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answer'] = this.answer;
    data['question'] = this.question;
    data['youtude_link'] = this.youtudeLink;
    return data;
  }
}
