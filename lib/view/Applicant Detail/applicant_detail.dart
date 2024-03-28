import 'dart:convert';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wconnectorconnectorflow/constants/api_constants.dart';
import 'package:wconnectorconnectorflow/utils/internetconnection.dart';
import 'package:wconnectorconnectorflow/view/Applicant%20Detail/model/applicant_detail.dart';
import 'package:http/http.dart' as http;
import '../../constants/color_constants.dart';
import '../../constants/font_constants.dart';
import '../../constants/image_constants.dart';
import '../../utils/button.dart';
import '../../utils/dailog.dart';
import '../../utils/progressdialog.dart';
import '../../utils/sharedprefs.dart';
import '../../utils/textfeild.dart';
import '../../utils/textwidget.dart';
import '../View Applicant/model/accpet_applicant.dart';
import '../View Applicant/model/hired_applicant.dart';

class MyApplicantDetails extends StatefulWidget {
  final int? userId;
  final int? jobId;
  const MyApplicantDetails({super.key, this.userId, this.jobId});

  @override
  State<MyApplicantDetails> createState() => _MyApplicantDetailsState();
}

class _MyApplicantDetailsState extends State<MyApplicantDetails> {
  final _locationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getApplicantsDetailapi();
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
              if (status == 'Accept') {
                getApplicantsDetailapi(showprogress: false);
              } else {
                Navigator.pop(context);
              }

              // getApplicantstatusTypesapi(showprogress: false);
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
              Navigator.pop(context, true);
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

  List<Data> _data = [];
  int? userid;
  String? userimg;
  String? username;
  String? userwork;
  String? useraddress;
  String? usermobile;
  String? useremail;
  String? userexpected;
  String? usercurrentsalary;
  String? userworkexperience;
  // String? userworktype;
  String? userworksummary;
  String? fromdate;
  String? todate;
  int? statusofhired;
  int? jobseekingstatus;
  List<JobRoles> jobrole = [];
  List<TypeOfWork> userworktype = [];
  List<WorkHistory> userworkhistory = [];
  bool isload = true;

  Future<void> getApplicantsDetailapi({bool showprogress = true}) async {
    if (await checkUserConnection()) {
      if (showprogress) {
        if (!mounted) return;
        ProgressDialogUtils.showProgressDialog(context);
      }
      try {
        var apiurl = "$userdetailsbyowner/${widget.userId}/${widget.jobId}";

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
        var getApplicantsList = ViewApplicantDetailModel.fromJson(jsonResponse);

        debugPrint(responsed.body);

        if (response.statusCode == 200) {
          debugPrint(responsed.body);
          ProgressDialogUtils.dismissProgressDialog();
          if (getApplicantsList.status == '1') {
            setState(() {
              _data = getApplicantsList.data!;
              for (var detail in _data) {
                userimg = detail.userImage;
                username = detail.userName;
                useraddress = detail.address;
                useremail = detail.userEmail;
                usercurrentsalary = detail.currentSalary;
                userexpected = detail.expectedSalary;
                usermobile = detail.phone;
                userwork = detail.aboutOfWork;
                userworkexperience = detail.workExperience;
                userid = detail.userId;
                // userworksummary = detail;
                statusofhired = detail.statusofhired;
                jobseekingstatus = detail.userJobSeekingStatus;
                jobrole = detail.jobRoles ?? [];
                userworkhistory = detail.workHistory ?? [];
                userworktype = detail.typeOfWork ?? [];
                // userworktype = detail.workType;
              }

              for (var date in userworkhistory) {
                todate = date.toDate!;
                fromdate = date.fromDate!;
                // DateTime? formattedToDate = DateTime.parse(date.toDate!);

                // todate = DateFormat('dd MMM yyyy').format(formattedToDate);
                // DateTime? formattedFromDate = DateTime.parse(date.fromDate!);
                // fromdate = DateFormat('dd MMM yyyy').format(formattedFromDate);
              }
              if (todate == '' && fromdate == '') {
                userworkhistory = [];
              }

              isload = false;
            });
            debugPrint('is it success');
            debugPrint('job seeking in api $jobseekingstatus');
            debugPrint('status of hired in api $statusofhired');
          } else {
            setState(() {
              jobrole = [];
              userworkhistory = [];
              userworktype = [];
            });

            // debugPrint('failed to load :-${getApplicantsList.message}');

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
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24.0,
              color: darkblack,
            )),
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: whitecolor,
        title: getTextWidget(
            title: AppLocalizations.of(context)!.applicantdetails,
            textFontSize: fontSize15,
            textFontWeight: fontWeightMedium,
            textColor: darkblack),
      ),
      body: isload
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.transparent,
              ),
            )
          : Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 14.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 87,
                      decoration: BoxDecoration(
                          color: bluecolor,
                          borderRadius: BorderRadius.circular(6)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10, bottom: 10.0),
                        child: Row(
                          children: [
                            ClipOval(
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 67.0,
                                  width: 67.0,
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
                                    height: 67.0,
                                    width: 67.0,
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        shape: BoxShape.circle),
                                  ),
                                ),
                                imageUrl: userimg!,
                                height: 67,
                                width: 67,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 13.0, left: 9.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTextWidget(
                                      title: username!,
                                      textFontSize: fontSize15,
                                      textFontWeight: fontWeightMedium,
                                      textColor: whitecolor),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Opacity(
                                    opacity: 0.7,
                                    child: getTextWidget(
                                      title: 'UI UX Designer',
                                      textFontSize: fontSize13,
                                      textFontWeight: fontWeightRegular,
                                      textColor: whitecolor,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    getContactInformation(),
                    getExpectedSalary(),
                    jobrole.isEmpty ? Container() : getUserWorkRole(),
                    getAcc(),
                    getWorktypeintrested(),
                    getWorkExperience(),
                    getWorkSummary(),
                    userworkhistory.isEmpty
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: getTextWidget(
                                title:
                                    AppLocalizations.of(context)!.workhistory,
                                textFontSize: fontSize20,
                                textFontWeight: fontWeightMedium,
                                textColor: darkblack),
                          ),
                    userworkhistory.isEmpty
                        ? Container()
                        : getWorkHistoryEdit(),
                    getButtons()
                  ],
                ),
              ),
            ),
    );
  }

  getWorkHistoryEdit() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: userworkhistory.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    width: screenSize!.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(width: 1, color: boxbordercolor)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20, top: 14.0, bottom: 14.0),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 3.0, bottom: 2.0),
                            child: getTextWidget(
                                title: userworkhistory[index]
                                    .companyName!
                                    .toString(),
                                textFontSize: fontSize15,
                                textFontWeight: fontWeightSemiBold,
                                textColor: darkblack),
                          ),
                        ),
                        const Divider(
                          color: boxbordercolor,
                          thickness: 1.0,
                          height: 1.0,
                        ),
                        Container(
                          color: lightbluepro,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0,
                                left: 20.0,
                                right: 82.0,
                                bottom: 18.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTextWidget(
                                        title: AppLocalizations.of(context)!
                                            .fromword,
                                        textColor: blackcolor,
                                        textFontSize: fontSize14,
                                        textFontWeight: fontWeightLight),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: getTextWidget(
                                          title: fromdate!,
                                          textFontSize: fontSize14,
                                          textFontWeight: fontWeightMedium,
                                          textColor: const Color(0xff848484)),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    getTextWidget(
                                        title: AppLocalizations.of(context)!
                                            .toword,
                                        textColor: blackcolor,
                                        textFontSize: fontSize14,
                                        textFontWeight: fontWeightLight),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: getTextWidget(
                                          title: todate!,
                                          textFontSize: fontSize14,
                                          textFontWeight: fontWeightMedium,
                                          textColor: const Color(0xff848484)),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  getButtons() {
    return Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: jobseekingstatus != 2 || statusofhired == 2
            ? statusofhired != 2
                ? statusofhired != 1
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomizeButton(
                            borderWidth: 2.5,
                            text: AppLocalizations.of(context)!.reject,
                            onPressed: () {
                              acceptApplicantStatusapi(userid!, 'Reject');
                            },
                            borderColor: bluecolor,
                            textcolor: bluecolor,
                            color: whitecolor,
                            buttonHeight: 45,
                            buttonWidth: screenSize!.width / 2.3,
                          ),
                          CustomizeButton(
                            text: AppLocalizations.of(context)!.accept,
                            onPressed: () {
                              acceptApplicantStatusapi(userid!, 'Accept');
                            },
                            buttonHeight: 45,
                            buttonWidth: screenSize!.width / 2.3,
                          )
                        ],
                      )
                    // :
                    : statusofhired == 1
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomizeButton(
                                borderWidth: 2.5,
                                text: AppLocalizations.of(context)!.remove,
                                onPressed: () {
                                  hiredApplicantstatusapi(userid!, 'Remove');
                                },
                                borderColor: bluecolor,
                                textcolor: bluecolor,
                                color: whitecolor,
                                buttonHeight: 45,
                                buttonWidth: screenSize!.width / 2.3,
                              ),
                              CustomizeButton(
                                text: AppLocalizations.of(context)!.hired,
                                onPressed: () {
                                  // hiredApplicantstatusapi(userid!, 'Hired');
                                  showLocationDailogue(userid!);
                                },
                                buttonHeight: 45,
                                buttonWidth: screenSize!.width / 2.3,
                              )
                            ],
                          )

                        //  applicantList[index].statusOfHired == 0

                        // Row(
                        //     mainAxisAlignment:
                        //         MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       CustomizeButton(
                        //         borderWidth: 1.5,
                        //         text: 'Remove',
                        //         onPressed: () {
                        //           hiredApplicantstatusapi(
                        //               applicantList[index].userId!,
                        //               'Remove');
                        //         },
                        //         borderColor: bluecolor,
                        //         textcolor: bluecolor,
                        //         color: whitecolor,
                        //         buttonHeight: 35,
                        //         buttonWidth: screenSize!.width / 2.5,
                        //       ),
                        //       CustomizeButton(
                        //         text: 'Hired',
                        //         onPressed: () {
                        //           hiredApplicantstatusapi(
                        //               applicantList[index].userId!,
                        //               'Hired');
                        //         },
                        //         buttonHeight: 35,
                        //         buttonWidth: screenSize!.width / 2.5,
                        //       )
                        //     ],
                        //   ),
                        : Container()
                : Container()
            : Container());
  }

  getWorkSummary() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.worksummary,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                width: screenSize!.width,
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, bottom: 15.0, right: 20.0, top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTextWidget(
                          title: userwork!,
                          textFontSize: fontSize13,
                          textFontWeight: fontWeightLight,
                          textColor: greycolor),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getUserWorkRole() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.workrole,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                width: screenSize!.width,
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
                  child: ListView.builder(
                      itemCount: jobrole.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: getTextWidget(
                                  title: jobrole[index].roleEnglish!,
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightLight,
                                  textColor: greycolor),
                            ),
                          ],
                        );
                      }),
                ))
          ],
        ),
      ),
    );
  }

  getWorkExperience() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.workexperience,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                width: screenSize!.width,
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: getTextWidget(
                            title: userworkexperience!.toString(),
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightLight,
                            textColor: greycolor),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getWorktypeintrested() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.worktypeintrested,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                width: screenSize!.width,
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userworktype.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: getTextWidget(
                                  title: userworktype[index].type!.toString(),
                                  textFontSize: fontSize13,
                                  textFontWeight: fontWeightLight,
                                  textColor: greycolor),
                            ),
                          ],
                        );
                      }),
                ))
          ],
        ),
      ),
    );
  }

  getAcc() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.accDetails,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                width: screenSize!.width,
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: getTextWidget(
                            title: AppLocalizations.of(context)!.accDetails,
                            textFontSize: fontSize13,
                            textFontWeight: fontWeightLight,
                            textColor: greycolor),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getExpectedSalary() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.expectedsalary,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              icDollar,
                              height: 24.0,
                              width: 24.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 9.0,
                            ),
                            getTextWidget(
                                title:
                                    '\$ $userexpected ${AppLocalizations.of(context)!.toword} \$ $usercurrentsalary',
                                textFontSize: fontSize13,
                                textFontWeight: fontWeightLight,
                                textColor: greycolor)
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

  getContactInformation() {
    return Padding(
      padding: const EdgeInsets.only(top: 11.0),
      child: Container(
        width: screenSize!.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(width: 1, color: boxbordercolor)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 14.0, bottom: 14.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 2.0),
                child: getTextWidget(
                    title: AppLocalizations.of(context)!.contactinformation,
                    textFontSize: fontSize15,
                    textFontWeight: fontWeightSemiBold,
                    textColor: darkblack),
              ),
            ),
            const Divider(
              color: boxbordercolor,
              thickness: 1.0,
              height: 1.0,
            ),
            Container(
                decoration: const BoxDecoration(color: lightbluepro),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 15.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          children: [
                            Image.asset(
                              icGreyLocation,
                              height: 24.0,
                              width: 24.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 9.0,
                            ),
                            getTextWidget(
                                title: useraddress!.toString(),
                                textFontSize: fontSize13,
                                textFontWeight: fontWeightLight,
                                textColor: greycolor)
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            icMobile,
                            color: greycolor,
                            height: 24.0,
                            width: 24.0,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 9.0,
                          ),
                          getTextWidget(
                              title: usermobile!.toString(),
                              textFontSize: fontSize13,
                              textFontWeight: fontWeightLight,
                              textColor: greycolor)
                        ],
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            icemail,
                            height: 24.0,
                            width: 24.0,
                            color: greycolor,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 9.0,
                          ),
                          getTextWidget(
                              title: useremail!,
                              textFontSize: fontSize13,
                              textFontWeight: fontWeightLight,
                              textColor: greycolor)
                        ],
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
