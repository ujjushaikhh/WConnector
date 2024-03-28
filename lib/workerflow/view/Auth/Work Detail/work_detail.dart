import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wconnectorconnectorflow/view/Auth/Create%20Job%20Request/model/job_role.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Work%20Detail/model/work_experiencemodel.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Work%20Detail/model/worker_detail_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/font_constants.dart';
import '../../../../constants/image_constants.dart';
import '../../../../utils/button.dart';
import '../../../../utils/dailog.dart';
import '../../../../utils/internetconnection.dart';
import '../../../../utils/progressdialog.dart';
import '../../../../utils/sharedprefs.dart';
import '../../../../utils/textfeild.dart';
import '../../../../utils/textwidget.dart';
import '../../../../view/Auth/Create Job Request/model/job_frequency.dart';
import '../Work Expertise/work_expertise.dart';

class AddExperience {
  final TextEditingController companynamecontroller;
  final TextEditingController selectedFromDate;
  final TextEditingController selectedToDate;

  AddExperience({
    required this.companynamecontroller,
    required this.selectedFromDate,
    required this.selectedToDate,
  });
}

class MyWorkDetail extends StatefulWidget {
  final int? langid;
  const MyWorkDetail({super.key, this.langid});

  @override
  State<MyWorkDetail> createState() => _MyWorkDetailState();
}

class _MyWorkDetailState extends State<MyWorkDetail> {
  final _formkey = GlobalKey<FormState>();
  Future<dynamic> addworkdetailapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('workerregistertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(
            'Worker register Token :- ${getString('workerregistertoken')}');
        var request = http.Request('POST', Uri.parse(userworkdetailsurl));
        List historylist = [];
        for (var history in addexperience) {
          historylist.add({
            "Company_name": history.companynamecontroller.text.toString(),
            "from_date": history.selectedFromDate.text.toString(),
            "to_date": history.selectedToDate.text.toString()
          });
        }

        request.body = json.encode({
          "type_of_work": selectedJobId!.map((e) => e).toList(),
          "expected_salary": _expectedcontroller.text.toString(),
          "current_salary": _currentcontroller.text.toString(),
          "about_of_work": _telluscontroller.text.toString(),
          "work_experience": selectedexperience!.id,
          "work_history": historylist,
          "job_roles": selectedroleid.map((e) => e).toList()
          // 'job_roles': _selectedAnimals2.map((e) => e!.id).toList()
        });

        debugPrint('url :- ${userworkdetailsurl.toString()}');
        debugPrint('Body :- ${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var workDetail = WorkerDetailsModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (workDetail.status == 1) {
            setState(() {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.workdetailsuccessfull);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyWorkexpertise(
                            langid: widget.langid,
                          )));
            });
          } else {
            debugPrint('failed to login');
            ProgressDialogUtils.dismissProgressDialog();
            if (!mounted) return;
            connectorAlertDialogue(
                context: context,
                desc: '${workDetail.message}',
                onPressed: () {
                  Navigator.pop(context);
                }).show();
          }
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: 'There is no account with that user name & password !',
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: "${workDetail.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: "${workDetail.message}",
              onPressed: () {
                Navigator.pop(context);
              }).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          //  displayToast("There is no account with that user name & password !");
          connectorAlertDialogue(
              context: context,
              desc: "${workDetail.message}",
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

  Future<void> getjobfrequencyapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getworktypedropdownurl?id=${getInt("lang_id")}';
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

  Future<void> getjobexperienceapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getworkexperiencedropdownurl?id=${getInt("lang_id")}';
        debugPrint(apiurl);
        var headers = {
          'Content-Type': 'application/json',
        };

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var jobexperience = WorkerExpeireinceModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (jobexperience.status == '1') {
            setState(() {
              experienceyear = jobexperience.data!;
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
            desc: '${jobexperience.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobexperience.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobexperience.message}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: '${jobexperience.message}',
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
        var apiurl = '$getjobrolesurl?id=${getInt("lang_id")}';
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
              items = jobFrequencyPerHrs.data ?? [];
            });
            debugPrint('is it success');
          } else {
            setState(() {
              items = [];
            });
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

  @override
  void initState() {
    debugPrint('${getInt('lang_id')}');
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   languagechange();
    // });
    getjobfrequencyapi();
    getjobexperienceapi();
    getjobroleapi();
    addexperience.clear();
    addexperience.add(AddExperience(
        companynamecontroller: TextEditingController(),
        selectedFromDate: TextEditingController(),
        selectedToDate: TextEditingController()));
  }

  // void languagechange() {
  //   if (getInt('lang_id') != 1) {
  //     MyApp.of(context).setLocale(
  //         MyApp.of(context).isEnglish ? const Locale('pl') : Locale(''));
  //   } else {
  //     MyApp.of(context).setLocale(
  //         MyApp.of(context).isEnglish ? const Locale('en') : Locale(''));
  //   }
  // }

  // List<String> jobtype = ['part time', 'full time', 'seasonal'];
  List<ExpData> experienceyear = [];
  List<Data> frequency = [];
  List<RoleData> items = [];

  // List<RoleData> _animals = [];
  // List<RoleData?> _selectedAnimals2 = [];
  List<AddExperience> addexperience = [
    // AddExperience(
    //     companynamecontroller: TextEditingController(),
    //     selectedFromDate: DateTime.now(),
    //     selectedToDate: DateTime.now())
  ];
  final _acccontroller = TextEditingController();
  final _expectedcontroller = TextEditingController();
  final _currentcontroller = TextEditingController();
  final _telluscontroller = TextEditingController();
  // final _companynamecontroller = TextEditingController();

  List<String> selectedrole = [];
  List<String> selectedroleid = [];
  List<String> selectedjobtype = [];
  List<String>? selectedJobId = [];
  ExpData? selectedexperience;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: whitecolor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
              color: darkblack,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(
                title: AppLocalizations.of(context)!.workdetails,
                textFontSize: fontSize25,
                textFontWeight: fontWeightMedium,
                textColor: darkblack),
            Expanded(
                child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.accDetails,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getAcc(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.selecttypeofwork,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),

                    getJobtype(),
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
                          title: AppLocalizations.of(context)!.expectedsalary,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getExpectedSalary(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.currentsalary,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getCurrentlySalary(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title:
                              AppLocalizations.of(context)!.tellusaboutyourwork,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getTellus(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!
                              .howmanyworkexperiencedoyouhave,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    getExperiencetype(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.workhistory,
                          textFontSize: fontSize20,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addexperience.length,
                      itemBuilder: (context, index) {
                        return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: getTextWidget(
                                    title: AppLocalizations.of(context)!
                                        .companyname,
                                    textFontSize: fontSize14,
                                    textFontWeight: fontWeightMedium,
                                    textColor: darkblack),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 9.0),
                                child: PrimaryTextFeild(
                                  controller: addexperience[index]
                                      .companynamecontroller,
                                  // validation: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return AppLocalizations.of(context)!
                                  //         .requiredsomething;
                                  //   }
                                  //   return null;
                                  // },
                                  hintText:
                                      AppLocalizations.of(context)!.companyname,
                                  fontSize: fontSize14,
                                  fontWeight: fontWeightLight,
                                ),
                              ),
                              // getCompanyName(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getTextWidget(
                                            title: AppLocalizations.of(context)!
                                                .fromdate,
                                            textFontSize: fontSize14,
                                            textFontWeight: fontWeightMedium,
                                            textColor: darkblack),
                                        getFromDate(addexperience[index]
                                            .selectedFromDate)
                                        // Padding(
                                        //   padding:
                                        //       const EdgeInsets.only(top: 8.0),
                                        //   child: SizedBox(
                                        //     width: MediaQuery.of(context)
                                        //             .size
                                        //             .width /
                                        //         2.3,
                                        //     child: TextFormField(
                                        //       readOnly: true,
                                        //       onTap: () {
                                        //         _selectfromDate(
                                        //             context,
                                        //             addexperience[index]
                                        //                 .selectedFromDate);
                                        //       },
                                        //       onTapOutside: (event) =>
                                        //           FocusScope.of(context)
                                        //               .unfocus(),
                                        //       autovalidateMode: AutovalidateMode
                                        //           .onUserInteraction,
                                        //       style: const TextStyle(
                                        //           color: hintcolor),
                                        //       decoration: InputDecoration(
                                        //         contentPadding:
                                        //             const EdgeInsets.only(
                                        //           left: 16.0,
                                        //         ),
                                        //         hintText: addexperience[index]
                                        //             .selectedToDate
                                        //             .text,
                                        //         hintStyle: const TextStyle(
                                        //           color: hintcolor,
                                        //           fontSize: fontSize14,
                                        //           fontWeight: fontWeightRegular,
                                        //           fontFamily: fontfamilybeVietnam,
                                        //         ),
                                        //         fillColor: whitecolor,
                                        //         filled: true,
                                        //         enabled: true,
                                        //         suffixIcon: Padding(
                                        //           padding: const EdgeInsets.only(
                                        //               left: 16.0, right: 16.0),
                                        //           child: GestureDetector(
                                        //             onTap: () {
                                        //               _selectfromDate(
                                        //                   context,
                                        //                   addexperience[index]
                                        //                       .selectedFromDate);
                                        //             },
                                        //             child: const Icon(
                                        //               Icons
                                        //                   .calendar_today_outlined,
                                        //               size: 24.0,
                                        //               color: hintcolor,
                                        //             ),
                                        //           ),
                                        //         ),
                                        //         border: OutlineInputBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(43.0),
                                        //           borderSide: const BorderSide(
                                        //             width: 1.0,
                                        //             color: bordercolor,
                                        //           ),
                                        //         ),
                                        //         disabledBorder:
                                        //             OutlineInputBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(43.0),
                                        //           borderSide: const BorderSide(
                                        //               color: bordercolor),
                                        //         ),
                                        //         enabledBorder: OutlineInputBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(43.0),
                                        //           borderSide: const BorderSide(
                                        //               color: bordercolor),
                                        //         ),
                                        //         focusedBorder: OutlineInputBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(43.0),
                                        //           borderSide: const BorderSide(
                                        //               color: bordercolor),
                                        //         ),
                                        //         errorBorder: OutlineInputBorder(
                                        //           borderRadius:
                                        //               BorderRadius.circular(43.0),
                                        //           borderSide: const BorderSide(
                                        //               color: bordererror),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        getTextWidget(
                                            title: AppLocalizations.of(context)!
                                                .todate,
                                            textFontSize: fontSize14,
                                            textFontWeight: fontWeightMedium,
                                            textColor: darkblack),
                                        getToDate(
                                            addexperience[index].selectedToDate)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]);
                      },
                    ),
                    getAddmore(),
                    getButton()
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

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
                    hintText: AppLocalizations.of(context)!.select,
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
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               MultiSelectBottomSheetField<RoleData?>(
  //                 buttonIcon: const Icon(Icons.arrow_drop_down),
  //                 initialChildSize: 0.4,
  //                 listType: MultiSelectListType.LIST,
  //                 searchable: true,
  //                 chipDisplay: MultiSelectChipDisplay.none(),
  //                 title: const Text("Job Roles"),
  //                 items: items,
  //                 onConfirm: (List<RoleData?> values) {
  //                   setState(() {
  //                     _selectedAnimals2 = values;
  //                   });
  //                 },
  //               ),
  //               if (_selectedAnimals2.isEmpty)
  //                 Container(
  //                   height: 40,
  //                   padding: const EdgeInsets.only(left: 8),
  //                   alignment: Alignment.centerLeft,
  //                   child: const Text(
  //                     "None selected",
  //                     style: TextStyle(color: Colors.black54),
  //                   ),
  //                 ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
  //                 child: Wrap(
  //                   children: _selectedAnimals2.map((animal) {
  //                     return Padding(
  //                       padding: const EdgeInsets.only(top: 8.0, right: 8.0),
  //                       child: Container(
  //                         height: 40.0,
  //                         decoration: BoxDecoration(
  //                           color: lightblue,
  //                           borderRadius: BorderRadius.circular(43),
  //                         ),
  //                         child: Row(
  //                           // mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Padding(
  //                               padding: const EdgeInsets.only(
  //                                 left: 8.0,
  //                               ),
  //                               child: getTextWidget(
  //                                   textAlign: TextAlign.center,
  //                                   title: animal!.roleEnglish!,
  //                                   textFontSize: fontSize14,
  //                                   textFontWeight: fontWeightMedium,
  //                                   textColor: blackcolor),
  //                             ),
  //                             // Text(
  //                             //   animal!.roleEnglish!,
  //                             //   style: const TextStyle(color: Colors.black),
  //                             // ),
  //                             IconButton(
  //                               icon: const Icon(Icons.clear),
  //                               onPressed: () {
  //                                 setState(() {
  //                                   _selectedAnimals2.remove(animal);
  //                                 });
  //                               },
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  getExperiencetype() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
        items: experienceyear.map((item) {
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
                      item.experience!.toString(),
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
        value: selectedexperience,
        onChanged: (value) {
          setState(() {
            selectedexperience = value;
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

  getJobtype() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
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
                  selectedjobtype.isEmpty
                      ? AppLocalizations.of(context)!.select
                      : selectedjobtype.join(','),
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
        items: frequency.map((item) {
          return DropdownMenuItem(
            value: item.type,
            enabled: true,
            child: StatefulBuilder(builder: (context, mystate) {
              final isSelected = selectedjobtype.contains(item.type);
              return InkWell(
                onTap: () {
                  isSelected
                      ? selectedjobtype.remove(item.type)
                      : selectedjobtype.add(item.type!);

                  setState(() {});
                  if (isSelected) {
                    selectedJobId!.remove(item.id!.toString());
                  } else {
                    selectedJobId!.add(item.id!.toString());
                  }

                  mystate(() {});
                  debugPrint('The list of $selectedJobId');
                  debugPrint('The copied list $selectedjobtype');
                },
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      if (isSelected)
                        const Icon(Icons.check_box_outlined)
                      else
                        const Icon(Icons.check_box_outline_blank),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.type!.toString(),
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
          );
        }).toList(),
        value: selectedjobtype.isEmpty ? null : selectedjobtype.last,
        onChanged: (value) {
          // setState(() {
          //   seletcedjobtype = value;
          // });
        },
        selectedItemBuilder: (context) {
          return frequency.map(
            (item) {
              return Container(
                  alignment: Alignment.centerLeft,
                  child: getTextWidget(
                      title: selectedjobtype.join(','),
                      textFontSize: fontSize14,
                      textFontWeight: fontWeightRegular,
                      textColor: darkblack));
            },
          ).toList();
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

  getExpectedSalary() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        controller: _expectedcontroller,
        keyboardType: TextInputType.number,
        hintText: "\$ ",
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  getCurrentlySalary() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _currentcontroller,
        hintText: "\$ ",
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        keyboardType: TextInputType.number,
        fontSize: fontSize14,
        fontWeight: fontWeightLight,
      ),
    );
  }

  getTellus() {
    return Padding(
        padding: const EdgeInsets.only(top: 9.0),
        child: TextFormField(
          controller: _telluscontroller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.requiredsomething;
            }
            return null;
          },
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

  getFromDate(TextEditingController fromDateController) {
    // String hintText;
    // if (fromDateController.text.isEmpty) {
    //   // hintText = AppLocalizations.of(context)!.select;
    //   hintText = 'Select';

    // } else {
    // DateTime selectedDate = DateTime.parse(fromDateController.text);
    // String formattedDate = DateFormat('dd-MM-yy').format(selectedDate);
    // hintText = fromDateController.text;
    // debugPrint('else hint  $hintText');
    // }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.3,
        child: TextFormField(
          controller: fromDateController,
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return AppLocalizations.of(context)!.requireddate;
          //   }
          //   return null;
          // },
          readOnly: true,
          onTap: () {
            // _selecttoDate(context,  toDateController);
            _selectfromDate(context, fromDateController);
          },
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: darkblack),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              left: 16.0,
            ),
            hintText: 'Select Date',
            hintStyle: const TextStyle(
              color: hintcolor,
              fontSize: fontSize14,
              fontWeight: fontWeightRegular,
              fontFamily: fontfamilybeVietnam,
            ),
            fillColor: whitecolor,
            filled: true,
            enabled: true,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _selectfromDate(context, fromDateController);
                  // _selecttoDate(context, toDate, toDateController);
                },
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 24.0,
                  color: hintcolor,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(
                width: 1.0,
                color: bordercolor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordererror),
            ),
          ),
        ),
      ),
    );
  }

  getToDate(TextEditingController toDateController) {
    // String hintText;
    // if (toDateController.text.isEmpty) {
    //   // hintText = AppLocalizations.of(context)!.select;
    //   toDateController.text = 'Select';
    // }
    // } else {
    //   DateTime selectedDate = DateTime.parse(toDateController.text);
    //   String formattedDate = DateFormat('dd-MM-yy').format(selectedDate);
    //   hintText = formattedDate;
    // }
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2.3,
        child: TextFormField(
          controller: toDateController,
          // validator: (value) {
          //   if (value == null || value.isEmpty) {
          //     return AppLocalizations.of(context)!.requireddate;
          //   }
          //   return null;
          // },
          readOnly: true,
          onTap: () {
            // _selecttoDate(context,  toDateController);
            _selectfromDate(context, toDateController);
          },
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: const TextStyle(color: darkblack),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              left: 16.0,
            ),
            hintText: 'Select Date',
            hintStyle: const TextStyle(
              color: hintcolor,
              fontSize: fontSize14,
              fontWeight: fontWeightRegular,
              fontFamily: fontfamilybeVietnam,
            ),
            fillColor: whitecolor,
            filled: true,
            enabled: true,
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: GestureDetector(
                onTap: () {
                  _selectfromDate(context, toDateController);
                  // _selecttoDate(context, toDate, toDateController);
                },
                child: const Icon(
                  Icons.calendar_today_outlined,
                  size: 24.0,
                  color: hintcolor,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(
                width: 1.0,
                color: bordercolor,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordercolor),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(43.0),
              borderSide: const BorderSide(color: bordererror),
            ),
          ),
        ),
      ),
    );
  }

  getAddmore() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          setState(() {
            addexperience.add(AddExperience(
                companynamecontroller: TextEditingController(),
                selectedFromDate: TextEditingController(),
                selectedToDate: TextEditingController()));
          });
        },
        child: Row(
          children: [
            Image.asset(
              icAddicon,
              color: bluecolor,
              height: 24.0,
              width: 24.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 5.0,
            ),
            getTextWidget(
                title: AppLocalizations.of(context)!.addmoreexperience,
                textFontSize: fontSize15,
                textFontWeight: fontWeightMedium,
                textColor: bluecolor),
          ],
        ),
      ),
    );
  }

  bool _decideWhichDayToEnable(DateTime day) {
    // Enable all previous and current dates, disable future dates
    return day.isBefore(DateTime.now());
  }

  //   Future<void> _selecttoDate(
  //     BuildContext context, TextEditingController controller) async {
  //   final DateTime? picked = await showDatePicker(
  //     selectableDayPredicate: _decideWhichDayToEnable,
  //     builder: (context, child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           colorScheme: const ColorScheme.light(
  //             primary: bluecolor,
  //             onPrimary: darkblack,
  //             onSurface: darkblack,
  //           ),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(
  //               foregroundColor: bluecolor,
  //             ),
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //     context: context,
  //     firstDate: DateTime(1900, 8),
  //     lastDate: DateTime.now(),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       debugPrint('${picked.day}');
  //       controller.text =
  //           picked.toString(); // Update the text value of the controller
  //     });
  //   }
  // }

  Future<void> _selectfromDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      selectableDayPredicate: _decideWhichDayToEnable,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: bluecolor,
              onPrimary: darkblack,
              onSurface: darkblack,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: bluecolor,
              ),
            ),
          ),
          child: child!,
        );
      },
      initialDate: DateTime.now(),
      context: context,
      firstDate: DateTime(1900, 8),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        String formattedDate = DateFormat('dd MMM yy').format(picked);
        debugPrint(formattedDate); // Print the formatted date
        controller.text =
            formattedDate; // Update the text value of the controller
      });
    }
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.continuetext,
          onPressed: () {
            if (_formkey.currentState!.validate() &&
                selectedexperience != null &&
                selectedrole.isNotEmpty) {
              addworkdetailapi();
            } else if (selectedrole.isEmpty) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.selectjobrole);
            } else if (selectedexperience == null) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.selectyourexpertise);
            }
          }),
    );
  }

  getAcc() {
    return Padding(
      padding: const EdgeInsets.only(top: 9.0),
      child: PrimaryTextFeild(
        controller: _acccontroller,
        validation: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.requiredsomething;
          }
          return null;
        },
        hintText: AppLocalizations.of(context)!.accDetails,
        fontSize: fontSize14,
        keyboardType: TextInputType.number,
        fontWeight: fontWeightLight,
      ),
    );
  }
}
