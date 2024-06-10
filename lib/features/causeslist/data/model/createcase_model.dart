import 'dart:convert';

CauseListCreateCaseModel causeListCreateCaseModelFromJson(String str) =>
    CauseListCreateCaseModel.fromJson(json.decode(str));

String causeListCreateCaseModelToJson(CauseListCreateCaseModel data) => json.encode(data.toJson());

class CauseListCreateCaseModel {
  CauseListCreateCaseModel({
    required this.data,
    required this.isUserAllowed,
    required this.msg,
    required this.result,
  });

  Data data;
  bool isUserAllowed;
  String msg;
  int result;

  factory CauseListCreateCaseModel.fromJson(Map<String, dynamic> json) => CauseListCreateCaseModel(
        data: Data.fromJson(json["data"]),
        isUserAllowed: json["isUserAllowed"],
        msg: json["msg"],
        result: json["result"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "isUserAllowed": isUserAllowed,
        "msg": msg,
        "result": result,
      };
}

class Data {
  Data({
    required this.dataCase,
  });

  Case dataCase;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        dataCase: Case.fromJson(json["case"]),
      );

  Map<String, dynamic> toJson() => {
        "case": dataCase.toJson(),
      };
}

class Case {
  Case({
    required this.caseCat,
    required this.caseNo,
    required this.caseType,
    required this.caseYear,
  });

  String caseCat;
  String caseNo;
  String caseType;
  String caseYear;

  factory Case.fromJson(Map<String, dynamic> json) => Case(
        caseCat: json["case_cat"],
        caseNo: json["case_no"],
        caseType: json["case_type"],
        caseYear: json["case_year"],
      );

  Map<String, dynamic> toJson() => {
        "case_cat": caseCat,
        "case_no": caseNo,
        "case_type": caseType,
        "case_year": caseYear,
      };
}
