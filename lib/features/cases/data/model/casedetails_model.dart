class CaseDetailModel {
  Data? data;
  bool? isUserAllowed;
  String? msg;
  int? result;

  CaseDetailModel({this.data, this.isUserAllowed, this.msg, this.result});

  CaseDetailModel.fromJson(Map<String, dynamic> json) {
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
  CaseDetail? caseDetail;
  ConnectedCases? connectedCases;
  ConnectedMatters? connectedMatters;
  FilingDetail? filingDetail;
  LowerCourtDetails? lowerCourtDetails;
  UserDetail? userDetail;
  String? drivePath;

  Data(
      {this.caseDetail,
      this.connectedCases,
      this.connectedMatters,
      this.filingDetail,
      this.lowerCourtDetails,
      this.userDetail, this.drivePath});

  Data.fromJson(Map<String, dynamic> json) {
    caseDetail = json['case_detail'] != null ? new CaseDetail.fromJson(json['case_detail']) : null;
    connectedCases = json['connected_cases'] != null ? new ConnectedCases.fromJson(json['connected_cases']) : null;
    connectedMatters =
        json['connected_matters'] != null ? new ConnectedMatters.fromJson(json['connected_matters']) : null;
    filingDetail = json['filing_detail'] != null ? new FilingDetail.fromJson(json['filing_detail']) : null;
    lowerCourtDetails =
        json['lower_court_details'] != null ? new LowerCourtDetails.fromJson(json['lower_court_details']) : null;
    userDetail = json['user_detail'] != null ? new UserDetail.fromJson(json['user_detail']) : null;
    drivePath=json['drive_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.caseDetail != null) {
      data['case_detail'] = this.caseDetail!.toJson();
    }
    if (this.connectedCases != null) {
      data['connected_cases'] = this.connectedCases!.toJson();
    }
    if (this.connectedMatters != null) {
      data['connected_matters'] = this.connectedMatters!.toJson();
    }
    if (this.filingDetail != null) {
      data['filing_detail'] = this.filingDetail!.toJson();
    }
    if (this.lowerCourtDetails != null) {
      data['lower_court_details'] = this.lowerCourtDetails!.toJson();
    }
    if (this.userDetail != null) {
      data['user_detail'] = this.userDetail!.toJson();
    }
    data['drive_path']=this.drivePath;
    return data;
  }
}

class CaseDetail {
  String? bench;
  String? cNR;
  String? courtFees;
  String? dateOfListing;
  String? dateOfQuery;
  String? filedOn;
  String? filingDetails;
  String? petitioner;
  String? petitionerAdvocate;
  String? regDetails;
  String? registeredOn;
  String? registrationType;
  String? respondent;
  String? respondentAdvocate;
  String? stage;
  String? decision;
  String? listingInCourt;

  CaseDetail(
      {this.bench,
      this.cNR,
      this.courtFees,
      this.dateOfListing,
      this.dateOfQuery,
      this.filedOn,
      this.filingDetails,
      this.petitioner,
      this.petitionerAdvocate,
      this.regDetails,
      this.registeredOn,
      this.registrationType,
      this.respondent,
      this.respondentAdvocate,
      this.stage,
      this.decision,
      this.listingInCourt});

  CaseDetail.fromJson(Map<String, dynamic> json) {
    bench = json['Bench'];
    cNR = json['CNR'];
    courtFees = json['Court Fees'];
    dateOfListing = json['Date of Listing'];
    dateOfQuery = json['Date of query'];
    filedOn = json['Filed on'];
    filingDetails = json['Filing Details'];
    petitioner = json['Petitioner'];
    petitionerAdvocate = json['Petitioner Advocate'];
    regDetails = json['Reg. Details'];
    registeredOn = json['Registered on'];
    registrationType = json['Registration Type'];
    respondent = json['Respondent'];
    respondentAdvocate = json['Respondent Advocate'];
    stage = json['Stage'];
    decision = json['decision'];
    listingInCourt = json['listing in court'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Bench'] = this.bench;
    data['CNR'] = this.cNR;
    data['Court Fees'] = this.courtFees;
    data['Date of Listing'] = this.dateOfListing;
    data['Date of query'] = this.dateOfQuery;
    data['Filed on'] = this.filedOn;
    data['Filing Details'] = this.filingDetails;
    data['Petitioner'] = this.petitioner;
    data['Petitioner Advocate'] = this.petitionerAdvocate;
    data['Reg. Details'] = this.regDetails;
    data['Registered on'] = this.registeredOn;
    data['Registration Type'] = this.registrationType;
    data['Respondent'] = this.respondent;
    data['Respondent Advocate'] = this.respondentAdvocate;
    data['Stage'] = this.stage;
    data['decision'] = this.decision;
    data['listing in court'] = this.listingInCourt;
    return data;
  }
}

class ConnectedCases {
  String? tYPE;
  String? no;

  ConnectedCases({this.tYPE, this.no});

  ConnectedCases.fromJson(Map<String, dynamic> json) {
    tYPE = json['TYPE'];
    no = json['No.'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TYPE'] = this.tYPE;
    data['No.'] = this.no;
    return data;
  }
}

class ConnectedMatters {
  String? type;
  String? no;

  ConnectedMatters({this.type, this.no});

  ConnectedMatters.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    no = json['No.'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['No.'] = this.no;
    return data;
  }
}

class FilingDetail {
  String? courtFees;
  String? filingDate;
  String? mainCase;
  String? number;

  FilingDetail({this.courtFees, this.filingDate, this.mainCase, this.number});

  FilingDetail.fromJson(Map<String, dynamic> json) {
    courtFees = json['Court Fees'];
    filingDate = json['Filing Date'];
    mainCase = json['Main case'];
    number = json['Number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Court Fees'] = this.courtFees;
    data['Filing Date'] = this.filingDate;
    data['Main case'] = this.mainCase;
    data['Number'] = this.number;
    return data;
  }
}

class LowerCourtDetails {
  String? caseNo;
  String? judgeship;
  String? place;
  String? court;
  String? dateOfImpugnedOrder;

  LowerCourtDetails({this.caseNo, this.judgeship, this.place, this.court, this.dateOfImpugnedOrder});

  LowerCourtDetails.fromJson(Map<String, dynamic> json) {
    caseNo = json['Case_no'];
    judgeship = json['Judgeship'];
    place = json['Place'];
    court = json['Court'];
    dateOfImpugnedOrder = json['date_of_Impugned_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Case_no'] = this.caseNo;
    data['Judgeship'] = this.judgeship;
    data['Place'] = this.place;
    data['Court'] = this.court;
    data['date_of_Impugned_order'] = this.dateOfImpugnedOrder;
    return data;
  }
}

class UserDetail {
  String? caseCategory;
  String? caseFilingNo;
  int? caseId;
  int? caseNo;
  String? caseType;
  int? caseYear;
  String? email;
  bool? interimStay;
  String? itmo;
  String? mobNo;
  bool? seniorCounselEngaged;
  int? userId;

  UserDetail(
      {this.caseCategory,
      this.caseFilingNo,
      this.caseId,
      this.caseNo,
      this.caseType,
      this.caseYear,
      this.email,
      this.interimStay,
      this.itmo,
      this.mobNo,
      this.seniorCounselEngaged,
      this.userId});

  UserDetail.fromJson(Map<String, dynamic> json) {
    caseCategory = json['case_category'];
    caseFilingNo = json['case_filing_no'];
    caseId = json['case_id'];
    caseNo = json['case_no'];
    caseType = json['case_type'];
    caseYear = json['case_year'];
    email = json['email'];
    interimStay = json['interim_stay'];
    itmo = json['itmo'];
    mobNo = json['mob_no'];
    seniorCounselEngaged = json['senior_counsel_engaged'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_category'] = this.caseCategory;
    data['case_filing_no'] = this.caseFilingNo;
    data['case_id'] = this.caseId;
    data['case_no'] = this.caseNo;
    data['case_type'] = this.caseType;
    data['case_year'] = this.caseYear;
    data['email'] = this.email;
    data['interim_stay'] = this.interimStay;
    data['itmo'] = this.itmo;
    data['mob_no'] = this.mobNo;
    data['senior_counsel_engaged'] = this.seniorCounselEngaged;
    data['user_id'] = this.userId;
    return data;
  }
}
