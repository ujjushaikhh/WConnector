import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Edit%20Profile/model/get_workdetail.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Auth/Edit%20Profile/model/update_worker_history_model.dart';
import 'package:wconnectorconnectorflow/workerflow/view/Bottom%20Tab/primarybottomtab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import '../../../../../constants/api_constants.dart';
import '../../../../../constants/color_constants.dart';
import '../../../../../constants/font_constants.dart';
import '../../../../../constants/image_constants.dart';
import '../../../../../utils/button.dart';
import '../../../../../utils/dailog.dart';
import '../../../../../utils/internetconnection.dart';
import '../../../../../utils/progressdialog.dart';
import '../../../../../utils/sharedprefs.dart';
import '../../../../../utils/textwidget.dart';
import '../../../../../view/Auth/Create Job Request/model/job_frequency.dart';
import '../../../../../view/Auth/Create Job Request/model/job_role.dart';
import '../../Work Detail/model/work_experiencemodel.dart';

class MyWorkHistoryEdit extends StatefulWidget {
  const MyWorkHistoryEdit({super.key});

  @override
  State<MyWorkHistoryEdit> createState() => _MyWorkHistoryEditState();
}

class _MyWorkHistoryEditState extends State<MyWorkHistoryEdit> {
  @override
  void initState() {
    super.initState();
    getWorkerHistoryDetail();
    getjobexperienceapi();
    getjobfrequencyapi();
    getjobroleapi();
    // addexperience.clear();
    // addexperience.add(AddExperience(
    //     companynamecontroller: TextEditingController(),
    //     selectedFromDate: TextEditingController(),
    //     selectedToDate: TextEditingController()));
  }

  Future<void> getjobfrequencyapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getworktypedropdownurl?id=${getInt('lang_id')}';
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

  Future<dynamic> updateworkdetailapi() async {
    if (await checkUserConnection()) {
      try {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint('Worker register Token :- ${getString('usertoken')}');
        var request = http.Request('POST', Uri.parse(updateuserworkhistoryurl));
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
          "expected_salary": _expectedSalary.text.toString(),
          "current_salary": _currentSalary.text.toString(),
          "about_of_work": _worktelluscontroller.text.toString(),
          "work_experience": selectedexperience!.id,
          "work_history": historylist,
          "job_roles": selectedJobRoleId!.map((e) => e).toList()
          // 'job_roles': _selectedAnimals2.map((e) => e!.id).toList()
        });

        debugPrint('url :- ${userworkdetailsurl.toString()}');
        debugPrint('Body :- ${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var workDetail = UpdateWorkHistoryModel.fromJson(jsonResponse);
        debugPrint(responsed.body);
        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (workDetail.status == '1') {
            setState(() {
              Fluttertoast.showToast(msg: 'Work Details added successfully');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WorkerPrimaryBottomTab(
                            from: 'home',
                          )),
                  (route) => false);
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
              desc: '${workDetail.message}',
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

  String? toDate;
  String? fromDate;
  List<AddExperience> addexperience = [];

  List<Data> frequency = [];
  List<TypeOfWork> typeofwork = [];
  List selectedjobtype = [];
  List<String>? selectedJobId = [];

  List<RoleData> jobRole = [];
  List<JobRoles> getjobrole = [];
  List selectedjobrole = [];
  List<String>? selectedJobRoleId = [];

  List<ExpData> experienceyear = [];
  // List<JobRoles> getjobrole = [];

  // List _selectedjobrole = [];
  // List<RoleData> _animals = [];
  // List<RoleData> _selectedAnimals2 = [];

  ExpData? selectedexperience;
  String? getExperience;

  final TextEditingController textEditingController = TextEditingController();
  final _experiencecontroller = TextEditingController();
  final _worktelluscontroller = TextEditingController();
  final _expectedSalary = TextEditingController();
  final _currentSalary = TextEditingController();

  bool isload = true;

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> getjobroleapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getjobrolesurl?id=${getInt('lang_id')}';
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
              jobRole = jobFrequencyPerHrs.data ?? [];
            });
            debugPrint('is it success');
          } else {
            setState(() {
              jobRole = [];
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

  Future<void> getjobexperienceapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      // ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getworkexperiencedropdownurl?id=${getInt('lang_id')}';
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

  Future<void> getWorkerHistoryDetail() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = getuserworkdetailsurl;

        var headers = {
          'Authorization': 'Bearer ${getString('usertoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('usertoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));

        // request.body = json.encode({"id": widget.jobId!.toString()});
        // debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getWorkerWorkDetail =
            GetExtraWorkDetailModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getWorkerWorkDetail.status == '1') {
            setState(() {
              typeofwork = getWorkerWorkDetail.data!.typeOfWork!;
              selectedjobtype = typeofwork.map((e) => e.type).toList();

              getjobrole = getWorkerWorkDetail.data!.jobRoles!;
              selectedjobrole = getjobrole.map((e) => e.roleEnglish).toList();
              // _selectedjobrole = getjobrole;
              // _selectedjobrole = getjobrole.map((e) => e.roleEnglish!).toList();
              _experiencecontroller.text =
                  getWorkerWorkDetail.data!.workExperience!;
              List<AddExperience> workHistory = [];
              for (var data in getWorkerWorkDetail.data!.workHistory!) {
                TextEditingController companyname =
                    TextEditingController(text: data.companyName.toString());
                TextEditingController fromdate =
                    TextEditingController(text: data.fromDate.toString());
                TextEditingController todate =
                    TextEditingController(text: data.toDate.toString());

                workHistory.add(AddExperience(
                    companynamecontroller: companyname,
                    selectedFromDate: fromdate,
                    selectedToDate: todate));
              }

              addexperience = workHistory;

              // workHistory = getWorkerWorkDetail.data!.workHistory ?? [];

              _worktelluscontroller.text =
                  getWorkerWorkDetail.data!.aboutOfWork!;
              getExperience = getWorkerWorkDetail.data!.workExperience!;
              _expectedSalary.text = getWorkerWorkDetail.data!.expectedSalary!;
              _currentSalary.text = getWorkerWorkDetail.data!.currentSalary!;

              // if (addexperience.isNotEmpty) {
              //   for (var date in addexperience) {
              //     if (date.companynamecontroller.text == '' &&
              //         date.selectedFromDate.text == '' &&
              //         date.selectedToDate.text == '') {
              //       setState(() {
              //         addexperience = [];
              //       });
              //     } else {
              //       DateTime? formattedToDate =
              //           DateTime.parse(date.selectedFromDate.text.toString());
              //       toDate = DateFormat('dd MMM yyyy').format(formattedToDate);
              //       DateTime? formattedFromDate =
              //           DateTime.parse(date.selectedToDate.text.toString());
              //       fromDate =
              //           DateFormat('dd MMM yyyy').format(formattedFromDate);
              //     }
              //   }
              // } else {
              //   setState(() {
              //     toDate = '';
              //     fromDate = '';
              //   });
              // }

              isload = false;
            });
            debugPrint('is it success');
          } else {
            // debugPrint('failed to load :-${getWorkerWorkDetail.message}');

            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorized user',
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()),
              //     (route) => false);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request 400',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 500) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Internal server error',
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.myworkhistory,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
        backgroundColor: whitecolor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: darkblack,
              size: 24,
            )),
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getAccEdit(),
                    getTypeofworkEdit(),
                    getroleofworkEdit(),
                    // getMultipleJobRole(),
                    getExpectedSalaryEdit(),
                    getCurrentSalaryEdit(),
                    getTellusEdit(),
                    getWorkExperienceEdit(),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.workhistory,
                          textFontSize: fontSize20,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    addexperience.isEmpty ? Container() : getWorkHistoryEdit(),
                    getAddmore(),
                    getButton()
                  ],
                ),
              ),
            ),
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
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               MultiSelectBottomSheetField(
  //                 buttonIcon: const Icon(Icons.arrow_drop_down),
  //                 initialChildSize: 0.4,
  //                 listType: MultiSelectListType.LIST,
  //                 searchable: true,
  //                 chipDisplay: MultiSelectChipDisplay.none(),
  //                 title: const Text("Job Roles"),
  //                 items: items,
  //                 onConfirm: (values) {
  //                   setState(() {
  //                     _selectedjobrole = values;
  //                     // _selectedAnimals2 = values;
  //                   });
  //                 },
  //               ),
  //               if (_selectedjobrole.isEmpty)
  //                 Container(
  //                   height: 40,
  //                   padding: const EdgeInsets.only(left: 8),
  //                   alignment: Alignment.centerLeft,
  //                   child: const Text(
  //                     'None',
  //                     // _selectedjobrole.isEmpty
  //                     //     ? "None selected"
  //                     //     : _selectedjobrole.map((e) => e).toString(),
  //                     style: TextStyle(color: Colors.black54),
  //                   ),
  //                 ),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
  //                 child: Wrap(
  //                   children: _selectedjobrole.map((animal) {
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
  //                                   title: animal.toString(),
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
  //                                   _selectedjobrole.remove(animal);
  //                                   // isSelected
  //                                   // _selectedjobrole.remove(animal.toString());
  //                                   // : _selectedjobrole
  //                                   //     .add(animal.roleEnglish!);
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

  getWorkExperienceEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            width: screenSize!.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 1, color: boxbordercolor)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.workexperience,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                      Image.asset(
                        icEditProfile,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: boxbordercolor,
                  thickness: 1.0,
                  height: 1.0,
                ),
                DropdownButtonHideUnderline(
                    child: DropdownButton2(
                  style: const TextStyle(color: darkblack),
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: getTextWidget(
                                title: getExperience!.toString(),
                                textFontSize: fontSize14,
                                textFontWeight: fontWeightMedium,
                                textColor: darkblack)),
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
                                child: getTextWidget(
                                    title: item.experience!.toString(),
                                    textFontSize: fontSize14,
                                    textFontWeight: fontWeightMedium,
                                    textColor: darkblack)),
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
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(43.0),
                    //   border: Border.all(
                    //     color: bordercolor,
                    //   ),
                    // color: whitecolor,
                    // ),
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
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  getTellusEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Container(
            width: screenSize!.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 1, color: boxbordercolor)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!
                                .tellusaboutyourwork,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                      Image.asset(
                        icEditProfile,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: boxbordercolor,
                  thickness: 1.0,
                  height: 1.0,
                ),
                TextFormField(
                  controller: _worktelluscontroller,
                  style: const TextStyle(
                      fontSize: fontSize14,
                      fontWeight: fontWeightMedium,
                      fontFamily: fontfamilybeVietnam),
                  maxLines: 8,
                  decoration: const InputDecoration(
                    hintMaxLines: 8,
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(top: 15, left: 20, right: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getCurrentSalaryEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            width: screenSize!.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 1, color: boxbordercolor)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.currentsalary,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                      Image.asset(
                        icEditProfile,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: boxbordercolor,
                  thickness: 1.0,
                  height: 1.0,
                ),
                TextFormField(
                  controller: _currentSalary,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    border: InputBorder.none,
                    // contentPadding:
                    //     EdgeInsets.only(top: 15, left: 20, bottom: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getExpectedSalaryEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            width: screenSize!.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                // borderRadius: const BorderRadius.only(
                //     topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                border: Border.all(width: 1, color: boxbordercolor)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.expectedsalary,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                      Image.asset(
                        icEditProfile,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: boxbordercolor,
                  thickness: 1.0,
                  height: 1.0,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _expectedSalary,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    border: InputBorder.none,
                    // contentPadding:
                    //     EdgeInsets.only(top: 15, left: 8.0, bottom: 20.0),
                    // hintText: '\$ $expectedSalary',
                    // hintStyle: const TextStyle(
                    //     fontSize: fontSize14,
                    //     fontWeight: fontWeightRegular,
                    //     fontFamily: fontfamilybeVietnam,
                    //     color: lightblack),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  getTypeofworkEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            width: screenSize!.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 1, color: boxbordercolor)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.typeofwork,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                      Image.asset(
                        icEditProfile,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: boxbordercolor,
                  thickness: 1.0,
                  height: 1.0,
                ),
                DropdownButtonHideUnderline(
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
                                : selectedjobtype.map((e) => e).toString(),
                            // selectedjobtype.isEmpty
                            // ?
                            // : selectedjobtype.join(','),
                            style: const TextStyle(
                              color: darkblack,
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
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(43.0),
                    //   border: Border.all(
                    //     color: bordercolor,
                    //   ),
                    //   color: whitecolor,
                    // ),
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
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  getroleofworkEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        children: [
          Container(
            width: screenSize!.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                border: Border.all(width: 1, color: boxbordercolor)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.workrole,
                            textFontSize: fontSize15,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                      ),
                      Image.asset(
                        icEditProfile,
                        height: 24,
                        width: 24,
                        fit: BoxFit.cover,
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: boxbordercolor,
                  thickness: 1.0,
                  height: 1.0,
                ),
                DropdownButtonHideUnderline(
                    child: DropdownButton2(
                  style: const TextStyle(color: darkblack),
                  isExpanded: true,
                  hint: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            selectedjobrole.isEmpty
                                ? AppLocalizations.of(context)!.select
                                : selectedjobrole.map((e) => e).toString(),
                            // selectedjobtype.isEmpty
                            // ?
                            // : selectedjobtype.join(','),
                            style: const TextStyle(
                              color: darkblack,
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
                  items: jobRole.map((item) {
                    return DropdownMenuItem(
                      value: item.roleEnglish,
                      enabled: true,
                      child: StatefulBuilder(builder: (context, mystate) {
                        final isSelected =
                            selectedjobrole.contains(item.roleEnglish);
                        return InkWell(
                          onTap: () {
                            isSelected
                                ? selectedjobrole.remove(item.roleEnglish)
                                : selectedjobrole.add(item.roleEnglish!);

                            setState(() {});
                            if (isSelected) {
                              selectedJobRoleId!.remove(item.id!.toString());
                            } else {
                              selectedJobRoleId!.add(item.id!.toString());
                            }

                            mystate(() {});
                            debugPrint('The list of $selectedjobrole');
                            debugPrint('The Ids list $selectedJobRoleId');
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
                    );
                  }).toList(),
                  value: selectedjobrole.isEmpty ? null : selectedjobrole.last,
                  onChanged: (value) {
                    // setState(() {
                    //   seletcedjobtype = value;
                    // });
                  },
                  selectedItemBuilder: (context) {
                    return jobRole.map(
                      (item) {
                        return Container(
                            alignment: Alignment.centerLeft,
                            child: getTextWidget(
                                title:
                                    "${AppLocalizations.of(context)!.selecteditem} ${selectedjobrole.length}",
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
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(43.0),
                    //   border: Border.all(
                    //     color: bordercolor,
                    //   ),
                    //   color: whitecolor,
                    // ),
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
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white),
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
                )),
              ],
            ),
          ),
        ],
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

  getWorkHistoryEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
          itemCount: addexperience.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    width: screenSize!.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        // borderRadius: const BorderRadius.only(
                        //     topLeft: Radius.circular(6), topRight: Radius.circular(6)),
                        border: Border.all(width: 1, color: boxbordercolor)),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(
                                      top: 3.0, bottom: 2.0),
                                  child: SizedBox(
                                      width: screenSize!.width - 98,
                                      child: TextFormField(
                                        controller: addexperience[index]
                                            .companynamecontroller,
                                        decoration: InputDecoration(
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .companyname,
                                          border: InputBorder.none,
                                          // suffixIcon:
                                          //    Image.asset(
                                          // icEditProfile,
                                          // height: 24.0,
                                          // width: 24.0,
                                          // fit: BoxFit.cover,
                                          // color: bluecolor,
                                        ),
                                      )
                                      // PrimaryTextFeild(
                                      //   controller: addexperience[index]
                                      //       .companynamecontroller,
                                      //   anysuffixicon: icEditProfile,
                                      //   suffixiconcolor: bluecolor,
                                      // ),
                                      )
                                  //  getTextWidget(

                                  //     title: addexperience[index]
                                  //         .companynamecontroller
                                  //         .text
                                  //         .toString(),
                                  //     textFontSize: fontSize15,
                                  //     textFontWeight: fontWeightSemiBold,
                                  //     textColor: darkblack),
                                  ),
                              Image.asset(
                                icEditProfile,
                                height: 24,
                                width: 24,
                                fit: BoxFit.cover,
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          color: boxbordercolor,
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 20.0, right: 82.0, bottom: 20.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextWidget(
                                      title: AppLocalizations.of(context)!
                                          .fromword,
                                      textColor: hintcolor,
                                      textFontSize: fontSize14,
                                      textFontWeight: fontWeightLight),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: SizedBox(
                                          width: screenSize!.width / 3.5,
                                          child: TextFormField(
                                            readOnly: true,
                                            onTap: () {
                                              // _selecttoDate(context,  toDateController);
                                              _selectfromDate(
                                                  context,
                                                  addexperience[index]
                                                      .selectedFromDate);
                                            },
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .selectdate,
                                                border: InputBorder.none),
                                            controller: addexperience[index]
                                                .selectedFromDate,
                                          ))
                                      // getTextWidget(
                                      //     title: fromDate!,
                                      //     textFontSize: fontSize14,
                                      //     textFontWeight: fontWeightMedium,
                                      //     textColor: lightblack),
                                      )
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextWidget(
                                      title:
                                          AppLocalizations.of(context)!.toword,
                                      textColor: hintcolor,
                                      textFontSize: fontSize14,
                                      textFontWeight: fontWeightLight),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: SizedBox(
                                          width: screenSize!.width / 3.5,
                                          child: TextFormField(
                                            readOnly: true,
                                            onTap: () {
                                              _selectfromDate(
                                                  context,
                                                  addexperience[index]
                                                      .selectedToDate);
                                            },
                                            decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .selectdate,
                                                border: InputBorder.none),
                                            controller: addexperience[index]
                                                .selectedToDate,
                                          ))
                                      // getTextWidget(
                                      //     title: toDate!,
                                      //     textFontSize: fontSize14,
                                      //     textFontWeight: fontWeightMedium,
                                      //     textColor: lightblack),
                                      )
                                ],
                              )
                            ],
                          ),
                        )
                        // TextFormField(
                        //   keyboardType: TextInputType.number,
                        //   decoration: const InputDecoration(
                        //       border: InputBorder.none,
                        //       contentPadding:
                        //           EdgeInsets.only(top: 15, left: 20, bottom: 20.0),
                        //       hintText: '1234 5444 44444 333',
                        //       hintStyle: TextStyle(
                        //           fontSize: fontSize14,
                        //           fontWeight: fontWeightRegular,
                        //           color: lightblack)),
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  Future<void> _selectfromDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      selectableDayPredicate: (day) {
        return day.isBefore(DateTime.now());
      },
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
        debugPrint(formattedDate);

        controller.text =
            formattedDate.toString(); // Update the text value of the controller
      });
    }
  }

  getAccEdit() {
    return Column(
      children: [
        Container(
          width: screenSize!.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              // borderRadius: const BorderRadius.only(
              //     topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              border: Border.all(width: 1, color: boxbordercolor)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 11.0, bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.accDetails,
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightSemiBold,
                          textColor: darkblack),
                    ),
                    Image.asset(
                      icEditProfile,
                      height: 24,
                      width: 24,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
              const Divider(
                color: boxbordercolor,
                thickness: 1.0,
                height: 1.0,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(top: 15, left: 20, bottom: 20.0),
                    hintText: '1234 5444 44444 333',
                    hintStyle: TextStyle(
                        fontSize: fontSize14,
                        fontFamily: fontfamilybeVietnam,
                        fontWeight: fontWeightRegular,
                        color: lightblack)),
              ),
            ],
          ),
        ),
        // Container(
        //   // width: screenSize!.width,
        //   decoration: BoxDecoration(
        //       borderRadius: const BorderRadius.only(
        //           bottomLeft: Radius.circular(6),
        //           bottomRight: Radius.circular(6)),
        //       border: Border.all(width: 1, color: boxbordercolor)),

        //   child:
        // )
      ],
    );
  }

  getButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 20.0),
      child: CustomizeButton(
          text: AppLocalizations.of(context)!.save,
          onPressed: () {
            updateworkdetailapi();
          }),
    );
  }
}

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
