class JobDetailModel {
  String? status;
  String? message;
  Data? data;

  JobDetailModel({this.status, this.message, this.data});

  JobDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? jobName;
  String? companyJobStatus;
  String? startDate;
  String? jobDescription;
  String? salary;
  String? salaryType;
  String? endDate;
  String? endTime;
  List<JobRequirements>? jobRequirements;
  String? companyName;
  bool? favoriteJob;
  String? address;
  String? latitude;
  String? longitude;
  int? totlapplicationCount;
  int? vacancies;
  String? workType;
  int? daysAgoCreate;
  String? userImage;

  Data(
      {this.id,
      this.jobName,
      this.companyJobStatus,
      this.startDate,
      this.jobDescription,
      this.salary,
      this.salaryType,
      this.endDate,
      this.endTime,
      this.jobRequirements,
      this.companyName,
      this.favoriteJob,
      this.address,
      this.latitude,
      this.longitude,
      this.totlapplicationCount,
      this.vacancies,
      this.workType,
      this.daysAgoCreate,
      this.userImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jobName = json['job_name'];
    companyJobStatus = json['company_job_status'];
    startDate = json['start_date'];
    jobDescription = json['job_description'];
    salary = json['salary'];
    salaryType = json['salary_type'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    if (json['job_requirements'] != null) {
      jobRequirements = <JobRequirements>[];
      json['job_requirements'].forEach((v) {
        jobRequirements!.add(JobRequirements.fromJson(v));
      });
    }
    companyName = json['company_name'];
    favoriteJob = json['Favorite_Job'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    totlapplicationCount = json['totlapplicationCount'];
    vacancies = json['vacancies'];
    workType = json['work_type'];
    daysAgoCreate = json['days_ago_create'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['job_name'] = jobName;
    data['company_job_status'] = companyJobStatus;
    data['start_date'] = startDate;
    data['job_description'] = jobDescription;
    data['salary'] = salary;
    data['salary_type'] = salaryType;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    if (jobRequirements != null) {
      data['job_requirements'] =
          jobRequirements!.map((v) => v.toJson()).toList();
    }
    data['company_name'] = companyName;
    data['Favorite_Job'] = favoriteJob;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['totlapplicationCount'] = totlapplicationCount;
    data['vacancies'] = vacancies;
    data['work_type'] = workType;
    data['days_ago_create'] = daysAgoCreate;
    data['user_image'] = userImage;
    return data;
  }
}

class JobRequirements {
  String? jobRequirements;

  JobRequirements({this.jobRequirements});

  JobRequirements.fromJson(Map<String, dynamic> json) {
    jobRequirements = json['job_requirements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_requirements'] = jobRequirements;
    return data;
  }
}
