class LoginModel {
  String? status;
  String? message;
  Data? data;

  LoginModel({this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  String? token;
  int? id;
  int? langId;
  String? name;
  String? email;
  String? image;
  String? deviceId;
  String? deviceType;
  int? isVerify;

  Data(
      {this.token,
      this.id,
      this.name,
      this.email,
      this.image,
      this.langId,
      this.deviceId,
      this.deviceType,
      this.isVerify});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    name = json['name'];
    langId = json['lang_id'];
    email = json['email'];
    image = json['image'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    isVerify = json['is_verify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['device_id'] = deviceId;
    data['lang_id'] = langId;
    data['device_type'] = deviceType;
    data['is_verify'] = isVerify;
    return data;
  }
}
