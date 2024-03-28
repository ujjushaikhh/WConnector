class AcceptApplicantModel {
  String? status;
  String? message;
  String? jobStatus;
  String? hiredStatus;

  AcceptApplicantModel(
      {this.status, this.message, this.jobStatus, this.hiredStatus});

  AcceptApplicantModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    jobStatus = json['job_status'];
    hiredStatus = json['hired_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['job_status'] = jobStatus;
    data['hired_status'] = hiredStatus;
    return data;
  }
}
