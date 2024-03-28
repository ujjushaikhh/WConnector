class JobListModel {
  List<Jobs>? jobs;

  JobListModel({this.jobs});

  JobListModel.fromJson(Map<String, dynamic> json) {
    if (json['jobs'] != null) {
      jobs = <Jobs>[];
      json['jobs'].forEach((v) {
        jobs!.add(Jobs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (jobs != null) {
      data['jobs'] = jobs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Jobs {
  int? userId;
  int? jobId;
  int? vacancies;
  String? jobName;
  String? salary;
  String? endDate;
  String? companyJobStatus;
  String? salaryType;
  int? daysAgoCreate;
  int? totlapplicationCount;
  String? workType;

  Jobs(
      {this.userId,
      this.jobId,
      this.vacancies,
      this.jobName,
      this.salary,
      this.endDate,
      this.companyJobStatus,
      this.salaryType,
      this.daysAgoCreate,
      this.totlapplicationCount,
      this.workType});

  Jobs.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    jobId = json['job_id'];
    vacancies = json['vacancies'];
    jobName = json['job_name'];
    salary = json['salary'];
    endDate = json['end_date'];
    companyJobStatus = json['company_job_status'];
    salaryType = json['salary_type'];
    daysAgoCreate = json['days_ago_create'];
    totlapplicationCount = json['totlapplicationCount'];
    workType = json['work_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['job_id'] = jobId;
    data['vacancies'] = vacancies;
    data['job_name'] = jobName;
    data['salary'] = salary;
    data['end_date'] = endDate;
    data['company_job_status'] = companyJobStatus;
    data['salary_type'] = salaryType;
    data['days_ago_create'] = daysAgoCreate;
    data['totlapplicationCount'] = totlapplicationCount;
    data['work_type'] = workType;
    return data;
  }
}
