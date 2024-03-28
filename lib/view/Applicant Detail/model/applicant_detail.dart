class ViewApplicantDetailModel {
  String? status;
  String? message;
  List<Data>? data;

  ViewApplicantDetailModel({this.status, this.message, this.data});

  ViewApplicantDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? userName;
  String? userEmail;
  String? address;
  String? latitude;
  String? longitude;
  String? phone;
  String? userImage;
  String? expectedSalary;
  String? currentSalary;
  String? aboutOfWork;
  String? university;
  int? isStudent;
  String? tRC;
  String? passport;
  String? workExperience;
  List<String>? workExpertise;
  List<WorkHistory>? workHistory;
  List<JobRoles>? jobRoles;
  List<TypeOfWork>? typeOfWork;
  int? userJobSeekingStatus;
  int? statusofhired;

  Data(
      {this.userId,
      this.userName,
      this.userEmail,
      this.statusofhired,
      this.address,
      this.latitude,
      this.longitude,
      this.phone,
      this.userImage,
      this.expectedSalary,
      this.currentSalary,
      this.aboutOfWork,
      this.university,
      this.isStudent,
      this.tRC,
      this.passport,
      this.workExperience,
      this.workExpertise,
      this.workHistory,
      this.jobRoles,
      this.typeOfWork,
      this.userJobSeekingStatus});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    phone = json['phone'];
    statusofhired = json['status_of_hired'];

    userImage = json['user_image'];
    expectedSalary = json['expected_salary'];
    currentSalary = json['current_salary'];
    aboutOfWork = json['about_of_work'];
    university = json['university'];
    isStudent = json['is_student'];
    tRC = json['TRC'];
    passport = json['Passport'];
    workExperience = json['work_experience'];
    workExpertise = json['work_expertise'].cast<String>();
    if (json['work_history'] != null) {
      workHistory = <WorkHistory>[];
      json['work_history'].forEach((v) {
        workHistory!.add(WorkHistory.fromJson(v));
      });
    }
    if (json['job_roles'] != null) {
      jobRoles = <JobRoles>[];
      json['job_roles'].forEach((v) {
        jobRoles!.add(JobRoles.fromJson(v));
      });
    }
    if (json['type_of_work'] != null) {
      typeOfWork = <TypeOfWork>[];
      json['type_of_work'].forEach((v) {
        typeOfWork!.add(TypeOfWork.fromJson(v));
      });
    }
    userJobSeekingStatus = json['user_job_seeking_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['phone'] = phone;
    data['status_of_hired'] = statusofhired;
    data['user_image'] = userImage;
    data['expected_salary'] = expectedSalary;
    data['current_salary'] = currentSalary;
    data['about_of_work'] = aboutOfWork;
    data['university'] = university;
    data['is_student'] = isStudent;
    data['TRC'] = tRC;
    data['Passport'] = passport;
    data['work_experience'] = workExperience;
    data['work_expertise'] = workExpertise;
    if (workHistory != null) {
      data['work_history'] = workHistory!.map((v) => v.toJson()).toList();
    }
    if (jobRoles != null) {
      data['job_roles'] = jobRoles!.map((v) => v.toJson()).toList();
    }
    if (typeOfWork != null) {
      data['type_of_work'] = typeOfWork!.map((v) => v.toJson()).toList();
    }
    data['user_job_seeking_status'] = userJobSeekingStatus;
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
