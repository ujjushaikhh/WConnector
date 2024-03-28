class UpdateCompanyDetailModel {
  String? status;
  String? message;
  UpdateData? data;

  UpdateCompanyDetailModel({this.status, this.message, this.data});

  UpdateCompanyDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? UpdateData.fromJson(json['data']) : null;
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

class UpdateData {
  int? id;
  String? name;
  String? email;
  int? langId;
  String? address;
  String? latitude;
  String? longitude;
  String? userImage;

  UpdateData(
      {this.id,
      this.name,
      this.email,
      this.langId,
      this.address,
      this.latitude,
      this.longitude,
      this.userImage});

  UpdateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    langId = json['lang_id'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    userImage = json['user_image'];
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
    return data;
  }
}
