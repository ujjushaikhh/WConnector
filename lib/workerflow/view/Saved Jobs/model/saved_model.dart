class SavedJobModel {
  String? status;
  String? message;
  List<Data>? data;

  SavedJobModel({this.status, this.message, this.data});

  SavedJobModel.fromJson(Map<String, dynamic> json) {
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
  int? vacancies;
  String? jobName;
  String? companyName;
  String? companyAddress;
  String? latitude;
  String? longitude;
  String? companyJobStatus;
  String? salary;
  int? daysAgoCreate;
  String? salaryType;
  String? workType;
  String? companyImage;

  Data(
      {this.userId,
      this.jobId,
      this.favoriteJob,
      this.vacancies,
      this.jobName,
      this.companyName,
      this.companyAddress,
      this.latitude,
      this.longitude,
      this.companyJobStatus,
      this.salary,
      this.daysAgoCreate,
      this.salaryType,
      this.workType,
      this.companyImage});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    jobId = json['job_id'];
    favoriteJob = json['Favorite_Job'];
    vacancies = json['vacancies'];
    jobName = json['job_name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    companyJobStatus = json['company_job_status'];
    salary = json['salary'];
    daysAgoCreate = json['days_ago_create'];
    salaryType = json['salary_type'];
    workType = json['work_type'];
    companyImage = json['company_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['job_id'] = jobId;
    data['Favorite_Job'] = favoriteJob;
    data['vacancies'] = vacancies;
    data['job_name'] = jobName;
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['company_job_status'] = companyJobStatus;
    data['salary'] = salary;
    data['days_ago_create'] = daysAgoCreate;
    data['salary_type'] = salaryType;
    data['work_type'] = workType;
    data['company_image'] = companyImage;
    return data;
  }
}
