import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/constants/color_constants.dart';
import 'package:wconnectorconnectorflow/utils/textfeild.dart';
import 'package:wconnectorconnectorflow/view/Posted%20Job%20Detail/model/applicant_model.dart';
import 'package:http/http.dart' as http;
import 'package:wconnectorconnectorflow/view/View%20Applicant/model/accpet_applicant.dart';
import 'package:wconnectorconnectorflow/view/View%20Applicant/model/hired_applicant.dart';
import 'package:wconnectorconnectorflow/view/View%20Applicant/model/location_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../utils/button.dart';
import '../../utils/dailog.dart';
import '../../utils/internetconnection.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textwidget.dart';
import '../Applicant Detail/applicant_detail.dart';
import '../Hired Applicants/model/hired_applicant_model.dart';

// class ApplicantDetail {
//   String? applicantImg;
//   String? applicantName;
//   String? applicantLocation;
//   String? work;

//   ApplicantDetail(
//       {this.applicantImg,
//       this.applicantLocation,
//       this.applicantName,
//       this.work});
// }

class MyViewApplicant extends StatefulWidget {
  final int? type;
  final int? jobId;
  final String? jobName;
  final String? daysAgo;
  final String? noOfapplicants;
  final String? status;
  final String? workType;
  final String? salary;
  final String? salaryType;

  const MyViewApplicant(
      {super.key,
      this.jobId,
      this.daysAgo,
      this.jobName,
      this.status,
      this.type,
      this.noOfapplicants,
      this.salary,
      this.salaryType,
      this.workType});

  @override
  State<MyViewApplicant> createState() => _MyViewApplicantState();
}

class _MyViewApplicantState extends State<MyViewApplicant> {
  bool isload = true;
  // int? appplicantId;
  Future<void> getApplicantstatusTypesapi({bool showprogress = true}) async {
    if (await checkUserConnection()) {
      if (showprogress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = "$getopenjobuserlist/${widget.jobId}";

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));

        // request.body = json.encode({"id": widget.jobId!.toString()});
        // debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getApplicantstatus = ViewApplicantModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getApplicantstatus.status == '1') {
            setState(() {
              applicantList = getApplicantstatus.jobs ?? [];
              isload = false;
              // if (applicantList.isNotEmpty) {
              //   for (var id in applicantList) {
              //     appplicantId = id.userId!;
              //   }
              // }

              // isLoad = false;
            });
            debugPrint('is it success');
          } else {
            // debugPrint('failed to load :-${getApplicantstatus.message}');

            ProgressDialogUtils.dismissProgressDialog();
            setState(() {
              applicantList = [];
            });
            isload = false;
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

  Future<void> setlocationapi(int applicantId) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = usersetlocationurl;

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({
          "address": _locationController.text.toString(),
          "longitude": "22.9920",
          "latitude": "72.5366",
          "user_id": applicantId.toString(),
          "job_id": widget.jobId.toString()
        });
        debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getlocation = SetLocationModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getlocation.status == '1') {
            setState(() {
              debugPrint(getlocation.message!);
            });
            debugPrint('is it success');
          } else {
            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorized user ${response.statusCode}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request ${response.statusCode}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request ${response.statusCode}',
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

  Future<void> acceptApplicantStatusapi(int applicantId, String status) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$acceptapplicanturl/$applicantId/${widget.jobId}/$status";
        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        // request.body = json.encode({"id": widget.jobId!.toString()});
        // debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getApplicantstatus = AcceptApplicantModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getApplicantstatus.status == '1') {
            setState(() {
              debugPrint(getApplicantstatus.message!);
              getApplicantstatusTypesapi(showprogress: false);
              // isLoad = false;
            });
            debugPrint('is it success');
          } else {
            // debugPrint('failed to load :-${getApplicantstatus.message}');

            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorized user ${response.statusCode}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request ${response.statusCode}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request ${response.statusCode}',
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

  Future<void> hiredApplicantstatusapi(int applicantId, String status) async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = "$hireduserlisturl/$applicantId/${widget.jobId}/$status";

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('commpanytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('POST', Uri.parse(apiurl));

        request.body = json.encode({
          "address": _locationController.text.toString(),
          "longitude": "22.9920",
          "latitude": "72.5366",
          "user_id": applicantId.toString(),
          "job_id": widget.jobId.toString()
        });
        debugPrint('Body :-${request.body}');
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getHiredApplicant =
            HiredApplicantStatusModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getHiredApplicant.status == '1') {
            setState(() {
              debugPrint(getHiredApplicant.message!);
              Navigator.pop(context);
              getApplicantstatusTypesapi(showprogress: false);

              // showLocationDailogue(applicantId);
              // isLoad = false;
            });
            debugPrint('is it success');
          } else {
            // debugPrint('failed to load :-${getApplicantstatus.message}');

            ProgressDialogUtils.dismissProgressDialog();
          }
        } else if (response.statusCode == 401) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Unauthorized user ${response.statusCode}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 404) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request ${response.statusCode}',
            onPressed: () {
              Navigator.pop(context);
            },
          ).show();
        } else if (response.statusCode == 400) {
          ProgressDialogUtils.dismissProgressDialog();
          if (!mounted) return;
          connectorAlertDialogue(
            context: context,
            desc: 'Bad request ${response.statusCode}',
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

  Future<void> getHiredApplicantapi() async {
    if (await checkUserConnection()) {
      if (!mounted) return;
      ProgressDialogUtils.showProgressDialog(context);
      try {
        var apiurl = '$getuserhiredlisturl/${widget.jobId}';

        var headers = {
          'Authorization': 'Bearer ${getString('commpanytoken')}',
          'Content-Type': 'application/json',
        };

        debugPrint(getString('companytoken'));
        debugPrint('url :-$apiurl');

        var request = http.Request('GET', Uri.parse(apiurl));
        request.headers.addAll(headers);
        http.StreamedResponse response = await request.send();
        final responsed = await http.Response.fromStream(response);
        var jsonResponse = jsonDecode(responsed.body);
        var getHiredApplicant = HiredApplicantModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getHiredApplicant.status == '1') {
            setState(() {
              hiredapplicantList = getHiredApplicant.users ?? [];
              isload = false;
            });
            debugPrint('is it success');
          } else {
            debugPrint('failed to load');
            ProgressDialogUtils.dismissProgressDialog();
            setState(() {
              hiredapplicantList = [];
              isload = false;
            });
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
  void initState() {
    super.initState();
    if (widget.type == 0) {
      getApplicantstatusTypesapi();
    } else {
      getHiredApplicantapi();
    }
  }

  final _locationController = TextEditingController();
  List<Jobs> applicantList = [
    // ApplicantDetail(
    //     applicantImg: icapplicant1,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Wade Warren",
    //     work: "Product Designer - Gopay"),
    // ApplicantDetail(
    //     applicantImg: icapplicant2,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Ralph Edwards",
    //     work: "Product Designer - Gopay"),
    // ApplicantDetail(
    //     applicantImg: icapplicant3,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Bessie Cooper",
    //     work: "Product Designer - Gopay"),
    // ApplicantDetail(
    //     applicantImg: icapplicant4,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Cody Fisher",
    //     work: "Product Designer - Gopay")
  ];

  List<Users> hiredapplicantList = [
    // ApplicantDetail(
    //     workLocation: '8502 Preston Rd.',
    //     applicantImg: icapplicant1,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Wade Warren",
    //     work: "Product Designer - Gopay"),
    // ApplicantDetail(
    //     workLocation: '8502 Preston Rd.',
    //     applicantImg: icapplicant2,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Ralph Edwards",
    //     work: "Product Designer - Gopay"),
    // ApplicantDetail(
    //     applicantImg: icapplicant3,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Bessie Cooper",
    //     workLocation: '8502 Preston Rd.',
    //     work: "Product Designer - Gopay"),
    // ApplicantDetail(
    //     applicantImg: icapplicant4,
    //     applicantLocation: "Garut , Angola",
    //     applicantName: "Cody Fisher",
    //     workLocation: '8502 Preston Rd.',
    //     work: "Product Designer - Gopay")
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whitecolor,
      appBar: AppBar(
        centerTitle: true,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.viewapplicants,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      getTextWidget(
                          title: widget.jobName!.toString(),
                          textFontSize: fontSize15,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                      GestureDetector(
                        onTap: () {
                          // showLocationDailogue();
                        },
                        child: Image.asset(
                          icMore,
                          height: 24.0,
                          width: 24.0,
                          color: darkblack,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: Row(
                      children: [
                        getTextWidget(
                            title:
                                '${widget.daysAgo} ${AppLocalizations.of(context)!.daysago}',
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightRegular,
                            textColor: bluecolor),
                        Padding(
                          padding: const EdgeInsets.only(left: 18.0, top: 2.0),
                          child: Image.asset(
                            icDash,
                            width: 6,
                            color: greycolor,
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        getTextWidget(
                            title:
                                '${widget.noOfapplicants} ${AppLocalizations.of(context)!.applicants}',
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightRegular,
                            textColor: darkblack)
                      ],
                    ),
                  ),
                  // const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15.0,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 24.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33.0),
                              color: lightbordercolorpro),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                            child: Center(
                              child: getTextWidget(
                                  title: widget.workType!.toString(),
                                  textFontSize: fontSize12,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 11.0,
                        ),
                        Container(
                          height: 24.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(33.0),
                              color: lightbordercolorpro),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
                            child: Center(
                              child: getTextWidget(
                                  title:
                                      '\$ ${widget.salary} ${widget.salaryType}',
                                  textFontSize: fontSize12,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 24.0,
                          decoration: BoxDecoration(
                              color: widget.status == 'Open'
                                  ? greencolor
                                  : lightgreypromax,
                              borderRadius: BorderRadius.circular(33)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, bottom: 2.0, left: 10.0, right: 10.0),
                            child: Center(
                              child: getTextWidget(
                                  title: widget.status == 'Open'
                                      ? AppLocalizations.of(context)!.openword
                                      : AppLocalizations.of(context)!
                                          .closedword,
                                  textFontSize: fontSize12,
                                  textFontWeight: fontWeightMedium,
                                  textColor: whitecolor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  // getButton(),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            const Divider(
              color: boxborderpro,
              thickness: 1.0,
              height: 1.0,
            ),
            applicantList.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 13.0, left: 16),
                    child: Row(
                      children: [
                        getTextWidget(
                            title: applicantList.length.toString(),
                            textFontSize: fontSize20,
                            textFontWeight: fontWeightSemiBold,
                            textColor: darkblack),
                        getTextWidget(
                            title:
                                ' ${AppLocalizations.of(context)!.applicants}',
                            textFontSize: fontSize20,
                            textFontWeight: fontWeightLight,
                            textColor: darkblack)
                      ],
                    ),
                  ),
            widget.type == 0
                ? applicantList.isEmpty
                    ? isload
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.transparent,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, right: 36, left: 36),
                            child: getTextWidget(
                                textAlign: TextAlign.center,
                                title: AppLocalizations.of(context)!
                                    .noapplicantsarethere,
                                textFontSize: fontSize20,
                                textFontWeight: fontWeightSemiBold,
                                textColor: blackcolor),
                          )
                    : getApplicantList()
                : hiredapplicantList.isEmpty
                    ? isload
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.transparent,
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 50.0, right: 36, left: 36),
                            child: getTextWidget(
                                textAlign: TextAlign.center,
                                title: AppLocalizations.of(context)!
                                    .noapplicanthired,
                                textFontSize: fontSize20,
                                textFontWeight: fontWeightSemiBold,
                                textColor: blackcolor),
                          )
                    : getHiredApplicantList()
          ],
        ),
      ),
    );
  }

  getHiredApplicantList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: hiredapplicantList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const MyJobDetail()));
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: whitecolor,
                          border:
                              Border.all(color: lightbordercolorpro, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 73,
                                  width: 73,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                        width: 1, color: lightbordercolorpro),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: CachedNetworkImage(
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          // height: 34.0,
                                          // width: 34.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            // height: 34.0,
                                            // width: 34.0,
                                            decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                        imageUrl: hiredapplicantList[index]
                                            .userImage!,
                                        // height: 34,
                                        // width: 34,
                                        // fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 17.0, left: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getTextWidget(
                                          title: hiredapplicantList[index]
                                              .userName!,
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: darkblack),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            icGreyLocation,
                                            height: 17,
                                            width: 17,
                                            fit: BoxFit.cover,
                                          ),
                                          const SizedBox(
                                            width: 4.0,
                                          ),
                                          getTextWidget(
                                              title: hiredapplicantList[index]
                                                  .address!,
                                              textColor: lightwhitecolor,
                                              textFontSize: fontSize13,
                                              textFontWeight: fontWeightRegular)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 17, right: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyApplicantDetails(
                                                      jobId: widget.jobId,
                                                      userId:
                                                          hiredapplicantList[
                                                                  index]
                                                              .userId,
                                                    )));
                                      },
                                      child: getTextWidget(
                                          title: AppLocalizations.of(context)!
                                              .viewword,
                                          textFontSize: fontSize14,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: bluecolor),
                                    )
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: ApplicantDetail[index].status! ==
                                    //               'open'
                                    //           ? greencolor
                                    //           : lightgreypromax,
                                    //       borderRadius: BorderRadius.circular(33)),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //         top: 2.0,
                                    //         bottom: 2.0,
                                    //         left: 10.0,
                                    //         right: 10.0),
                                    //     child: getTextWidget(
                                    //         title: ApplicantDetail[index].status! ==
                                    //                 'open'
                                    //             ? "Open"
                                    //             : "Closed",
                                    //         textFontSize: fontSize12,
                                    //         textFontWeight: fontWeightMedium,
                                    //         textColor: whitecolor),
                                    //   ),
                                    // ),
                                    )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: getTextWidget(
                                  title:
                                      AppLocalizations.of(context)!.appliedfor,
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightRegular,
                                  textColor: shadowcolor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: getTextWidget(
                                  title: hiredapplicantList[index].jobName!,
                                  textFontSize: fontSize15,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 11.0),
                              child: Row(
                                children: [
                                  getTextWidget(
                                      title: AppLocalizations.of(context)!
                                          .locatedat,
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightSemiBold,
                                      textColor: const Color(0xff818181)),
                                  // const SizedBox(
                                  //   width: 5.0,
                                  // ),
                                  getTextWidget(
                                      title:
                                          " : ${hiredapplicantList[index].address!}",
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightMedium,
                                      textColor: const Color(0xff818181))
                                ],
                              ),
                            ) // Padding(
                            //   padding:
                            //       const EdgeInsets.only(top: 15.0, right: 10.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       CustomizeButton(
                            //         borderWidth: 1.5,
                            //         text: 'Reject',
                            //         onPressed: () {},
                            //         borderColor: bluecolor,
                            //         textcolor: bluecolor,
                            //         color: whitecolor,
                            //         buttonHeight: 35,
                            //         buttonWidth: screenSize!.width / 2.5,
                            //       ),
                            //       CustomizeButton(
                            //         text: 'Accept',
                            //         onPressed: () {},
                            //         buttonHeight: 35,
                            //         buttonWidth: screenSize!.width / 2.5,
                            //       )
                            //     ],
                            //   ),
                            // )

                            // // Padding(
                            //   padding: const EdgeInsets.only(top: 9.0),
                            //   child: Row(
                            //     children: [
                            //       getTextWidget(
                            //           title:
                            //               '${ApplicantDetail[index].daysago.toString()} days ago',
                            //           textFontSize: fontSize13,
                            //           textFontWeight: fontWeightRegular,
                            //           textColor: bluecolor),
                            //       Padding(
                            //         padding: const EdgeInsets.only(
                            //             left: 18.0, top: 2.0),
                            //         child: Image.asset(
                            //           icDash,
                            //           width: 6,
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 12,
                            //       ),
                            //       getTextWidget(
                            //           title:
                            //               '${ApplicantDetail[index].noofApplicant!.toString()} Applicants',
                            //           textFontSize: fontSize13,
                            //           textFontWeight: fontWeightRegular,
                            //           textColor: darkblack)
                            //     ],
                            //   ),
                            // ),
                            // // const Spacer(),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       bottom: 17.0, right: 10.0, top: 15.0),
                            //   child: Row(
                            //     children: [
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(33.0),
                            //             color: lightbordercolorpro),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 10.0,
                            //               right: 10.0,
                            //               top: 2.0,
                            //               bottom: 2.0),
                            //           child: getTextWidget(
                            //               title: ApplicantDetail[index]
                            //                   .workType!
                            //                   .toString(),
                            //               textFontSize: fontSize12,
                            //               textFontWeight: fontWeightMedium,
                            //               textColor: darkblack),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 11.0,
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(33.0),
                            //             color: lightbordercolorpro),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 10.0,
                            //               right: 10.0,
                            //               top: 2.0,
                            //               bottom: 2.0),
                            //           child: getTextWidget(
                            //               title:
                            //                   '\$ ${ApplicantDetail[index].payPerhrs!.toString()} per hour',
                            //               textFontSize: fontSize12,
                            //               textFontWeight: fontWeightMedium,
                            //               textColor: darkblack),
                            //         ),
                            //       ),
                            //       const Spacer(),
                            //       Image.asset(
                            //         icSaved,
                            //         height: 24.0,
                            //         width: 24.0,
                            //         color: darkblack,
                            //         fit: BoxFit.cover,
                            //       )
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  getApplicantList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applicantList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => const MyJobDetail()));
                    },
                    child: Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: whitecolor,
                          border:
                              Border.all(color: lightbordercolorpro, width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(6.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 10.0, bottom: 20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 73,
                                  width: 73,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6.0),
                                    border: Border.all(
                                        width: 1, color: lightbordercolorpro),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: CachedNetworkImage(
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                                    // height: 34.0,
                                                    // width: 34.0,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                                baseColor: Colors.grey[300]!,
                                                highlightColor:
                                                    Colors.grey[100]!,
                                                child: Container(
                                                  // height: 34.0,
                                                  // width: 34.0,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                          imageUrl: applicantList[index]
                                              .userImage!
                                              .toString()
                                          // height: 34,
                                          // width: 34,
                                          // fit: BoxFit.cover,
                                          ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 17.0, left: 15.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      getTextWidget(
                                          title: applicantList[index].userName!,
                                          textFontSize: fontSize15,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: darkblack),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      SizedBox(
                                        width: screenSize!.width - 178,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              icGreyLocation,
                                              height: 17,
                                              width: 17,
                                              fit: BoxFit.cover,
                                            ),
                                            const SizedBox(
                                              width: 4.0,
                                            ),
                                            Flexible(
                                              child: getTextWidget(
                                                  maxLines: 3,
                                                  title: applicantList[index]
                                                      .address!,
                                                  textColor: lightwhitecolor,
                                                  textFontSize: fontSize13,
                                                  textFontWeight:
                                                      fontWeightRegular),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 17, right: 10.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyApplicantDetails(
                                                      userId:
                                                          applicantList[index]
                                                              .userId!,
                                                      jobId:
                                                          applicantList[index]
                                                              .jobId,
                                                    ))).whenComplete(() {
                                          getApplicantstatusTypesapi();
                                        });
                                      },
                                      child: getTextWidget(
                                          title: AppLocalizations.of(context)!
                                              .viewword,
                                          textFontSize: fontSize14,
                                          textFontWeight: fontWeightSemiBold,
                                          textColor: bluecolor),
                                    )
                                    // Container(
                                    //   decoration: BoxDecoration(
                                    //       color: ApplicantDetail[index].status! ==
                                    //               'open'
                                    //           ? greencolor
                                    //           : lightgreypromax,
                                    //       borderRadius: BorderRadius.circular(33)),
                                    //   child: Padding(
                                    //     padding: const EdgeInsets.only(
                                    //         top: 2.0,
                                    //         bottom: 2.0,
                                    //         left: 10.0,
                                    //         right: 10.0),
                                    //     child: getTextWidget(
                                    //         title: ApplicantDetail[index].status! ==
                                    //                 'open'
                                    //             ? "Open"
                                    //             : "Closed",
                                    //         textFontSize: fontSize12,
                                    //         textFontWeight: fontWeightMedium,
                                    //         textColor: whitecolor),
                                    //   ),
                                    // ),
                                    )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 9.0),
                              child: getTextWidget(
                                  title:
                                      AppLocalizations.of(context)!.appliedfor,
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightRegular,
                                  textColor: shadowcolor),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: getTextWidget(
                                  title: applicantList[index].jobName!,
                                  textFontSize: fontSize15,
                                  textFontWeight: fontWeightMedium,
                                  textColor: darkblack),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, right: 10.0),
                              child: applicantList[index].jobseekingstatus != 2
                                  ? applicantList[index].statusOfHired == 0
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomizeButton(
                                              borderWidth: 1.5,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .reject,
                                              onPressed: () {
                                                acceptApplicantStatusapi(
                                                    applicantList[index]
                                                        .userId!,
                                                    'Reject');
                                              },
                                              borderColor: bluecolor,
                                              textcolor: bluecolor,
                                              color: whitecolor,
                                              buttonHeight: 35,
                                              buttonWidth:
                                                  screenSize!.width / 2.5,
                                            ),
                                            CustomizeButton(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .accept,
                                              onPressed: () {
                                                acceptApplicantStatusapi(
                                                    applicantList[index]
                                                        .userId!,
                                                    'Accept');
                                              },
                                              buttonHeight: 35,
                                              buttonWidth:
                                                  screenSize!.width / 2.5,
                                            )
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomizeButton(
                                              borderWidth: 1.5,
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .remove,
                                              onPressed: () {
                                                hiredApplicantstatusapi(
                                                    applicantList[index]
                                                        .userId!,
                                                    'Remove');
                                              },
                                              borderColor: bluecolor,
                                              textcolor: bluecolor,
                                              color: whitecolor,
                                              buttonHeight: 35,
                                              buttonWidth:
                                                  screenSize!.width / 2.5,
                                            ),
                                            CustomizeButton(
                                              text:
                                                  AppLocalizations.of(context)!
                                                      .hired,
                                              onPressed: () {
                                                showLocationDailogue(
                                                    applicantList[index]
                                                        .userId!);
                                                // hiredApplicantstatusapi(
                                                //     applicantList[index]
                                                //         .userId!,
                                                //     'Hired');
                                              },
                                              buttonHeight: 35,
                                              buttonWidth:
                                                  screenSize!.width / 2.5,
                                            )
                                          ],
                                        )
                                  : Center(
                                      child: getTextWidget(
                                          title: AppLocalizations.of(context)!
                                              .notlookingforjobs,
                                          textFontSize: fontSize16,
                                          textFontWeight: fontWeightMedium,
                                          textColor: darkblack),
                                    ),
                            )

                            // Padding(
                            //   padding: const EdgeInsets.only(top: 9.0),
                            //   child: Row(
                            //     children: [
                            //       getTextWidget(
                            //           title:
                            //               '${ApplicantDetail[index].daysago.toString()} days ago',
                            //           textFontSize: fontSize13,
                            //           textFontWeight: fontWeightRegular,
                            //           textColor: bluecolor),
                            //       Padding(
                            //         padding: const EdgeInsets.only(
                            //             left: 18.0, top: 2.0),
                            //         child: Image.asset(
                            //           icDash,
                            //           width: 6,
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 12,
                            //       ),
                            //       getTextWidget(
                            //           title:
                            //               '${ApplicantDetail[index].noofApplicant!.toString()} Applicants',
                            //           textFontSize: fontSize13,
                            //           textFontWeight: fontWeightRegular,
                            //           textColor: darkblack)
                            //     ],
                            //   ),
                            // ),
                            // // const Spacer(),
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       bottom: 17.0, right: 10.0, top: 15.0),
                            //   child: Row(
                            //     children: [
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(33.0),
                            //             color: lightbordercolorpro),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 10.0,
                            //               right: 10.0,
                            //               top: 2.0,
                            //               bottom: 2.0),
                            //           child: getTextWidget(
                            //               title: ApplicantDetail[index]
                            //                   .workType!
                            //                   .toString(),
                            //               textFontSize: fontSize12,
                            //               textFontWeight: fontWeightMedium,
                            //               textColor: darkblack),
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         width: 11.0,
                            //       ),
                            //       Container(
                            //         decoration: BoxDecoration(
                            //             borderRadius: BorderRadius.circular(33.0),
                            //             color: lightbordercolorpro),
                            //         child: Padding(
                            //           padding: const EdgeInsets.only(
                            //               left: 10.0,
                            //               right: 10.0,
                            //               top: 2.0,
                            //               bottom: 2.0),
                            //           child: getTextWidget(
                            //               title:
                            //                   '\$ ${ApplicantDetail[index].payPerhrs!.toString()} per hour',
                            //               textFontSize: fontSize12,
                            //               textFontWeight: fontWeightMedium,
                            //               textColor: darkblack),
                            //         ),
                            //       ),
                            //       const Spacer(),
                            //       Image.asset(
                            //         icSaved,
                            //         height: 24.0,
                            //         width: 24.0,
                            //         color: darkblack,
                            //         fit: BoxFit.cover,
                            //       )
                            //     ],
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  showLocationDailogue(int applicantid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: whitecolor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.setlocation,
                          textFontSize: fontSize18,
                          textFontWeight: fontWeightSemiBold,
                          textColor: darkblack),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 7.0, right: 34.0, left: 34.0),
                      child: Center(
                        child: getTextWidget(
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            title:
                                '${AppLocalizations.of(context)!.areyousureyouwanttohire} Wade Warren.',
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightRegular,
                            textColor: greycolor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: getTextWidget(
                          title: AppLocalizations.of(context)!.setlocation,
                          textFontSize: fontSize14,
                          textFontWeight: fontWeightMedium,
                          textColor: darkblack),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 9.0),
                      child: PrimaryTextFeild(
                        hintText: AppLocalizations.of(context)!.setlocation,
                        controller: _locationController,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomizeButton(
                        borderWidth: 1.5,
                        text: AppLocalizations.of(context)!.cancel,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        borderColor: bluecolor,
                        textcolor: bluecolor,
                        color: whitecolor,
                        buttonHeight: 35,
                        buttonWidth: screenSize!.width / 3,
                      ),
                      CustomizeButton(
                        text: AppLocalizations.of(context)!.hired,
                        onPressed: () {
                          hiredApplicantstatusapi(applicantid, 'Hired');
                          // setlocationapi(applicantid);
                        },
                        buttonHeight: 35,
                        buttonWidth: screenSize!.width / 3 - 8,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }
}
