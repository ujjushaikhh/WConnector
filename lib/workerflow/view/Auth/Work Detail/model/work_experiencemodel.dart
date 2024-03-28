class WorkerExpeireinceModel {
  String? status;
  String? message;
  List<ExpData>? data;

  WorkerExpeireinceModel({this.status, this.message, this.data});

  WorkerExpeireinceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ExpData>[];
      json['data'].forEach((v) {
        data!.add(ExpData.fromJson(v));
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

class ExpData {
  int? id;
  String? experience;

  ExpData({this.id, this.experience});

  ExpData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    experience = json['experience'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['experience'] = experience;
    return data;
  }
}
