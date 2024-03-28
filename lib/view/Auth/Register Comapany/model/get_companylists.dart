class CompanyTypesModel {
  String? status;
  String? message;
  List<Data>? data;

  CompanyTypesModel({this.status, this.message, this.data});

  CompanyTypesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? companyTypes;

  Data({this.id, this.companyTypes});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyTypes = json['company_types'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_types'] = companyTypes;
    return data;
  }
}
