class GetPrivacyPolicy {
  String? status;
  String? message;
  Cms? cms;

  GetPrivacyPolicy({this.status, this.message, this.cms});

  GetPrivacyPolicy.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    cms = json['cms'] != null ? Cms.fromJson(json['cms']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (cms != null) {
      data['cms'] = cms!.toJson();
    }
    return data;
  }
}

class Cms {
  int? id;
  String? cms;

  Cms({this.id, this.cms});

  Cms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cms = json['cms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cms'] = cms;
    return data;
  }
}
