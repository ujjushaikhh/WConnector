class GetFaqDetalModel {
  String? status;
  String? message;
  List<FaqTitleDetails>? faqTitleDetails;

  GetFaqDetalModel({this.status, this.message, this.faqTitleDetails});

  GetFaqDetalModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['faq_title_details'] != null) {
      faqTitleDetails = <FaqTitleDetails>[];
      json['faq_title_details'].forEach((v) {
        faqTitleDetails!.add(FaqTitleDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (faqTitleDetails != null) {
      data['faq_title_details'] =
          faqTitleDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FaqTitleDetails {
  int? id;
  String? title;
  String? message;

  FaqTitleDetails({this.id, this.title, this.message});

  FaqTitleDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['message'] = message;
    return data;
  }
}
