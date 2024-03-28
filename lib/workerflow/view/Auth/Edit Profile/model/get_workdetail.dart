class GetExtraWorkDetailModel {
  String? status;
  String? message;
  ExtraWorkDetailData? data;

  GetExtraWorkDetailModel({this.status, this.message, this.data});

  GetExtraWorkDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? ExtraWorkDetailData.fromJson(json['data'])
        : null;
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

class ExtraWorkDetailData {
  List<TypeOfWork>? typeOfWork;
  List<JobRoles>? jobRoles;
  String? expectedSalary;
  String? currentSalary;
  String? aboutOfWork;
  String? workExperience;
  List<WorkHistory>? workHistory;

  ExtraWorkDetailData(
      {this.typeOfWork,
      this.jobRoles,
      this.expectedSalary,
      this.currentSalary,
      this.aboutOfWork,
      this.workExperience,
      this.workHistory});

  ExtraWorkDetailData.fromJson(Map<String, dynamic> json) {
    if (json['type_of_work'] != null) {
      typeOfWork = <TypeOfWork>[];
      json['type_of_work'].forEach((v) {
        typeOfWork!.add(TypeOfWork.fromJson(v));
      });
    }
    if (json['job_roles'] != null) {
      jobRoles = <JobRoles>[];
      json['job_roles'].forEach((v) {
        jobRoles!.add(JobRoles.fromJson(v));
      });
    }
    expectedSalary = json['expected_salary'];
    currentSalary = json['current_salary'];
    aboutOfWork = json['about_of_work'];
    workExperience = json['work_experience'];
    if (json['work_history'] != null) {
      workHistory = <WorkHistory>[];
      json['work_history'].forEach((v) {
        workHistory!.add(WorkHistory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (typeOfWork != null) {
      data['type_of_work'] = typeOfWork!.map((v) => v.toJson()).toList();
    }
    if (jobRoles != null) {
      data['job_roles'] = jobRoles!.map((v) => v.toJson()).toList();
    }
    data['expected_salary'] = expectedSalary;
    data['current_salary'] = currentSalary;
    data['about_of_work'] = aboutOfWork;
    data['work_experience'] = workExperience;
    if (workHistory != null) {
      data['work_history'] = workHistory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TypeOfWork {
  int? id;
  String? type;

  TypeOfWork({this.id, this.type});

  TypeOfWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class JobRoles {
  int? id;
  String? roleEnglish;

  JobRoles({this.id, this.roleEnglish});

  JobRoles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleEnglish = json['role_English'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['role_English'] = roleEnglish;
    return data;
  }
}

class WorkHistory {
  String? toDate;
  String? fromDate;
  String? companyName;

  WorkHistory({this.toDate, this.fromDate, this.companyName});

  WorkHistory.fromJson(Map<String, dynamic> json) {
    toDate = json['to_date'];
    fromDate = json['from_date'];
    companyName = json['Company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['to_date'] = toDate;
    data['from_date'] = fromDate;
    data['Company_name'] = companyName;
    return data;
  }
}
