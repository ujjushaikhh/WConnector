class SearchJobModel {
  String? status;
  String? message;
  int? totalJobs;
  List<SearchData>? data;

  SearchJobModel({this.status, this.message, this.totalJobs, this.data});

  SearchJobModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalJobs = json['total_jobs'];
    if (json['data'] != null) {
      data = <SearchData>[];
      json['data'].forEach((v) {
        data!.add(SearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_jobs'] = totalJobs;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchData {
  bool? favoriteJob;
  int? jobId;
  int? vacancies;
  String? jobName;
  String? companyName;
  String? companyAddress;
  String? latitude;
  String? longitude;
  String? companyJobStatus;
  String? salary;
  int? daysAgoCreate;
  String? workType;
  String? salaryType;
  String? companyImage;

  SearchData(
      {this.favoriteJob,
      this.jobId,
      this.vacancies,
      this.jobName,
      this.companyName,
      this.companyAddress,
      this.latitude,
      this.longitude,
      this.companyJobStatus,
      this.salary,
      this.daysAgoCreate,
      this.workType,
      this.salaryType,
      this.companyImage});

  SearchData.fromJson(Map<String, dynamic> json) {
    favoriteJob = json['Favorite_Job'];
    jobId = json['job_id'];
    vacancies = json['vacancies'];
    jobName = json['job_name'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    companyJobStatus = json['company_job_status'];
    salary = json['salary'];
    daysAgoCreate = json['days_ago_create'];
    workType = json['work_type'];
    salaryType = json['salary_type'];
    companyImage = json['company_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Favorite_Job'] = favoriteJob;
    data['job_id'] = jobId;
    data['vacancies'] = vacancies;
    data['job_name'] = jobName;
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['company_job_status'] = companyJobStatus;
    data['salary'] = salary;
    data['days_ago_create'] = daysAgoCreate;
    data['work_type'] = workType;
    data['salary_type'] = salaryType;
    data['company_image'] = companyImage;
    return data;
  }
}
