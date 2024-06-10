class CaseDocumentsModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CaseDocumentsModel({this.data, this.isUserAllowed, this.msg, this.result});

  CaseDocumentsModel.fromJson(Map<String, dynamic> json) {
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
  List<UploadedDocx>? uploadedDocx;

  Data({this.uploadedDocx});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['uploaded_docx'] != null) {
      uploadedDocx = <UploadedDocx>[];
      json['uploaded_docx'].forEach((v) {
        uploadedDocx!.add(new UploadedDocx.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uploadedDocx != null) {
      data['uploaded_docx'] = this.uploadedDocx!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UploadedDocx {
  int? caseYear;
  DocumentDetails? documentDetails;
  int? documentId;
  String? documentName;
  String? localDocPath;

  UploadedDocx({this.caseYear, this.documentDetails, this.documentId, this.documentName, this.localDocPath});

  UploadedDocx.fromJson(Map<String, dynamic> json) {
    caseYear = json['case_year'];
    documentDetails = json['document_details'] != null ? new DocumentDetails.fromJson(json['document_details']) : null;
    documentId = json['document_id'];
    documentName = json['document_name'];
    localDocPath = json['local_doc_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_year'] = this.caseYear;
    if (this.documentDetails != null) {
      data['document_details'] = this.documentDetails!.toJson();
    }
    data['document_id'] = this.documentId;
    data['document_name'] = this.documentName;
    data['local_doc_path'] = this.localDocPath;
    return data;
  }
}

class DocumentDetails {
  String? text1;
  String? text2;
  String? text3;
  String? text4;
  String? text5;

  DocumentDetails({this.text1, this.text2, this.text3, this.text4, this.text5});

  DocumentDetails.fromJson(Map<String, dynamic> json) {
    text1 = json['text1'];
    text2 = json['text2'];
    text3 = json['text3'];
    text4 = json['text4'];
    text5 = json['text5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text1'] = this.text1;
    data['text2'] = this.text2;
    data['text3'] = this.text3;
    data['text4'] = this.text4;
    data['text5'] = this.text5;
    return data;
  }
}
