class WorkerDetailsModel {
  int? status;
  String? message;
  DetailData? data;

  WorkerDetailsModel({this.status, this.message, this.data});

  WorkerDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DetailData.fromJson(json['data']) : null;
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

class DetailData {
  String? token;
  int? pageno;

  DetailData({this.token, this.pageno});

  DetailData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    pageno = json['pageno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['pageno'] = pageno;
    return data;
  }
}
