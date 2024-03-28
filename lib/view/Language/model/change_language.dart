class ChangeLanguageModel {
  String? status;
  String? message;
  Data? data;

  ChangeLanguageModel({this.status, this.message, this.data});

  ChangeLanguageModel.fromJson(Map<String, dynamic> json) {
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
  int? language;

  Data({this.language});

  Data.fromJson(Map<String, dynamic> json) {
    language = json['Language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Language'] = language;
    return data;
  }
}
