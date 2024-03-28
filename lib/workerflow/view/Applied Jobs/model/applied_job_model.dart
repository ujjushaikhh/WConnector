class AppliedJobModel {
  String? status;
  String? message;
  List<Data>? data;

  AppliedJobModel({this.status, this.message, this.data});

  AppliedJobModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  int? jobId;
  bool? favoriteJob;
  String? userJobStatus;
  int? vacancies;
  String? jobName;
  String? companyName;
  String? companyAddress;
  String? latitude;
  String? longitude;
  String? companyJobStatus;
  String? salary;
  String? salaryType;
  String? workType;
  String? companyImage;
  int? daysAgoCreate;

  Data(
      {this.userId,
      this.jobId,
      this.favoriteJob,
      this.userJobStatus,
      this.vacancies,
      this.jobName,
      this.companyName,
      this.companyAddress,
      this.latitude,
      this.longitude,
      this.companyJobStatus,
      this.salary,
      this.salaryType,
      this.workType,
      this.companyImage,
      this.daysAgoCreate});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    jobId = json['job_id'];
    favoriteJob = json['Favorite_Job'];
    userJobStatus = json['user_job_status'];
    vacancies = json['vacancies'];
    jobName = json['job_name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    companyJobStatus = json['company_job_status'];
    salary = json['salary'];
    salaryType = json['salary_type'];
    workType = json['work_type'];
    companyImage = json['company_image'];
    daysAgoCreate = json['days_ago_create'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['job_id'] = jobId;
    data['Favorite_Job'] = favoriteJob;
    data['user_job_status'] = userJobStatus;
    data['vacancies'] = vacancies;
    data['job_name'] = jobName;
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['company_job_status'] = companyJobStatus;
    data['salary'] = salary;
    data['salary_type'] = salaryType;
    data['work_type'] = workType;
    data['company_image'] = companyImage;
    data['days_ago_create'] = daysAgoCreate;
    return data;
  }
}
