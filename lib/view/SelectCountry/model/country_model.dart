class CountryModel {
  String? status;
  String? message;
  List<Data>? data;

  CountryModel({this.status, this.message, this.data});

  CountryModel.fromJson(Map<String, dynamic> json) {
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
  String? countryName;
  int? countryId;
  String? countryPhoneCode;

  Data({this.countryName, this.countryId, this.countryPhoneCode});

  Data.fromJson(Map<String, dynamic> json) {
    countryName = json['CountryName'];
    countryId = json['CountryId'];
    countryPhoneCode = json['CountryPhoneCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CountryName'] = countryName;
    data['CountryId'] = countryId;
    data['CountryPhoneCode'] = countryPhoneCode;
    return data;
  }
}
