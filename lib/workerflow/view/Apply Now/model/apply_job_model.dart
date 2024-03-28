class ApplyJobModel {
  String? status;
  String? message;
  ApplyData? data;

  ApplyJobModel({this.status, this.message, this.data});

  ApplyJobModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? ApplyData.fromJson(json['data']) : null;
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

class ApplyData {
  int? userId;
  String? companyId;
  String? jobId;
  String? name;
  String? email;
  String? expectedSalary;
  String? salaryType;
  String? aboutMe;
  String? cv;
  String? updatedAt;
  String? createdAt;
  int? id;

  ApplyData(
      {this.userId,
      this.companyId,
      this.jobId,
      this.name,
      this.email,
      this.expectedSalary,
      this.salaryType,
      this.aboutMe,
      this.cv,
      this.updatedAt,
      this.createdAt,
      this.id});

  ApplyData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    companyId = json['company_id'];
    jobId = json['job_id'];
    name = json['name'];
    email = json['email'];
    expectedSalary = json['expected_salary'];
    salaryType = json['salary_type'];
    aboutMe = json['about_me'];
    cv = json['cv'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['job_id'] = jobId;
    data['name'] = name;
    data['email'] = email;
    data['expected_salary'] = expectedSalary;
    data['salary_type'] = salaryType;
    data['about_me'] = aboutMe;
    data['cv'] = cv;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
