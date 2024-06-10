class AboutUsModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  AboutUsModel({this.data, this.isUserAllowed, this.msg, this.result});

  AboutUsModel.fromJson(Map<String, dynamic> json) {
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
  String? aboutFounder;
  String? description;
  String? imgLink;
  String? title;
  String? youtudeLink;

  Data({this.aboutFounder, this.description, this.imgLink, this.title, this.youtudeLink});

  Data.fromJson(Map<String, dynamic> json) {
    aboutFounder = json['about_founder'];
    description = json['description'];
    imgLink = json['img_link'];
    title = json['title'];
    youtudeLink = json['youtude_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about_founder'] = this.aboutFounder;
    data['description'] = this.description;
    data['img_link'] = this.imgLink;
    data['title'] = this.title;
    data['youtude_link'] = this.youtudeLink;
    return data;
  }
}
