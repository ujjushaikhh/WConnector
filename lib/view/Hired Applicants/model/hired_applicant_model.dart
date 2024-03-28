class HiredApplicantModel {
  String? status;
  List<Users>? users;

  HiredApplicantModel({this.status, this.users});

  HiredApplicantModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Users {
  int? userId;
  String? userName;
  String? address;
  String? latitude;
  String? longitude;
  String? jobName;
  String? jobLocation;
  String? userImage;

  Users(
      {this.userId,
      this.userName,
      this.address,
      this.latitude,
      this.longitude,
      this.jobName,
      this.jobLocation,
      this.userImage});

  Users.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    jobName = json['job_name'];
    jobLocation = json['job_location'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['job_name'] = jobName;
    data['job_location'] = jobLocation;
    data['user_image'] = userImage;
    return data;
  }
}
