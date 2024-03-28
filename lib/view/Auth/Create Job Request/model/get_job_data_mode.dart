class GetJobData {
  String? status;
  JobData? data;

  GetJobData({this.status, this.data});

  GetJobData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? JobData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class JobData {
  int? jobId;
  String? jobTitle;
  String? vacancies;
  int? workType;
  String? startDate;
  String? jobDescription;
  List<JobRequirements>? jobRequirements;
  String? salary;
  String? salaryType;
  String? endDate;
  String? endTime;
  List<JobRoles>? jobRoles;

  JobData(
      {this.jobId,
      this.jobTitle,
      this.vacancies,
      this.workType,
      this.startDate,
      this.jobDescription,
      this.jobRequirements,
      this.salary,
      this.salaryType,
      this.endDate,
      this.endTime,
      this.jobRoles});

  JobData.fromJson(Map<String, dynamic> json) {
    jobId = json['job_id'];
    jobTitle = json['job_title'];
    vacancies = json['vacancies'];
    workType = json['work_type'];
    startDate = json['start_date'];
    jobDescription = json['job_description'];
    if (json['job_requirements'] != null) {
      jobRequirements = <JobRequirements>[];
      json['job_requirements'].forEach((v) {
        jobRequirements!.add(JobRequirements.fromJson(v));
      });
    }
    salary = json['salary'];
    salaryType = json['salary_type'];
    endDate = json['end_date'];
    endTime = json['end_time'];
    if (json['job_roles'] != null) {
      jobRoles = <JobRoles>[];
      json['job_roles'].forEach((v) {
        jobRoles!.add(JobRoles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['job_id'] = jobId;
    data['job_title'] = jobTitle;
    data['vacancies'] = vacancies;
    data['work_type'] = workType;
    data['start_date'] = startDate;
    data['job_description'] = jobDescription;
    if (jobRequirements != null) {
      data['job_requirements'] =
          jobRequirements!.map((v) => v.toJson()).toList();
    }
    data['salary'] = salary;
    data['salary_type'] = salaryType;
    data['end_date'] = endDate;
    data['end_time'] = endTime;
    if (jobRoles != null) {
      data['job_roles'] = jobRoles!.map((v) => v.toJson()).toList();
    }
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

class JobRoles {
  int? id;
  String? rolePolish;

  JobRoles({this.id, this.rolePolish});

  JobRoles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rolePolish = json['role_Polish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_Polish'] = rolePolish;
    return data;
  }
}
