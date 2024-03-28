class ViewApplicantModel {
  String? status;
  List<Jobs>? jobs;

  ViewApplicantModel({this.status, this.jobs});

  ViewApplicantModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['jobs'] != null) {
      jobs = <Jobs>[];
      json['jobs'].forEach((v) {
        jobs!.add(Jobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (jobs != null) {
      data['jobs'] = jobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Jobs {
  int? jobId;
  int? vacancies;
  int? statusOfHired;
  int? daysAgoCreate;
  int? userId;
  int? jobseekingstatus;
  String? workType;
  String? jobName;
  String? salary;
  String? endDate;
  String? companyJobStatus;
  String? salaryType;
  String? userName;
  String? address;
  String? latitude;
  String? longitude;
  String? userImage;

  Jobs(
      {this.jobId,
      this.vacancies,
      this.workType,
      this.jobseekingstatus = 2,
      this.jobName,
      this.salary,
      this.endDate,
      this.companyJobStatus,
      this.salaryType,
      this.daysAgoCreate,
      this.userId,
      this.userName,
      this.address,
      this.latitude,
      this.longitude,
      this.statusOfHired,
      this.userImage});

  Jobs.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
    vacancies = json['vacancies'];
    workType = json['work_type'];
    jobName = json['job_name'];
    salary = json['salary'];
    endDate = json['end_date'];
    companyJobStatus = json['company_job_status'];
    salaryType = json['salary_type'];
    daysAgoCreate = json['days_ago_create'];
    userId = json['user_id'];
    userName = json['user_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    statusOfHired = json['status_of_hired'];
    userImage = json['user_image'];
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
    data['days_ago_create'] = daysAgoCreate;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['status_of_hired'] = statusOfHired;
    data['user_image'] = userImage;
    return data;
  }
}
