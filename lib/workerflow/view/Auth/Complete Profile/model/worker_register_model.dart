class WorkerRegisterModel {
  String? status;
  String? message;
  String? token;
  int? pageno;

  WorkerRegisterModel({this.status, this.message, this.token, this.pageno});

  WorkerRegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    pageno = json['pageno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    data['pageno'] = pageno;
    return data;
  }
}
