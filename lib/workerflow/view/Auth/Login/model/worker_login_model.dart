class WorkerLoginModel {
  String? status;
  String? message;
  Data? data;

  WorkerLoginModel({this.status, this.message, this.data});

  WorkerLoginModel.fromJson(Map<String, dynamic> json) {
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
  String? pageNo;

  Data(
      {this.token,
      this.id,
      this.langId,
      this.name,
      this.email,
      this.image,
      this.deviceId,
      this.deviceType,
      this.isVerify,
      this.pageNo});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    langId = json['lang_id'];
    name = json['name'];
    email = json['email'];
    image = json['image'];
    deviceId = json['device_id'];
    deviceType = json['device_type'];
    isVerify = json['is_verify'];
    pageNo = json['page_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['id'] = id;
    data['lang_id'] = langId;
    data['name'] = name;
    data['email'] = email;
    data['image'] = image;
    data['device_id'] = deviceId;
    data['device_type'] = deviceType;
    data['is_verify'] = isVerify;
    data['page_no'] = pageNo;
    return data;
  }
}
