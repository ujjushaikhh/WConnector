class JobPerHrsModel {
  String? status;
  String? message;
  List<PerHours>? perhour;

  JobPerHrsModel({this.status, this.message, this.perhour});

  JobPerHrsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      perhour = <PerHours>[];
      json['data'].forEach((v) {
        perhour!.add(PerHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (perhour != null) {
      data['data'] = perhour!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PerHours {
  int? id;
  String? time;

  PerHours({this.id, this.time});

  PerHours.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time;
    return data;
  }
}
