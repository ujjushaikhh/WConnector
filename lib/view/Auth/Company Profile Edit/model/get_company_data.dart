class GetCompanyDetailModel {
  String? status;
  String? message;
  CompanyData? data;

  GetCompanyDetailModel({this.status, this.message, this.data});

  GetCompanyDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? CompanyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CompanyData {
  int? id;
  String? name;
  String? email;
  int? langId;
  String? address;
  String? latitude;
  String? longitude;
  String? userImage;
  String? typeOfCompany;
  String? companyDescription;
  String? legalDocument;

  CompanyData(
      {this.id,
      this.name,
      this.email,
      this.langId,
      this.address,
      this.latitude,
      this.longitude,
      this.userImage,
      this.typeOfCompany,
      this.companyDescription,
      this.legalDocument});

  CompanyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    langId = json['lang_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    userImage = json['user_image'];
    typeOfCompany = json['type_of_Company'];
    companyDescription = json['company_description'];
    legalDocument = json['legal_document'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['lang_id'] = langId;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['user_image'] = userImage;
    data['type_of_Company'] = typeOfCompany;
    data['company_description'] = companyDescription;
    data['legal_document'] = legalDocument;
    return data;
  }
}
