class GetHome {
  String? status;
  String? message;
  List<RecommendedJobs>? recommendedJobs;

  GetHome({this.status, this.message, this.recommendedJobs});

  GetHome.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['recommendedJobs'] != null) {
      recommendedJobs = <RecommendedJobs>[];
      json['recommendedJobs'].forEach((v) {
        recommendedJobs!.add(RecommendedJobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (recommendedJobs != null) {
      data['recommendedJobs'] =
          recommendedJobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecommendedJobs {
  int? jobId;
  int? userid;
  String? vacancies;
  String? workType;
  String? jobName;
  String? salary;
  String? endDate;
  String? companyJobStatus;
  String? salaryType;
  int? daysAgoCreate;
  int? companyId;
  String? companyName;
  String? companyAddress;
  String? companyLatitude;
  String? companyLongitude;
  bool? favoriteJob;
  String? companyImage;

  RecommendedJobs(
      {this.jobId,
      this.vacancies,
      this.workType,
      this.jobName,
      this.salary,
      this.endDate,
      this.companyJobStatus,
      this.salaryType,
      this.daysAgoCreate,
      this.userid,
      this.companyId,
      this.companyName,
      this.companyAddress,
      this.companyLatitude,
      this.companyLongitude,
      this.favoriteJob,
      this.companyImage});

  RecommendedJobs.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
    vacancies = json['vacancies'];
    workType = json['work_type'];
    jobName = json['job_name'];
    salary = json['salary'];
    endDate = json['end_date'];
    userid = json['user_id'];
    companyJobStatus = json['company_job_status'];
    salaryType = json['salary_type'];
    daysAgoCreate = json['days_ago_create'];
    companyId = json['company_id'];
    companyName = json['company_name'];
    companyAddress = json['company_address'];
    companyLatitude = json['company_latitude'];
    companyLongitude = json['company_longitude'];
    favoriteJob = json['favorite_Job'];
    companyImage = json['company_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_id'] = jobId;
    data['vacancies'] = vacancies;
    data['work_type'] = workType;
    data['job_name'] = jobName;
    data['salary'] = salary;
    data['end_date'] = endDate;
    data['company_job_status'] = companyJobStatus;
    data['salary_type'] = salaryType;
    data['user_id'] = userid;
    data['days_ago_create'] = daysAgoCreate;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['company_address'] = companyAddress;
    data['company_latitude'] = companyLatitude;
    data['company_longitude'] = companyLongitude;
    data['favorite_Job'] = favoriteJob;
    data['company_image'] = companyImage;
    return data;
  }
}
