class PostSaveJobModel {
  String? status;
  String? message;
  int? isLike;

  PostSaveJobModel({this.status, this.message, this.isLike});

  PostSaveJobModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    isLike = json['is_like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['is_like'] = isLike;
    return data;
  }
}
