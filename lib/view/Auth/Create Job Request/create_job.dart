import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';
import 'package:wconnectorconnectorflow/constants/font_constants.dart';
import 'package:wconnectorconnectorflow/constants/image_constants.dart';
import 'package:wconnectorconnectorflow/utils/button.dart';
import 'package:wconnectorconnectorflow/utils/textwidget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/create_job.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/get_job_data_mode.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/job_frequency.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/job_perhour_model.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/job_role.dart';
import 'package:wconnectorconnectorflow/view/Bottom%20Tab/primarybottomtab.dart';
import '../../../constants/api_constants.dart';
import '../../../utils/dailog.dart';
import '../../../utils/internetconnection.dart';
import '../../../utils/progressdialog.dart';
import '../../../utils/sharedprefs.dart';
import '../../../utils/textfeild.dart';

class Requirements {
  TextEditingController? requirementtext;
  Requirements({this.requirementtext});
}

class MyCreateJob extends StatefulWidget {
  const MyCreateJob({
    super.key,
  });

  @override
  State<MyCreateJob> createState() => _MyCreateJobState();
}

class _MyCreateJobState extends State<MyCreateJob> {
  @override
  void initState() {
    super.initState();
    getjobfrequencyapi();
    getjobperhourapi();
    getjobroleapi();

    requirements.clear();
    requirements.add(Requirements(requirementtext: TextEditingController()));
  }

  int? notifyCount = 2;

  // final _jobrequirementscontroller = TextEditingController();
  final _jobtitlecontroller = TextEditingController();
  final _jobdescriptioncontroller = TextEditingController();
  final _expectedsalarycontroller = TextEditingController();
  final _timecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  List<String> vaccancy = ['10', '20', '30'];

  List<PerHours> time = [];
  List<Requirements> requirements = [];
  List<Data> frequency = [];

  DateTime selectedDate = DateTime.now();
  DateTime selectedCoverUp = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 0, minute: 0);

  String getStartDate = '';
  String getDate = '';

  String? selectVaccancy;
  PerHours? selectTime;
  bool isChecked = false;
  int? listid;

  List<JobRoles> getjobrole = [];
  List selectedjobrole = [];

  List<String>? selectedJobRoleId = [];
  List<String> selectedrole = [];
  List<String> selectedroleid = [];
  List<RoleData> items = [];
  // Future<void> getjobdataapi() async {
  //   if (await checkUserConnection()) {
  //     if (!mounted) return;
  //     // ProgressDialogUtils.showProgressDialog(context);
  //     try {
  //       var apiurl = '$getjobdataurl/${widget.jobid}';
  //       debugPrint(apiurl);
  //       var headers = {
  //         'Authorization': 'Bearer ${getString('commpanytoken')}',
  //         'Content-Type': 'application/json',
  //       };

  //       debugPrint(getString('commpanytoken'));

  //       var request = http.Request('GET', Uri.parse(apiurl));
  //       request.headers.addAll(headers);
  //       http.StreamedResponse response = await request.send();
  //       final responsed = await http.Response.fromStream(response);
  //       var jsonResponse = jsonDecode(responsed.body);
  //       var jobData = GetJobData.fromJson(jsonResponse);
  //       debugPrint(responsed.body);
  //       if (response.statusCode == 200) {
  //         debugPrint(responsed.body);
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (jobData.status == '1') {
  //           setState(() {
  //             _jobtitlecontroller.text = jobData.data!.jobTitle!;
  //             _jobdescriptioncontroller.text = jobData.data!.jobDescription!;
  //             _expectedsalarycontroller.text = jobData.data!.salary!;

  //             getjobrole = jobData.data!.jobRoles!;
  //             selectedjobrole = getjobrole.map((e) => e.roleEnglish).toList();

  //             List<Requirements> getrequirements = [];
  //             for (var data in jobData.data!.jobRequirements!) {
  //               TextEditingController requirements =
  //                   TextEditingController(text: data.jobRequirement.toString());

  //               getrequirements.add(Requirements(
  //                 requirementtext: requirements,
  //               ));
  //             }
  //             requirements = getrequirements;
  //             selectVaccancy = jobData.data!.vacancies!;
  //             getStartDate = jobData.data!.startDate!;
  //             selectedDate = DateTime.parse(getStartDate);
  //             getDate = DateFormat('dd MM yyyy').format(selectedDate);
  //           });
  //           debugPrint('is it success');
  //         } else {
  //           debugPrint('failed to load');
  //           ProgressDialogUtils.dismissProgressDialog();
  //         }
  //       } else if (response.statusCode == 401) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         connectorAlertDialogue(
  //           context: context,
  //           desc: 'UnAuthorize data',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 404) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         connectorAlertDialogue(
  //           context: context,
  //           desc: 'Bad request',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 400) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         connectorAlertDialogue(
  //           context: context,
  //           desc: 'Bad request 400',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       } else if (response.statusCode == 500) {
  //         ProgressDialogUtils.dismissProgressDialog();
  //         if (!mounted) return;
  //         connectorAlertDialogue(
  //           context: context,
  //           desc: 'Imternal server error',
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //         ).show();
  //       }
  //     } catch (e) {
  //       ProgressDialogUtils.dismissProgressDialog();
  //       debugPrint("$e");
  //       if (!mounted) return;
  //       connectorAlertDialogue(
  //         context: context,
  //         desc: '$e',
  //         onPressed: () {
  //           Navigator.of(context, rootNavigator: true).pop();
  //         },
  //       ).show();
  //     }
  //   } else {
  //     if (!mounted) return;
  //     connectorAlertDialogue(
  //       context: context,
  //       type: AlertType.info,
  //       desc: 'Check Internet Connection',
  //       onPressed: () {
  //         Navigator.of(context, rootNavigator: true).pop();
  //       },
  //     ).show();
  //   }
  // }

  Future<void> getjobperhourapi() async {
    if (await checkUserConnection()) {
      // if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$getsalarytypedropdownurl?id=${getInt('lang_id')}";
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('companytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobFrequencyPerHrs = JobPerHrsModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobFrequencyPerHrs.status == '1') {
            setState(() {
              time = jobFrequencyPerHrs.perhour!;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$e");
        if (!mounted) return;
        connectorAlertDialogue(
          context: context,
          desc: '$e',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ).show();
      }
    } else {
      if (!mounted) return;
      connectorAlertDialogue(
        context: context,
        desc: 'Check Internet Connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Future<void> getjobroleapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$getjobrolesurl?id=${getInt('lang_id')}";
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobFrequencyPerHrs = JobRoleModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobFrequencyPerHrs.status == '1') {
            setState(() {
              items = jobFrequencyPerHrs.data!;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$e");
        if (!mounted) return;
        connectorAlertDialogue(
          context: context,
          desc: '$e',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ).show();
      }
    } else {
      if (!mounted) return;
      connectorAlertDialogue(
        context: context,
        desc: 'Check Internet Connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Future<void> getjobfrequencyapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$getworktypedropdownurl?id=${getInt('lang_id')}";
        debugPrint(apiurl);
        var headers = {
          'Authorization': 'Bearer ${getString('token')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('token'));

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobFrequencyPerHrs = JobFrequencyModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobFrequencyPerHrs.status == '1') {
            setState(() {
              frequency = jobFrequencyPerHrs.data!;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobFrequencyPerHrs.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        debugPrint("$e");
        if (!mounted) return;
        connectorAlertDialogue(
          context: context,
          desc: '$e',
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ).show();
      }
    } else {
      if (!mounted) return;
      connectorAlertDialogue(
        context: context,
        desc: 'Check Internet Connection',
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
      ).show();
    }
  }

  Future<void> createjobapi() async {
    // final token = await NotificationSet().requestUserPermission();
    // debugPrint("Fcm Token $token");
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };
        var request = http.Request('POST', Uri.parse(createjoburl));

        List temprequirements = [];
        for (var req = 0; req < requirements.length; req++) {
          temprequirements.add({
            'job_requirements':
                requirements[req].requirementtext!.text.toString()
          });
        }
        // if (selectedCoverUp == DateTime.now()) {
        //   selectedCoverUp = '';
        // }

        if (isChecked == false) {
          request.body = json.encode({
            "job_title": _jobtitlecontroller.text.toString(),
            "vacancies": selectVaccancy.toString(),
            "work_type": listid.toString(),
            'job_roles': selectedroleid.map((e) => e).toList(),
            "start_date": selectedDate.toString(),
            "job_description": _jobdescriptioncontroller.text.toString(),
            "job_requirements": temprequirements,
            "salary": _expectedsalarycontroller.text.toString(),
            "salary_type": selectTime!.id.toString(),
            "end_date": '',
            "end_time": ''
          });
        } else {
          request.body = json.encode({
            "job_title": _jobtitlecontroller.text.toString(),
            "vacancies": selectVaccancy.toString(),
            "work_type": listid.toString(),
            'job_roles': selectedroleid.map((e) => e).toList(),
            "start_date": selectedDate.toString(),
            "job_description": _jobdescriptioncontroller.text.toString(),
            "job_requirements": temprequirements,
            "salary": _expectedsalarycontroller.text.toString(),
            "salary_type": selectTime!.id.toString(),
            "end_date": selectedCoverUp.toString(),
            "end_time": _selectedTime.toString()
          });
        }

        debugPrint('url :- ${createjoburl.toString()}');
        debugPrint('token :- ${getString('commpanytoken')}');
        debugPrint('Body :- ${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var createjobModel = CreateJobModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (createjobModel.status == '1') {
            if (!mounted) return;
            connectorAlertDialogue(
                type: AlertType.success,
                context: context,
                desc: '${createjobModel.message}',
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyPrimaryBottomTab()));
                    // _jobtitlecontroller.clear();
                    // listid = 0;
                    // selectVaccancy = '';
                    // selectedDate = DateTime.now();
                    // _jobdescriptioncontroller.clear();
                    // temprequirements.clear();
                    // _expectedsalarycontroller.clear();
                    // selectTime!.id = 0;
                    // selectedCoverUp = DateTime.now();
                    // selectTime!.time = "";
                  });
                }).show();
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            connectorAlertDialogue(
                context: context,
                desc: '${createjobModel.message}',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${createjobModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${createjobModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${createjobModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
              context: context,
              desc: "${createjobModel.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        }
      } catch (e) {
        ProgressDialogUtils.dismissProgressDialog();
        if (!mounted) return;
        debugPrint('$e');
        connectorAlertDialogue(
            context: context,
            desc: 'Something went wrong',
            onPressed: () {
              Navigator.pop(context);
            }).show();
      }
    } else {
      if (!mounted) return;
      connectorAlertDialogue(
          context: context,
          type: AlertType.info,
          desc: 'Please check your internet connection',
          onPressed: () {
            Navigator.pop(context);
          }).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      backgroundColor: whitecolor,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 34.0),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTextWidget(
                  title: AppLocalizations.of(context)!.createjobrequest,
                  textFontSize: fontSize25,
                  textFontWeight: fontWeightMedium,
                  textColor: darkblack),
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 11.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.jobtitle,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _getFullname(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.howmanyvacancies,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getvaccancy(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.selectjobrole,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),

                    getMultiplejobdropdown(),
                    // getMultipleJobRole(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.startingdate,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    _dateform(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.jobdescription,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getJobDescription(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.jobfrequency,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getFrequency(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          getTextWidget(
                              title: AppLocalizations.of(context)!.requirements,
                              textFontSize: fontSize14,
                              textFontWeight: fontWeightMedium,
                              textColor: darkblack),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              setState(() {
                                requirements.add(Requirements(
                                    requirementtext: TextEditingController()));
                              });
                            },
                            child: Image.asset(
                              icAddicon,
                              height: 20,
                              width: 20,
                              color: greycolor,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                    getRequirements(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.salary,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getSalary(),
                    getCoverupcheckbox(),
                    isChecked == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: getTextWidget(
                                    title:
                                        AppLocalizations.of(context)!.coverup,
                                    textFontSize: fontSize14,
                                    textFontWeight: fontWeightMedium,
                                    textColor: darkblack),
                              ),
                              getCoverup(),
                            ],
                          )
                        : Container(),
                    getButton()
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  // getroleofworkEdit() {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 15.0),
  //     child: Column(
  //       children: [
  //         Container(
  //           width: screenSize!.width,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(6.0),
  //               border: Border.all(width: 1, color: boxbordercolor)),
  //           child: Column(
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(
  //                     left: 20.0, right: 20, top: 11.0, bottom: 12.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
  //                       child: getTextWidget(
  //                           title: AppLocalizations.of(context)!.selectjobrole,
  //                           textFontSize: fontSize15,
  //                           textFontWeight: fontWeightSemiBold,
  //                           textColor: darkblack),
  //                     ),
  //                     Image.asset(
  //                       icEditProfile,
  //                       height: 24,
  //                       width: 24,
  //                       fit: BoxFit.cover,
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               const Divider(
  //                 color: boxbordercolor,
  //                 thickness: 1.0,
  //                 height: 1.0,
  //               ),
  //               DropdownButtonHideUnderline(
  //                   child: DropdownButton2(
  //                 style: const TextStyle(color: darkblack),
  //                 isExpanded: true,
  //                 hint: Row(
  //                   children: [
  //                     Expanded(
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(left: 8.0),
  //                         child: Text(
  //                           selectedjobrole.isEmpty
  //                               ? AppLocalizations.of(context)!.select
  //                               : selectedjobrole.map((e) => e).toString(),
  //                           // selectedjobtype.isEmpty
  //                           // ?
  //                           // : selectedjobtype.join(','),
  //                           style: const TextStyle(
  //                             color: darkblack,
  //                             fontSize: fontSize14,
  //                             fontWeight: fontWeightRegular,
  //                             fontFamily: fontfamilybeVietnam,
  //                           ),
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 items: items.map((item) {
  //                   return DropdownMenuItem(
  //                     value: item.roleEnglish,
  //                     enabled: true,
  //                     child: StatefulBuilder(builder: (context, mystate) {
  //                       final isSelected =
  //                           selectedjobrole.contains(item.roleEnglish);
  //                       return InkWell(
  //                         onTap: () {
  //                           isSelected
  //                               ? selectedjobrole.remove(item.roleEnglish)
  //                               : selectedjobrole.add(item.roleEnglish!);

  //                           setState(() {});
  //                           if (isSelected) {
  //                             selectedJobRoleId!.remove(item.id!.toString());
  //                           } else {
  //                             selectedJobRoleId!.add(item.id!.toString());
  //                           }

  //                           mystate(() {});
  //                           debugPrint('The list of $selectedjobrole');
  //                           debugPrint('The Ids list $selectedJobRoleId');
  //                         },
  //                         child: Container(
  //                           height: double.infinity,
  //                           padding:
  //                               const EdgeInsets.symmetric(horizontal: 10.0),
  //                           child: Row(
  //                             children: [
  //                               if (isSelected)
  //                                 const Icon(Icons.check_box_outlined)
  //                               else
  //                                 const Icon(Icons.check_box_outline_blank),
  //                               const SizedBox(width: 16),
  //                               Expanded(
  //                                 child: Text(
  //                                   item.roleEnglish!.toString(),
  //                                   style: const TextStyle(
  //                                     fontSize: fontSize14,
  //                                     fontFamily: fontfamilybeVietnam,
  //                                     fontWeight: fontWeightRegular,
  //                                     color: blackcolor,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       );
  //                     }),
  //                   );
  //                 }).toList(),
  //                 value: selectedjobrole.isEmpty ? null : selectedjobrole.last,
  //                 onChanged: (value) {
  //                   // setState(() {
  //                   //   seletcedjobtype = value;
  //                   // });
  //                 },
  //                 selectedItemBuilder: (context) {
  //                   return items.map(
  //                     (item) {
  //                       return Container(
  //                           alignment: Alignment.centerLeft,
  //                           child: getTextWidget(
  //                               title: '${AppLocalizations.of(context)!.selecteditem} ${selectedjobrole.length}',
  //                               textFontSize: fontSize14,
  //                               textFontWeight: fontWeightRegular,
  //                               textColor: darkblack));
  //                     },
  //                   ).toList();
  //                 },
  //                 buttonStyleData: ButtonStyleData(
  //                   height: 45,
  //                   width: MediaQuery.of(context).size.width,
  //                   padding: const EdgeInsets.only(left: 14, right: 14),
  //                   // decoration: BoxDecoration(
  //                   //   borderRadius: BorderRadius.circular(43.0),
  //                   //   border: Border.all(
  //                   //     color: bordercolor,
  //                   //   ),
  //                   //   color: whitecolor,
  //                   // ),
  //                 ),
  //                 iconStyleData: const IconStyleData(
  //                   icon: Icon(
  //                     Icons.keyboard_arrow_down,
  //                     size: 24,
  //                     color: darkblack,
  //                   ),
  //                   iconSize: 14,
  //                   iconEnabledColor: Colors.white,
  //                   iconDisabledColor: Colors.white,
  //                 ),
  //                 dropdownStyleData: DropdownStyleData(
  //                   maxHeight: 200,
  //                   width: MediaQuery.of(context).size.width * 0.9,
  //                   padding: null,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(14),
  //                       color: Colors.white),
  //                   scrollbarTheme: ScrollbarThemeData(
  //                     radius: const Radius.circular(40),
  //                     thickness: MaterialStateProperty.all<double>(6),
  //                     thumbVisibility: MaterialStateProperty.all<bool>(true),
  //                   ),
  //                 ),
  //                 menuItemStyleData: const MenuItemStyleData(
  //                   height: 40,
  //                   padding: EdgeInsets.only(left: 14, right: 14),
  //                 ),
  //                 dropdownSearchData: DropdownSearchData(
  //                   searchController: textEditingController,
  //                   searchInnerWidgetHeight: 50,
  //                   searchInnerWidget: Container(
  //                     height: 50,
  //                     padding: const EdgeInsets.only(
  //                       top: 8,
  //                       bottom: 4,
  //                       right: 8,
  //                       left: 8,
  //                     ),
  //                     child: TextFormField(
  //                       expands: true,
  //                       maxLines: null,
  //                       controller: textEditingController,
  //                       decoration: InputDecoration(
  //                         isDense: true,
  //                         contentPadding: const EdgeInsets.symmetric(
  //                           horizontal: 10,
  //                           vertical: 8,
  //                         ),
  //                         hintText: AppLocalizations.of(context)!.searctext,
  //                         hintStyle: const TextStyle(fontSize: 12),
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   searchMatchFn: (item, searchValue) {
  //                     return item.value.toString().contains(searchValue);
  //                   },
  //                 ),
  //                 onMenuStateChange: (isOpen) {
  //                   if (!isOpen) {
  //                     textEditingController.clear();
  //                   }
  //                 },
  //               )),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  getMultiplejobdropdown() => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: getTextWidget(
                title: selectedrole.isEmpty
                    ? AppLocalizations.of(context)!.select
                    : '${AppLocalizations.of(context)!.selecteditem} ${selectedrole.length}',
                textFontSize: fontSize14,
                textFontWeight: fontWeightRegular,
                textColor: darkblack),
            items: items
                .map((item) => DropdownMenuItem(
                      value: item.roleEnglish,
                      child: StatefulBuilder(builder: (context, myState) {
                        final isSelected =
                            selectedrole.contains(item.roleEnglish);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? selectedrole.remove(item.roleEnglish)
                                : selectedrole.add(item.roleEnglish!);

                            setState(() {});
                            if (isSelected) {
                              selectedroleid.remove(item.id.toString());
                            } else {
                              selectedroleid.add(item.id.toString());
                            }

                            myState(() {});
                            debugPrint('The list :- $selectedrole');
                            debugPrint('The ids of list :- $selectedroleid');
                          },
                          child: Container(
                            height: double.infinity,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                if (isSelected)
                                  const Icon(Icons.check_box_outlined)
                                else
                                  const Icon(Icons.check_box_outline_blank),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    // item.type!.toString(),
                                    item.roleEnglish!.toString(),
                                    style: const TextStyle(
                                      fontSize: fontSize14,
                                      fontFamily: fontfamilybeVietnam,
                                      fontWeight: fontWeightRegular,
                                      color: blackcolor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ))
                .toList(),
            value: selectedrole.isEmpty ? null : selectedrole.last,
            onChanged: (value) {
              // setState(() {
              //   selectedValue = value;
              // });
            },
            selectedItemBuilder: (context) {
              return items.map(
                (item) {
                  return Container(
                      alignment: Alignment.centerLeft,
                      child: getTextWidget(
                          title:
                              '${AppLocalizations.of(context)!.selecteditem} ${selectedrole.length}',
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightRegular,
                          textColor: darkblack));
                },
              ).toList();
            },
            buttonStyleData: ButtonStyleData(
              height: 45,
              width: screenSize!.width,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(43.0),
                border: Border.all(
                  color: bordercolor,
                ),
                color: whitecolor,
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              width: MediaQuery.of(context).size.width * 0.9,
              padding: null,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14), color: Colors.white),
              scrollbarTheme: ScrollbarThemeData(
                radius: const Radius.circular(40),
                thickness: MaterialStateProperty.all<double>(6),
                thumbVisibility: MaterialStateProperty.all<bool>(true),
              ),
            ),
            menuItemStyleData: const MenuItemStyleData(
              height: 40,
              padding: EdgeInsets.only(left: 14, right: 14),
            ),
            iconStyleData: const IconStyleData(
              icon: Icon(
                Icons.keyboard_arrow_down,
                size: 24,
                color: darkblack,
              ),
              iconSize: 14,
              iconEnabledColor: Colors.white,
              iconDisabledColor: Colors.white,
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: textEditingController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: AppLocalizations.of(context)!.searctext,
                    hintStyle: const TextStyle(fontSize: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      );

  getSalary() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenSize!.width / 1.9,
            child: PrimaryTextFeild(
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.requiredsomething;
                }
                return null;
              },
              hintText: '\$',
              keyboardType: TextInputType.number,
              controller: _expectedsalarycontroller,
            ),
          ),
          getPerHour()
        ],
      ),
    );
  }

  getRequirements() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 9.0,
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requirements.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 9.0),
                child: PrimaryTextFeild(
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.requiredsomething;
                    }
                    return null;
                  },
                  hintText: AppLocalizations.of(context)!.requirements,
                  controller: requirements[index].requirementtext,
                ),
              );
            }),
      ),
    );
  }

  getFrequency() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: frequency.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        listid = frequency[index].id;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 13.0),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                            border: listid == frequency[index].id
                                ? null
                                : Border.all(color: bordercolor, width: 1),
                            color: listid == frequency[index].id
                                ? bluecolor
                                : whitecolor,
                            borderRadius: BorderRadius.circular(43)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 13.0, right: 19.0, left: 20),
                          child: getTextWidget(
                              // textAlign: TextAlign.center,
                              title: frequency[index].type!.toString(),
                              textFontSize: fontSize14,
                              textFontWeight: listid == frequency[index].id
                                  ? fontWeightRegular
                                  : fontWeightLight,
                              textColor: listid == frequency[index].id
                                  ? whitecolor
                                  : darkblack),
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       isTimeJobselected = 1;
                  //     });
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         border: isTimeJobselected == 1
                  //             ? null
                  //             : Border.all(color: bordercolor, width: 1),
                  //         color:
                  //             isTimeJobselected == 1 ? bluecolor : whitecolor,
                  //         borderRadius: BorderRadius.circular(43)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           top: 13.0, right: 19.0, bottom: 14.0, left: 20),
                  //       child: getTextWidget(
                  //           title: frequency[index].type!.toString(),
                  //           textFontSize: fontSize14,
                  //           textFontWeight: isTimeJobselected == 1
                  //               ? fontWeightRegular
                  //               : fontWeightLight,
                  //           textColor: isTimeJobselected == 1
                  //               ? whitecolor
                  //               : darkblack),
                  //     ),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     setState(() {
                  //       isTimeJobselected = 2;
                  //     });
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         border: isTimeJobselected == 2
                  //             ? null
                  //             : Border.all(color: bordercolor, width: 1),
                  //         color:
                  //             isTimeJobselected == 2 ? bluecolor : whitecolor,
                  //         borderRadius: BorderRadius.circular(43)),
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           top: 13.0, right: 19.0, bottom: 14.0, left: 20),
                  //       child: getTextWidget(
                  //           title: 'Seasonal',
                  //           textFontSize: fontSize14,
                  //           textFontWeight: isTimeJobselected == 2
                  //               ? fontWeightRegular
                  //               : fontWeightLight,
                  //           textColor: isTimeJobselected == 2
                  //               ? whitecolor
                  //               : darkblack),
                  //     ),
                  //   ),
                  // )
                ],
              );
            }),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectCoverUpDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedCoverUp,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedCoverUp = picked;
      });
    }
  }

  _dateform() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: SizedBox(
        height: 45,
        child: TextFormField(
          onTap: () {
            _selectDate(context);
          },
          readOnly: true,
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: darkblack),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 16.0),
            hintText: DateFormat('dd MMM yy').format(selectedDate),
            hintStyle: const TextStyle(
              color: hintcolor,
              fontSize: fontSize14,
              fontWeight: fontWeightRegular,
              fontFamily: fontfamilybeVietnam,
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 24.0,
                  color: greycolor,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(
                width: 1.0,
                color: bordercolor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  getJobDescription() {
    return Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.requiredsomething;
            }
            return null;
          },
          controller: _jobdescriptioncontroller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.writehere,
            hintStyle: const TextStyle(
                color: hintcolor,
                fontSize: fontSize14,
                fontFamily: fontfamilybeVietnam,
                fontWeight: fontWeightLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: bordercolor, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(color: bordererror),
            ),
          ),
        )
        // PrimaryTextFeild(
        //   controller: _acccontroller,
        //   hintText: "Write here",
        //   fontSize: fontSize14,
        //   keyboardType: TextInputType.number,
        //   fontWeight: fontWeightLight,
        // ),
        );
  }

  _getFullname() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _jobtitlecontroller,
        hintText: AppLocalizations.of(context)!.jobtitle,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  getPerHour() {
    return SizedBox(
      width: screenSize!.width / 2.7,
      height: 50,
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
        style: const TextStyle(color: darkblack),
        isExpanded: true,
        hint: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  AppLocalizations.of(context)!.select,
                  style: const TextStyle(
                    color: hintcolor,
                    fontSize: fontSize14,
                    fontWeight: fontWeightRegular,
                    fontFamily: fontfamilybeVietnam,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        items: time.map((item) {
          return DropdownMenuItem(
            value: item,
            enabled: true,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.time!.toString(),
                      style: const TextStyle(
                        fontSize: fontSize14,
                        fontFamily: fontfamilybeVietnam,
                        fontWeight: fontWeightRegular,
                        color: blackcolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        value: selectTime,
        onChanged: (value) {
          setState(() {
            selectTime = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 45,
          width: MediaQuery.of(context).size.width / 2.7,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43.0),
            border: Border.all(
              color: bordercolor,
            ),
            color: whitecolor,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: darkblack,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: MediaQuery.of(context).size.width / 2.7,
          padding: null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14), color: Colors.white),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      )),
    );
  }

  getCoverupcheckbox() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
                // fillColor:
                //     const MaterialStatePropertyAll<Color>(Color(0xffEAB646)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                side: const BorderSide(color: bordercolor),
                value: isChecked,
                activeColor: bluecolor,
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: getTextWidget(
                title: AppLocalizations.of(context)!.requestacoverup,
                textColor: darkblack,
                textFontSize: fontSize14,
                textFontWeight: fontWeightRegular),
          ),
        ],
      ),
    );
  }

  getvaccancy() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: DropdownButtonHideUnderline(
          child: DropdownButton2(
        style: const TextStyle(color: darkblack),
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            AppLocalizations.of(context)!.select,
            style: const TextStyle(
              color: hintcolor,
              fontSize: fontSize14,
              fontWeight: fontWeightRegular,
              fontFamily: fontfamilybeVietnam,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        items: vaccancy.map((item) {
          return DropdownMenuItem(
            value: item,
            enabled: true,
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: const TextStyle(
                        fontSize: fontSize14,
                        fontFamily: fontfamilybeVietnam,
                        fontWeight: fontWeightRegular,
                        color: blackcolor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        value: selectVaccancy,
        onChanged: (value) {
          setState(() {
            selectVaccancy = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 45,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(43.0),
            border: Border.all(
              color: bordercolor,
            ),
            color: whitecolor,
          ),
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: darkblack,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: null,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14), color: Colors.white),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      )),
    );
  }

  getCoverup() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [getSelectDate(), getSelectTime()],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timecontroller.text = _selectedTime.format(context);
      });
    }
  }

  getSelectTime() {
    return GestureDetector(
      onTap: () {
        _selectTime(context);
      },
      child: SizedBox(
        width: screenSize!.width / 2.3,
        child: PrimaryTextFeild(
          enable: false,
          hintText: AppLocalizations.of(context)!.selecttime,
          controller: _timecontroller,
          suffixIcon: ictime,
          suffixiconcolor: greycolor,
        ),
      ),
    );
  }

  getSelectDate() {
    return SizedBox(
      height: 45,
      width: screenSize!.width / 2.3,
      child: TextFormField(
        onTap: () {
          _selectCoverUpDate(context);
        },
        readOnly: true,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: const TextStyle(color: darkblack),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 16.0),
          hintText: DateFormat('dd MMM yy').format(selectedCoverUp),
          hintStyle: const TextStyle(
            color: hintcolor,
            fontSize: fontSize14,
            fontWeight: fontWeightRegular,
            fontFamily: fontfamilybeVietnam,
          ),
          suffixIcon: IconButton(
            onPressed: () {
              _selectCoverUpDate(context);
            },
            icon: Image.asset(
              icCalendar,
              height: 24,
              width: 24,
              fit: BoxFit.cover,
              color: greycolor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              width: 1.0,
              color: bordercolor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: bordercolor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: bordercolor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: bordercolor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.submit,
          onPressed: () {
            if (_formkey.currentState!.validate() &&
                selectVaccancy != null &&
                listid != null &&
                selectTime != null) {
              createjobapi();
            } else if (selectVaccancy == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredvacancy);
            } else if (listid == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredfrequency);
            } else if (selectTime == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.requiredtime);
            }
          }),
    );
  }

  // getMultipleJobRole() {
  //   final items = _animals
  //       .map(
  //           (animal) => MultiSelectItem<RoleData?>(animal, animal.roleEnglish!))
  //       .toList();
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 20.0),
  //     child: Column(
  //       children: [
  //         Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(6),
  //             color: whitecolor,
  //             border: Border.all(color: bordercolor, width: 1),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               MultiSelectBottomSheetField<RoleData?>(
  //                 buttonIcon: const Icon(Icons.arrow_drop_down),
  //                 initialChildSize: 0.4,
  //                 listType: MultiSelectListType.LIST,
  //                 searchable: true,
  //                 chipDisplay: MultiSelectChipDisplay.none(),
  //                 title: const Text("Animals"),
  //                 items: items,
  //                 onConfirm: (List<RoleData?> values) {
  //                   setState(() {
  //                     _selectedAnimals2 = values;
  //                   });
  //                 },
  //               ),
  //               if (_selectedAnimals2.isEmpty)
  //                 Container(
  //                   padding: const EdgeInsets.all(10),
  //                   alignment: Alignment.centerLeft,
  //                   child: const Text(
  //                     "None selected",
  //                     style: TextStyle(color: Colors.black54),
  //                   ),
  //                 ),
  //               Wrap(
  //                 children: _selectedAnimals2.map((animal) {
  //                   return Padding(
  //                     padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
  //                     child: Container(
  //                       padding: const EdgeInsets.only(left: 16.0, right: 8.0),
  //                       margin: const EdgeInsets.all(2),
  //                       decoration: BoxDecoration(
  //                         color: lightblue,
  //                         borderRadius: BorderRadius.circular(43),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             animal!.roleEnglish!,
  //                             style: const TextStyle(color: Colors.black),
  //                           ),
  //                           IconButton(
  //                             icon: const Icon(Icons.clear),
  //                             onPressed: () {
  //                               setState(() {
  //                                 _selectedAnimals2.remove(animal);
  //                               });
  //                             },
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   );
  //                 }).toList(),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
