class JobRoleModel {
  String? status;
  String? message;
  List<RoleData>? data;

  JobRoleModel({this.status, this.message, this.data});

  JobRoleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RoleData>[];
      json['data'].forEach((v) {
        data!.add(RoleData.fromJson(v));
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

class RoleData {
  int? id;
  String? roleEnglish;

  RoleData({this.id, this.roleEnglish});

  RoleData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleEnglish = json['role_English'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_English'] = roleEnglish;
    return data;
  }
}
