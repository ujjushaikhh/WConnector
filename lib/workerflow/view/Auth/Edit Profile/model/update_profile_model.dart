class UpdateUserModel {
  String? status;
  String? message;
  Data? data;

  UpdateUserModel({this.status, this.message, this.data});

  UpdateUserModel.fromJson(Map<String, dynamic> json) {
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
  int? userId;
  String? jobName;
  String? email;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? isStudent;
  String? university;
  String? userImage;
  String? tRC;
  String? passport;

  Data(
      {this.userId,
      this.jobName,
      this.email,
      this.address,
      this.latitude,
      this.longitude,
      this.phone,
      this.isStudent,
      this.university,
      this.userImage,
      this.tRC,
      this.passport});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    jobName = json['job_name'];
    email = json['email'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    isStudent = json['is_student'];
    university = json['university'];
    userImage = json['user_image'];
    tRC = json['TRC'];
    passport = json['Passport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['job_name'] = jobName;
    data['email'] = email;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    data['is_student'] = isStudent;
    data['university'] = university;
    data['user_image'] = userImage;
    data['TRC'] = tRC;
    data['Passport'] = passport;
    return data;
  }
}
