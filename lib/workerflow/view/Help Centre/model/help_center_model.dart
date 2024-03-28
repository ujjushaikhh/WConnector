class GetFaqTitleModel {
  String? status;
  String? message;
  List<FaqTitles>? faqTitles;

  GetFaqTitleModel({this.status, this.message, this.faqTitles});

  GetFaqTitleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['faq_titles'] != null) {
      faqTitles = <FaqTitles>[];
      json['faq_titles'].forEach((v) {
        faqTitles!.add(FaqTitles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (faqTitles != null) {
      data['faq_titles'] = faqTitles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FaqTitles {
  int? id;
  String? title;

  FaqTitles({this.id, this.title});

  FaqTitles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}
