class JobSeekingModel {
  String? status;
  String? message;
  String? jobSeekinStatus;

  JobSeekingModel({this.status, this.message, this.jobSeekinStatus});

  JobSeekingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    jobSeekinStatus = json['job_seekin_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['job_seekin_status'] = jobSeekinStatus;
    return data;
  }
}
